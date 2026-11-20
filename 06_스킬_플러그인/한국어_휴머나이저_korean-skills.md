# AI로 쓴 한국어 티 지우기 · korean-skills(humanizer)

> 요약: AI 문장의 흔한 한국어 말투 5가지와, 이를 자동으로 고치는 daleseo/korean-skills의 humanizer 스킬 설치·사용법. | 언제: 자소서·보고서·게시글의 AI 티를 없앨 때 | 키워드: 휴머나이저, 번역투, 자소서 다듬기 | 관련 스킬: korean-skills(humanizer, grammar-checker, style-guide), kr-cover-letter | 출처: https://www.instagram.com/reel/Df6uze-SSAk/ | 갱신: 2026-11-20

## 게시물 정보

- **계정:** @koreaaicampus (코리아AI캠퍼스) · **게시:** 2026-11-19 18:13 (한국 시간)
- **형식:** 릴스 18초, 세로 영상 · **반응:** 좋아요 893 · 댓글 27 (수집 시점)
- **분석 방식:** 내장 브라우저로 캡션 수집 + 프레임 10장(2초 간격) 확인. 음성은 전사하지 않음. 저장소는 웹 검색으로 교차 확인. 수집 2026-11-20

## 핵심 요약

AI가 쓴 한국어에 자주 나오는 말투 다섯 가지를 짚고, 하나씩 고치기 어렵다면 클로드에 한국어 휴머나이저 스킬을 설치하라고 안내하는 짧은 영상이다. 화면은 자기소개서 예시 문장에 해당 표현을 표시하는 방식으로 진행되고, 후반부에 Claude 스킬 설정 화면이 나온다 [10~14초, 화면].

## AI 말투 5가지 (캡션·화면 기준, 고친 예는 내가 붙인 것)

| 유형 | 예 | 고치는 방향 |
| --- | --- | --- |
| 대조 문장 | "단순히 ~가 아니라" | 대조 없이 하고 싶은 말만 쓴다 |
| 접속사 남발 | "또한", "나아가" | 문장을 나누고 접속사를 뺀다 |
| 과한 수사 | "끊임없이 성장하는 열정" | 근거 있는 행동·수치로 바꾼다 |
| 번역투 | "~에 있어서", "~을 가지고 있습니다" | "~에서", "~이 있습니다" |
| 명사로 뭉개기 | "개선을 진행하였습니다" | "개선했습니다" |

## 바로 써먹을 것

**Claude 앱(계정 스킬로 등록 → 모든 기기에서 사용, 영상 방식):**
1. 저장소 `https://github.com/daleseo/korean-skills` 링크를 Claude 채팅에 넣고 "humanizer 스킬 설치해 줘"라고 요청 → 스킬 저장 카드에서 저장
2. "/humanizer 이 글 AI 티 안 나게 고쳐 줘"처럼 요청

**Claude Code(PC별):**
```
/plugin marketplace add daleseo/korean-skills
/plugin install korean-skills@korean-skills
```
호출: `/korean-skills:humanizer`, `/korean-skills:grammar-checker`, `/korean-skills:style-guide`
또는 `npx skills add daleseo/korean-skills@humanizer` (둘 중 하나만)

**내 작업에 붙이기:** kr-cover-letter로 자소서 초안 → humanizer로 말투 정리 → grammar-checker로 맞춤법 → 글자 수 재확인.

## 주장과 확인할 점

- **주장:** 설치하면 AI 티를 없애 준다.
  **확인:** 저장소는 실제로 있고 humanizer·grammar-checker·style-guide 3개 스킬로 구성된다. 스킬 소개 페이지들은 KatFishNet 연구를 근거로 AI 작문 패턴을 S1~S3 심각도로 분류해 고친다고 설명한다(패턴 수는 24개·40개로 페이지마다 다르게 적혀 있어 버전 차이로 보임). 탐지 정확도 수치는 논문 수치이며, 고친 글이 AI 탐지기를 통과한다는 보장은 아니다.
- **주장:** 구글 검색 → 링크를 채팅에 넣고 "설치해 줘".
  **확인:** Claude 앱에서는 링크만으로 자동 설치되는 것이 아니라, Claude가 내용을 읽고 스킬 저장을 제안하는 방식이다. 저장 카드에서 사용자가 저장해야 한다.
- 고친 문장이 사실과 다르게 바뀌지 않았는지(경험·수치) 반드시 다시 읽는다. `00_공통기준/AI_작업_공통원칙.md` 5번.

## 분석 한계

- 음성은 전사하지 않았다. 내레이션은 화면 하단 자막과 캡션으로 재구성했다.
- 2초 간격 프레임이라 중간 장면 일부는 보지 못했다.

## 출처

- 릴스: https://www.instagram.com/reel/Df6uze-SSAk/
- 저장소: https://github.com/daleseo/korean-skills
