---
name: "youtube-watch"
description: "YouTube·인스타그램 릴스 링크 분석·요약 요청이나 \"이 강의 보고 스킬로 만들어 줘\" 요청 시 사용. 내장 브라우저로 자막과 장면 프레임을 수집해 근거 있는 분석 md를 만들고, 원하면 강의를 스킬로 바꾼다."
---

# youtube-watch — 클로드에게 영상 보는 눈 달기

claude-video(`/watch`, Claude Code 전용)의 아이디어를 이 앱의 클로드에서 쓸 수 있게 옮긴 절차다.
**자막 = 귀, 프레임 = 눈.** 둘 다 모은 뒤에만 분석하고, 보지 못한 것은 추측하지 않는다.

## 0. 모드 결정 (사용자 요청에서 판단, 애매하면 기본값)

| 모드 | 언제 | 결과물 |
| --- | --- | --- |
| `analyze` (기본) | "분석해 줘", "정리해 줘", "요약" | Linkscope 형식 분석 md |
| `learn` | "보고 배워서 스킬로", "이 방식대로 쓰게 해 줘" | 분석 md + 스킬 제안 카드 |
| `focus` | 특정 구간·질문("12분쯤 코드 뭐야?") | 해당 구간만 촘촘히 보고 답변 |

## 1. 브라우저 준비

- 내장 브라우저 도구(`mcp__Claude_Browser__*` 또는 `mcp__remote-devices__Claude_Browser__*`)를 ToolSearch로 한 번에 불러오고, 첫 사용 전 `built-in-browser` 스킬을 읽는다. 없으면 Claude in Chrome 도구로 같은 스크립트를 실행한다.
- `preview_start`로 영상 URL을 열고 `tabId`를 기억한다. 이후 모든 호출에 `tabId`를 넘긴다.
- 클라우드 셸(Bash)이나 기기 셸에서 YouTube·Gemini·Apify를 직접 부르지 않는다. 대부분 네트워크 허용 목록에 막혀 있다. 영상 수집은 브라우저에서만 한다.

## 2. 메타데이터 + 자막 수집 (YouTube)

`javascript_tool`로 아래를 그대로 실행한다. 결과는 `window.__yt`에 저장된다.

```js
const mp = document.querySelector('#movie_player');
const pr = mp?.getPlayerResponse?.() || window.ytInitialPlayerResponse; // SPA 이동 후엔 ytInitialPlayerResponse가 낡을 수 있어 player 우선
const vd = pr?.videoDetails || {}, mf = pr?.microformat?.playerMicroformatRenderer || {};
const sleep = ms => new Promise(r => setTimeout(r, ms));
document.querySelector('#description #expand, tp-yt-paper-button#expand')?.click(); await sleep(600);
document.querySelector('ytd-video-description-transcript-section-renderer button')?.click();
const TS = /^\d{1,2}(:\d{2}){1,2}$/, DUR = /(초|분|시간|seconds?|minutes?|hours?)$/i;
let best = null;
for (let i = 0; i < 30 && !best; i++) {
  await sleep(500);
  const cands = [...document.querySelectorAll('ytd-engagement-panel-section-list-renderer')]
    .map(p => ({ p, lines: p.innerText.split('\n').map(s => s.trim()).filter(Boolean) }))
    .map(o => ({ ...o, n: o.lines.filter(l => TS.test(l)).length }))
    .filter(o => o.n > 3 && /스크립트|Transcript/i.test(o.lines.slice(0, 8).join(' ')))
    .sort((a, b) => b.n - a.n);
  best = cands[0] || null;
}
const out = [];
if (best) { const L = best.lines; for (let i = 0; i < L.length; i++) {
  if (/^(챕터|Chapter) \d+:/i.test(L[i])) { out.push('\n## ' + L[i].replace(/^(챕터|Chapter) \d+:\s*/i, '')); continue; }
  if (TS.test(L[i])) { let j = i + 1; if (L[j] && DUR.test(L[j]) && L[j].length < 25) j++; if (L[j] && !TS.test(L[j])) { out.push('[' + L[i] + '] ' + L[j]); i = j; } }
} }
window.__yt = { id: vd.videoId, title: vd.title, channel: vd.author, lengthSeconds: +vd.lengthSeconds, views: +vd.viewCount,
  published: mf.publishDate, category: mf.category, isLive: vd.isLiveContent, description: vd.shortDescription,
  captionTracks: (pr?.captions?.playerCaptionsTracklistRenderer?.captionTracks || []).map(t => t.languageCode + (t.kind === 'asr' ? '(auto)' : '')),
  transcript: out.join('\n').trim() };
({ ...window.__yt, transcript: undefined, transcriptChars: window.__yt.transcript.length, transcriptLines: out.length })
```

