# EarShot · 소리를 못 듣는 에이전트에게 귀를 달아 주는 도구

> 요약: Claude Code가 효과음을 말로 요청해 만들고, 소리 파일을 말·숫자로 설명받게 해 주는 무료 오픈소스 도구. 노션 정리(v0.4.0 기준)와 현재 공식 README(1.0.0)를 비교해 설치법을 최신으로 맞췄다. 직접 설치해 소리 만들기·MCP 연결까지 시험했다. | 언제: 영상·릴스·게임·앱에 효과음 넣기, Claude가 만든 영상 소리 점검 | 키워드: 효과음, SFX, 사운드, MCP, 영상 편집, hyperframes | 관련 스킬: earshot(플러그인), hyperframes | 출처: https://app.notion.com/p/Claude-EarShot-41006e6723208194875fc0e9032c68a1 , https://github.com/Leonxlnx/earshot | 갱신: 2026-11-22

## 자료 정보

- **노션 글:** "Claude한테 귀 달아 주는 EarShot" · 작성 @sebia.ai · 상태 표시 "시작 전" · v0.4.0(2026-10-22) 문서 기준, 글쓴이가 직접 설치·실행해 본 명령만 골랐다고 밝힘
- **공식 저장소:** `Leonxlnx/earshot` · MIT · 최신 릴리스 **1.0.0** (2026-11-22 확인)
- **분석 방식:** 공개 노션은 커넥터로 안 열려 내장 브라우저로 본문 수집, README는 GitHub에서 직접 확인

## 핵심 요약

AI 에이전트는 영상·게임 코드를 쓰지만 결과물의 소리를 들을 수 없어 효과음을 짐작으로 넣는다. EarShot은 ① 말로 요청하면 효과음을 코드로 렌더링하고(1.0 기준 922개 디자인 카탈로그), ② 없는 소리는 녹음 부품을 조합한 레시피로 만들고, ③ 소리 파일·영상 사운드트랙을 듣고 말과 숫자로 설명한다. GPU 없이 CPU로 돌고 CLI·파이썬·MCP 서버·Claude Code 플러그인으로 쓴다.

## v0.4 → 1.0에서 바뀐 점 (노션 글이 낡은 부분)

| 항목 | 노션(v0.4.0) | 현재 README(1.0.0) |
| --- | --- | --- |
| 중심 기능 | 소리 설명·순위(describe, rank), 효과음 은행 252개 | **`earshot make "<말>"`** 로 922개 카탈로그에서 만들기. 은행 252개·키트·forge는 "영상 사운드 도구"로 유지 |
| 기본 설치 | 클론 → venv → torch → `-e ".[mcp,llm,dev]"` → `doctor --load`(모델 1.1GB) | `pip install` 한 줄. **기본 설치는 모델 없이** 소리를 만든다. 듣기 기능만 `[listen]` 추가 설치 |
| Claude Code 연결 | `claude mcp add …` | MCP 또는 **플러그인**(`/plugin install earshot@earshot`) + 에이전트 스킬 2개 |

## 바로 써먹을 것

**1) 도구 설치 (PC별, Python 3.10+)**
```
pip install "earshot[mcp] @ git+https://github.com/Leonxlnx/earshot"
earshot make "a soft success sound" -o success.wav      # 동작 확인
```
- ogg·mp3·webm 저장과 영상 읽기에는 ffmpeg가 PATH에 있어야 한다(wav·flac는 없어도 됨).
- 소리 듣기·설명(describe, rank, sheet 등)까지 쓰려면 `[listen,mcp]`로 설치. 모델 약 1.1GB 다운로드, 디스크 약 2.2GB. 큰 torch를 피하려면 먼저 `pip install torch --index-url https://download.pytorch.org/whl/cpu`.
- **PyPI의 `earshot`은 다른 프로젝트**다. 반드시 GitHub 주소로 설치.

**2) Claude Code에 붙이기 (둘 중 하나)**
```
/plugin marketplace add Leonxlnx/earshot
/plugin install earshot@earshot
```
→ 명령 `/earshot:make <말>`, `/earshot:make-set ui|game|arcade|film [테마]` 생김. 플러그인이 MCP 서버도 띄우므로 아래 `mcp add`는 하지 않는다.
```
claude mcp add earshot --scope user -e EARSHOT_THREADS=3 -- earshot mcp
```
- 느린 PC는 Claude Code를 `MCP_TIMEOUT=60000`을 붙여 실행.
- 스킬만: `npx skills add Leonxlnx/earshot`

