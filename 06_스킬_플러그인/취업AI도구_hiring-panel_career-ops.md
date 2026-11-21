# 취업 AI 도구 2종 · hiring-panel(이력서 심사단) · career-ops(공고 거르기)

> 요약: 이력서를 Claude 7명이 떨어뜨려 보고 고쳐 주는 hiring-panel 스킬과, 공고를 점수로 걸러 지원을 말려 주는 career-ops를 릴스 2개·소개 페이지·공식 README로 교차 확인해 정리했다. | 언제: 이력서 점검, 지원할 공고 고르기, 취업용 Claude Code 도구 설치 검토 | 키워드: 이력서 첨삭, ATS, 서류 심사, 공고 선별, 지원 관리, 커버레터 | 관련 스킬: kr-cover-letter, kr-company-research | 출처: https://www.instagram.com/p/Df0d_Dvh6Rf/ , https://shimteamjjang.vercel.app/resume , https://www.instagram.com/p/DfW3k3Iss51/ | 갱신: 2026-11-22

## 자료 정보

| 자료 | 계정·작성자 | 게시 | 형식 | 분석 방식 |
| --- | --- | --- | --- | --- |
| 릴스 Df0d_Dvh6Rf (hiring-panel) | @shimteamjjang_ai (심팀장) | 2026-11-15 | 39초, 일러스트 애니메이션 | 캡션 + 프레임 8장(약 5초 간격) |
| 소개 페이지 `/resume` | 심팀장 자료실 (위 릴스 댓글 DM으로 주는 페이지) | 2026-11-14 기준 | 웹 글 | WebFetch |
| 릴스 DfW3k3Iss51 (career-ops) | @claudical_official | 2026-11-05 | 47초, 화면 녹화 | 캡션 + 프레임 12장(4초 간격) |
| 공식 README | alexyc9381/hiring-panel-skill, career-ops-hq/career-ops | 2026-11-22 확인 | GitHub | 내장 브라우저 |

## 핵심 요약

- **hiring-panel**은 "이력서를 써 주는 AI"가 아니라 **떨어뜨리려는 심사단**이다. 자동 서류 심사 1명, 채용 매니저 1명, 서로 의견을 안 보는 독자 5명(매니저·경쟁 지원자·대표·30초 리크루터·팀 동료)이 각각 평가한 뒤, 문제를 심각한 순서로 합치고 고친 이력서를 써서 자동 심사를 다시 돌려 전후를 비교한다.
- **career-ops**는 공고를 붙여 넣으면 아직 열려 있는지, 내 이력서와 맞는지 점수를 매기고 **5점 만점 4점 미만이면 지원하지 말라고** 말린다. 넣을 만한 곳만 이력서·커버레터·지원 답변 초안을 만든다. 제출·메일 발송은 절대 하지 않는다.
- 둘 다 무료·MIT이고, 실행하면 Claude 요금제 사용량이 든다. 지금 가이드의 순서(공고 선별 → 기업분석 → 자소서)에서 **공고 선별 앞단(career-ops)**과 **서류 마무리 점검(hiring-panel)**을 채운다.

## hiring-panel

**하는 일 (README 기준)**
- 결과는 실행한 폴더의 `.hiring-panel/`에 `PANEL.md`(심사 결과)와 `RESUME-IMPROVED.md`(고친 이력서)로 저장
- 회사명·직함·날짜·숫자를 지어내지 않는다. 사실이 필요한 곳은 `[ADD: …]`로 비우고 묻는다
- 1회 실행 = 하위 에이전트 8번 호출

**설치 (Claude Code, 셋 중 하나)**
```
/plugin marketplace add alexyc9381/hiring-panel-skill
/plugin install hiring-panel-skill@hiring-panel-skill
```
- 또는 저장소 주소를 Claude Code에 붙여 넣고 "이 스킬 설치하고 /hiring-panel 동작 확인해 줘"
- 또는 `skills/hiring-panel` 폴더를 `~/.claude/skills/`에 복사 → 새 세션

**사용**
```
/hiring-panel ~/Documents/resume.pdf  <지원 회사·직무, 가능하면 공고 본문>
```