- 이어서 `window.__yt.transcript.slice(0, 40000)`, `slice(40000, 80000)`처럼 나눠 읽는다.
- `transcriptLines`가 0이면 영상에 자막이 없는 것이다. 이때는 프레임을 더 촘촘히(아래 표의 2배) 보고, 결과에 "음성 미분석"이라고 적는다.
- 자동 생성 자막(`ko(auto)`)은 고유명사가 자주 틀린다(예: "재브" → JEV). 화면 글자로 교차 확인하고 고친 표기를 쓴다.
- `timedtext` URL을 직접 fetch하면 빈 응답이 오므로 쓰지 않는다. 스크립트 패널만 사용한다.

## 3. 장면 프레임 수집

### 3-1. 도우미 함수 등록 (한 번만)

```js
window.__grab = async (times) => {
  const mp = document.querySelector('#movie_player'), v = document.querySelector('video.html5-main-video') || document.querySelector('video');
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  mp?.mute?.(); v.muted = true;
  for (let k = 0; k < 40 && mp?.classList.contains('ad-showing'); k++) { document.querySelector('.ytp-skip-ad-button, .ytp-ad-skip-button-modern')?.click(); await sleep(1000); }
  window.__frames = window.__frames || [];
  const got = [];
  for (const t of times) {
    if (mp?.seekTo) { mp.seekTo(t, true); mp.pauseVideo(); } else { v.pause(); v.currentTime = t; }
    await sleep(300);
    for (let n = 0; n < 50 && (v.seeking || v.readyState < 2); n++) await sleep(200);
    await sleep(150);
    const c = document.createElement('canvas'); c.width = v.videoWidth; c.height = v.videoHeight;
    c.getContext('2d').drawImage(v, 0, 0);
    try { c.toDataURL('image/jpeg', 0.1); } catch (e) { return 'tainted: ' + e.message; }
    __frames.push({ t, c }); got.push(t);
  }
  return { captured: got.length, total: __frames.length, size: v.videoWidth + 'x' + v.videoHeight };
};
window.__sheet = (page, cols = 2, rows = 3, W = 390) => {
  document.getElementById('__sheet')?.remove();
  const fr = __frames.slice(page * cols * rows, (page + 1) * cols * rows); if (!fr.length) return 'no frames';
  const ar = fr[0].c.height / fr[0].c.width, H = Math.round(W * ar);
  const s = document.createElement('canvas'); s.id = '__sheet'; s.width = W * cols; s.height = H * Math.ceil(fr.length / cols);
  Object.assign(s.style, { position: 'fixed', top: '0', left: '0', zIndex: 2147483647, width: s.width + 'px', height: s.height + 'px' });
  const g = s.getContext('2d'); g.fillStyle = '#fff'; g.fillRect(0, 0, s.width, s.height);
  fr.forEach((f, k) => { const x = (k % cols) * W, y = Math.floor(k / cols) * H;
    g.drawImage(f.c, x + 1, y + 1, W - 2, H - 2);
    const lab = Math.floor(f.t / 60) + ':' + String(Math.floor(f.t % 60)).padStart(2, '0');
    g.fillStyle = 'yellow'; g.fillRect(x + 2, y + 2, 58, 18); g.fillStyle = '#000'; g.font = 'bold 13px sans-serif'; g.fillText(lab, x + 6, y + 16); });
  document.body.appendChild(s); return { w: s.width, h: s.height, frames: fr.map(f => f.t), pages: Math.ceil(__frames.length / (cols * rows)) };
};
window.__zoom = (i, fx0, fy0, fx1, fy1, W = 780) => { // 프레임 i의 일부(0~1 비율)를 크게: 작은 글씨·코드 판독용
  document.getElementById('__sheet')?.remove();
  const f = __frames[i].c, sx = fx0 * f.width, sy = fy0 * f.height, sw = (fx1 - fx0) * f.width, sh = (fy1 - fy0) * f.height;
  const s = document.createElement('canvas'); s.id = '__sheet'; s.width = W; s.height = Math.round(W * sh / sw);
  Object.assign(s.style, { position: 'fixed', top: '0', left: '0', zIndex: 2147483647, width: s.width + 'px', height: s.height + 'px' });
  s.getContext('2d').drawImage(f, sx, sy, sw, sh, 0, 0, s.width, s.height); document.body.appendChild(s); return { w: s.width, h: s.height };
};
window.__frames = []; 'ready'
```