**3) 요청 요령 (노션·README 공통)**
- 쓰임새("로고용 소리")가 아니라 **소리 자체**를 영어로 묘사한다: 무엇이, 무엇을, 어떻게 내는 소리인지. 예: "a fast air whoosh".
- 영상 전체 점검은 `sheet`(화면 컷·소리 지점·스펙트로그램·음량을 그림 한 장으로).
- 필름 키트 프리셋: calm(글자 위주) · crisp(활기찬 제품) · minimal(효과음만) · launch(음악 컷).

**내 작업에 붙이기:** hyperframes·Remotion으로 영상 만들기 → EarShot으로 효과음 세트 생성 → 마지막 판단은 내 귀로.

## 직접 시험한 결과 (2026-11-22, 클라우드 작업 공간 Linux · Python 3.12 · uv)

- `uv pip install "earshot[mcp] @ git+https://github.com/Leonxlnx/earshot"` → **9초 만에 설치**, `earshot --version` = 1.0.0. 모델 다운로드 없음.
- `earshot make "a soft success sound" -o success.wav` → 4초(첫 실행, numba 컴파일 포함), 두 번째부터 약 2초. "a fast air whoosh" → `whoosh/fast` 0.3초짜리가 나오고 비슷한 후보 3개도 알려 준다.
- `earshot make "three variations of a footstep on gravel" -o step.ogg` → 서로 다른 발소리 파일 3개.
- `earshot kit init --preset calm -o kit.json` → `earshot kit render kit.json --out kit` → 64개 소리를 11초에 생성(벨·클릭·글자 효과 등 역할별). `earshot sfx list --kind whoosh` → 휙 소리 35개 목록. **노션의 sfx·kit 명령은 1.0에서도 그대로 동작한다.**
- `earshot doctor`: 은행 252개·레시피 99개 확인. `listen` 추가 설치 전에는 describe·rank·sheet가 설치 명령 안내만 한다.
- MCP: `claude mcp add earshot --scope user -e EARSHOT_THREADS=2 -- <venv>/bin/earshot mcp` → `claude mcp list`에서 Connected, 도구 20개 확인.
- **못 한 것:** 듣기 모델(huggingface)과 CPU용 torch(download.pytorch.org)는 그 작업 공간의 네트워크 허용 목록에 없어 받지 못했다. 그래서 describe·rank·sheet는 시험하지 못했다. 내 PC에서는 문제없을 것이다.
- **Windows에서:** `pip install` 한 줄 방식이면 venv 경로 차이(`.venv/Scripts/python`)를 신경 쓸 필요가 없다. mp3·ogg로 저장하거나 영상을 읽으려면 ffmpeg가 PATH에 있어야 한다.

## 주장과 확인할 점

- **믿을 만한 것(공식 LIMITS 문서, 노션 요약):** 음량·타이밍·소리가 화면 컷에 맞는지 같은 측정값, 단독 효과음 하나의 종류 판정(점수 strong일 때), 후보 중 설명에 가장 맞는 것 고르기.
- **참고만 할 것:** 여러 소리가 섞인 영상에서 소리 이름 붙이기 — 단독 소리는 절반쯤, 음악 밑 소리는 4분의 1쯤만 맞는다고 함. 소리 취향, 말소리 내용, 라이선스 판단은 못 함.
- **노션 글쓴이 실험:** 나레이션만 있는 38초 릴스에 `sheet`를 돌리니 컷 22개가 전부 목소리 때문에 "소리 있음"으로 잡혔다 → 목소리 많은 영상의 효과음 점검용으로는 약함.
- 코드로 만든 소리는 EarShot 자기 모델 점수가 높게 나오기 쉬워서, README도 사람 귀로 판단하라고 한다. 실제 녹음이 필요하면 같은 저장소의 `real-sound` 스킬(라이선스 확인 포함).
- 노션의 별 수(2026-11-06 기준 4,010개)는 다시 확인하지 않았다.

## 분석 한계

- 설치와 소리 만들기(make·sfx·kit)·MCP 연결은 직접 시험했다. 듣기 기능(describe·rank·sheet)은 모델을 못 받아 시험하지 못했다. `earshot --help`에 명령은 모두 있다.
- 노션 글이 소개하던 원본 릴스는 링크가 없어 보지 않았다.

## 출처

- 노션: https://app.notion.com/p/Claude-EarShot-41006e6723208194875fc0e9032c68a1
- 공식: https://github.com/Leonxlnx/earshot (README, LIMITS.md, SFX.md)