**릴스에서 나온 실험 (가상 인물 이력서)** [화면·캡션]
- 7명 모두 탈락 판정, 문제 10개 중 1위는 업무를 흐릿하게 적은 한 줄(7명 중 6명이 지적)
- 빈칸(`[ADD]`)을 그대로 둔 고친 이력서는 자동 심사에서 또 탈락, 빈칸을 채우자 통과 → **빈칸을 반드시 내 사실로 채워야 효과가 난다**

## career-ops

**하는 일 (README 기준)**
- 공고가 아직 열려 있는지, 재게시 공고인지 확인(유령 공고 의심 표시)
- 실제 이력서와 요구 조건을 비교해 A~H 항목으로 평가하고 1~5점. 4.0 미만은 지원 비추천(무시는 가능)
- 맞춤 이력서 PDF(ATS용), 커버레터, 지원서 답변, 연락할 사람과 메시지 초안
- 탈락이 쌓이면 패턴 분석으로 부족한 역량을 짚음
- **하지 않는 것:** 자동 제출, 메일 발송, 외부 전송(이력서는 내가 고른 AI 제공자에게만 감). 모든 기록은 내 PC에 남음
- Claude Code 외에 Codex·Gemini CLI·OpenCode 등에서도 동작. README 한국어판 있음

**설치**
```
npx @santifer/career-ops init     # ./career-ops 에 최신 릴리스를 받고 의존성 설치
cd career-ops
claude                            # 첫 실행 때 대화로 이력서·희망 직무를 물어 세팅
```
- 저장소는 `santifer/career-ops` → `career-ops-hq/career-ops`로 옮겨졌다(옛 주소는 자동 이동). Node.js 필요.
- 이미 `외부_추천_플러그인_25선.md`에 ★★★로 올라 있던 항목이다.

## 바로 써먹을 것

1. **공고 고르기:** 지원하려던 공고 1개를 career-ops에 붙여 넣고 4점 미만이면 접는다. 국내 공고는 기준을 `01_취업준비/채용공고_선별_가이드.md`와 함께 본다.
2. **기업·자소서:** 남은 공고는 kr-company-research → kr-cover-letter로 진행.
3. **서류 마무리:** 이력서를 hiring-panel에 공고와 함께 돌린다 → `[ADD]` 빈칸을 내 실제 경험으로 채운다 → 한 번 더 돌려 자동 심사 통과 확인.
4. 내 경력 자료는 `[Drive]/_개인/`에만 둔다. 결과 폴더(`.hiring-panel/`, `career-ops/`)를 이 공개 저장소 안에서 만들지 않는다.

## 주장과 확인할 점

- **주장(career-ops 릴스):** 공고 740개 중 672개를 버리고 취업. → **확인:** README에 "740개 평가, 68개 지원, 면접 12번, 합격 1번"으로 적혀 있어 수치는 일치(740−68=672). 만든 사람은 그 회사를 6개월 뒤 그만두고 지금은 career-ops를 만든다고 밝힘.
- **주장(hiring-panel 릴스):** 7명 모두 탈락. → 가상 인물 1명으로 한 실험이다. 일반화하지 말 것. README도 "면접을 보장하지 않는 구조화된 2차 의견"이라고 적음.
- **확인할 점:** 두 도구 모두 영어권 채용(ATS·LinkedIn·Greenhouse 등) 기준으로 만들어졌다. 한글 이력서·국내 채용 사이트(사람인·잡코리아 등)에서 얼마나 잘 되는지는 확인 못 함. 써 보고 이 문서에 결과를 적는다.

## 분석 한계

- 두 릴스 모두 음성 전사는 하지 않았다(캡션·화면 글자로 대체).
- career-ops 릴스의 "고정 댓글 설치 방법"은 로그인이 필요해 못 봤다. 설치법은 공식 README로 대신했다.
- 두 도구 모두 직접 설치해 돌려 보지는 않았다. 설치하면 `스킬_플러그인_레지스트리.md` B표와 `컴퓨터별_설치현황.md`로 옮긴다.

## 출처

- hiring-panel: https://github.com/alexyc9381/hiring-panel-skill (Alex Chen, @nocodealex)
- career-ops: https://github.com/career-ops-hq/career-ops (만든 사람 @santifer)
- 릴스: https://www.instagram.com/p/Df0d_Dvh6Rf/ , https://www.instagram.com/p/DfW3k3Iss51/
- 소개 페이지: https://shimteamjjang.vercel.app/resume