### 3-2. 어떤 시점을 볼지 (프레임 예산)

| 영상 길이 | 기본 간격 | 상한 |
| --- | --- | --- |
| 1분 이하(쇼츠·릴스) | 2~3초 | 24장 |
| 10분 이하 | 15초 | 40장 |
| 10~30분 | 챕터 시작점 + 45초 간격 | 40장 |
| 30분 초과 | 챕터마다 2장 + 자막에서 고른 지점 | 60장. 더 필요하면 `focus` 모드로 구간을 좁히자고 제안 |

여기에 **자막에서 고른 지점**을 반드시 더한다. "화면 보시면", "이렇게", "여기", "코드", "설정", "결과", 숫자·표·그래프 언급이 나오는 타임스탬프 +1~2초다. 강의 영상은 이런 순간에 핵심 정보가 화면에만 있다.
`__grab([...])` 한 번에 12~15개씩 나눠 호출한다(한 호출이 너무 길어지지 않게).

### 3-3. 프레임 보기

1. `javascript_tool`로 `__sheet(0)`을 실행한다(가로 영상 2×3=6장, 세로 영상은 `__sheet(0, 3, 2, 250)`).
2. **다음 호출에서 따로** `computer`의 `zoom`으로 `region [0, 0, w, h]`를 캡처한다(scale 0.6~1). 같은 블록에서 병렬로 부르면 이전 화면이 찍힌다.
3. 찍힌 화면이 바뀌지 않았으면 `computer wait` 1초 후 다시 zoom한다.
4. 작은 글씨·코드·표는 `__zoom(i, x0, y0, x1, y1)`로 해당 영역만 키워서 읽는다.
5. 페이지 수만큼 반복한다. 다 본 뒤 `document.getElementById('__sheet')?.remove()`를 실행한다.

## 4. 인스타그램 릴스일 때

- 캡션·좋아요·댓글 수·게시일: `meta[property="og:description"]`, `og:url`(reel 여부), `time[datetime]`.
- 로그인 팝업이 영상을 가린다. 캡처는 canvas로 하므로 상관없지만, 시트를 보기 전에 `video` 요소를 `display:none`으로 숨기고 페이지 위 고정 요소를 `visibility:hidden` 처리한다.
- `__grab`은 `#movie_player`가 없으면 `video.currentTime`으로 동작한다. 처음 버퍼가 30초 정도만 있어도 seek하면 이어서 받아진다.
- 음성 자막이 없으므로 화면 하단 자막을 이어 붙여 내레이션을 재구성하고, 작은 보조 자막은 `__zoom`으로 읽는다.

## 5. 분석 원칙

- **근거 표시:** 모든 주장에 `[mm:ss]`을 붙인다. 화면에서 읽은 것은 "(화면)", 자막에서 들은 것은 "(음성)"으로 구분한다.
- **음성과 화면 교차 확인:** 자막 오탈자는 화면 글자로 고친다. 둘이 다르면 둘 다 적는다.
- **주장과 사실 분리:** 영상 속 수치·성능 주장은 "주장과 확인할 점"에 따로 적는다. 언급된 도구·저장소·논문은 WebSearch/WebFetch로 원본을 확인하고 차이를 적는다.
- **한계 명시:** 프레임 간격, 자막 품질(자동 생성 여부), 보지 못한 구간을 "분석 한계"에 적는다.
- **저작권:** 자막을 통째로 옮기지 않는다. 요약하고, 인용은 15단어 미만으로 꼭 필요한 한 군데만 쓴다.

## 6. 결과 md 형식 (Linkscope `output/youtube/` 호환)

```markdown
# <내용을 설명하는 제목>

## 영상 정보
- **원문:** [YouTube 영상](https://www.youtube.com/watch?v=<id>)
- **채널:** / **게시 시각:** / **길이:** N초 (mm:ss) / **조회수:**
- **자막:** ko(auto) 등 / **분석 방식:** 브라우저 수집 · 프레임 N장(간격) · 수집일

## 핵심 요약          (3~5문장)
## 주요 내용          (불릿 5~10개, [mm:ss] 근거 포함)
## 음성 내용 요약     (흐름 위주 요약)
## 화면 분석          (화면에만 있던 정보: 슬라이드, 코드, 설정값, 표, 데모 결과)
## 시간대별 내용      (- **mm:ss:** 한 줄씩, 챕터가 있으면 챕터 기준)
## 주장과 확인할 점   (- **주장:** … / - **확인:** 원본·근거 확인 결과)
## 바로 써먹을 것     (실행 단계, 명령어, 프롬프트, 체크리스트)
## 영상 설명 요약     (설명란의 링크·챕터·자료 안내)
## 분석 한계
```

**저장:** Linkscope 폴더(`…\AI 콘텐츠 수집·분석 도구`)가 연결돼 있으면 `output\youtube\<제목>__<id>.md`(릴스는 `output\<제목>__<shortcode>.md`)로 `device_commit_files`를 써서 저장한다. 파일명에서 `\ / : * ? " < > |`는 빼거나 바꾼다. 연결돼 있지 않으면 `SendUserFile`로 전달한다.

## 7. `learn` 모드: 강의를 스킬로 만들기

분석 md를 만든 뒤 이어서 진행한다.

1. **가르치는 '방법'만 추린다.** 사실 나열이 아니라 반복해서 쓸 수 있는 원칙, 순서, 판단 기준, 금지 사항, 템플릿을 찾는다. 각 항목에 근거 `[mm:ss]`를 메모해 둔다.
2. **강의가 실제로 다루는 범위를 정한다.** 강의에 없는 내용은 채워 넣지 않는다. 비어 있는 부분은 스킬의 "한계"에 적는다.
3. **SKILL.md 초안을 쓴다.** 구조:
   - frontmatter: `name`(영문 kebab-case), `description`(언제 쓰는지 한 문장)
   - 핵심 원칙(내 말로 다시 쓴 3~7개)
   - 작업 절차(1, 2, 3…)
   - 템플릿·체크리스트(예: 영업 메일 구조, 코드 리뷰 체크리스트)
   - 좋은 예 / 나쁜 예(강의 사례를 각색. 원문을 길게 옮기지 않음)
   - 출처(영상 제목, 채널, URL)와 한계
4. **같은 주제 스킬이 이미 있으면** 새로 만들지 않고 기존 스킬의 SKILL.md를 읽은 뒤 `edits`로 보강한다.
5. `propose_skills`로 저장 카드를 띄운다. 사용자에게는 스킬이 무엇을 할 수 있는지 한두 줄로만 말하고, 바로 시험해 볼 요청 문장 하나를 제안한다.

## 8. 막혔을 때

| 증상 | 대처 |
| --- | --- |
| 스크립트 버튼이 없음 | 자막 없는 영상이다. 프레임을 촘촘히 보고 "음성 미분석"으로 표기 |
| `tainted` 반환 | canvas 캡처 불가. `computer zoom`으로 플레이어 영역을 직접 캡처(시점마다 seek 후 1~2초 대기) |
| 프레임이 검게 나옴 | 해당 시점이 아직 버퍼링 전이다. 같은 시점을 다시 `__grab` |
| zoom이 "Screenshot timed out" | 한 번 더 시도. 반복되면 사용자에게 Claude 앱 창을 앞으로 띄워 달라고 요청 |
| 광고가 계속 나옴 | 광고가 끝날 때까지 기다린 뒤 다시 `__grab` |
| 로그인·연령 제한 영상 | 사용자에게 내장 브라우저에서 직접 로그인해 달라고 요청(비밀번호는 입력하지 않음) |
| 1시간 이상 강의 | 전체는 챕터·자막 위주로 요약하고, 화면이 중요한 구간만 `focus` 모드로 따로 보자고 제안 |