# 해커톤 우승자의 클로드 코드 세팅 ECC 설치와 활용

## 게시물 정보
- **원문:** [Instagram 게시물](https://www.instagram.com/p/Df5qIsak2Ah/)
- **계정:** @prompt_what (프롬왓 | AI 크리에이터)
- **게시 시각:** 2026-11-18 23:12 UTC (한국 시간 11-19 08:12)
- **형식:** 캐러셀 9장 (표지 + 본문 1~6 + 댓글 안내 + 채널 홍보). 첫 장은 약 3초짜리 짧은 영상
- **반응:** 좋아요 162 · 댓글 258 (수집 시점 기준)
- **분석 방식:** 내장 브라우저로 캡션과 슬라이드 화면을 직접 수집하고, GitHub 저장소와 웹 자료로 주장을 교차 확인 · 수집일 2026-11-19
- **참고:** Linkscope(Apify·Gemini 파이프라인)는 이 작업 환경에서 API 네트워크가 막혀 실행하지 못해서, 같은 형식으로 직접 정리했습니다.

## 핵심 요약
Anthropic × Forum Ventures 해커톤(2025년 9월, NYC) 우승자 Affaan Mustafa가 매일 쓰던 Claude Code 세팅을 **ECC(Everything Claude Code)** 라는 플러그인으로 공개했다는 소개 게시물입니다. 명령 두 줄로 설치하면 역할별 에이전트와 스킬, 명령어가 한꺼번에 들어오고, `/ecc:plan`으로 코드를 짜기 전에 계획부터 세우게 할 수 있습니다. 마케팅·콘텐츠 스킬도 들어 있어서 개발자가 아니어도 한국어로 요청하면 쓸 수 있다고 강조합니다. 비공식 복사본에는 악성코드가 있을 수 있으니 공식 저장소에서만 받으라는 경고도 함께 나옵니다.

## 주요 내용
- **[1] 해커톤 우승자의 스킬** (화면): 우승자가 쓰던 요령을 스킬로 정리한 ECC가 무료로 공개됐고, GitHub 스타 약 30만 개라는 소개. 저장소 화면에 `affaan-m / ECC`, 브랜치 97개·태그 20개가 보입니다.
- **[2] 붙여 넣으면 설치 끝** (화면): Claude Code 입력창에 두 줄을 차례로 붙여 넣고, `/plugin list`에서 `ecc@ecc`가 보이면 준비 완료.
- **[3] AI 직원 72명 + 스킬** (화면): 한 번 설치로 스킬 327개, 명령어 98개, 에이전트 72개(기획·코드 리뷰·보안처럼 역할이 나뉨)가 들어온다고 설명.
- **[4] 계획이 먼저 나온다** (화면): `/ecc:plan "예약 페이지"`처럼 만들 것을 적으면 계획 → 테스트 → 구현 → 검토 → 확인 순서로 진행하고, 효과가 좋았던 방식은 기억했다가 다음 작업에 활용한다고 설명.
- **[5] 개발자가 아니어도** (화면): `brand-voice`(내 글을 읽고 말투 학습), `market-research`(경쟁사를 표로 비교), `content-engine`(글 하나를 플랫폼별로 변환) 같은 스킬이 있고, 한국어로 부탁해도 알맞은 스킬을 골라 씀.
- **[6] 처음이면 이 글부터** (화면): 제작자가 X에 올린 가이드("Anthropic Hackathon Winner – Tips & Tricks for Claude Code")를 추천하고, 이름이 같은 비공식 복사본에는 악성코드가 있을 수 있으니 `github.com/affaan-m/ECC`에서만 받으라고 경고.
- **[7] 댓글 유도** (화면): 댓글을 남기면 설치 명령, 한국어 프롬프트 6가지, 공식 경로 확인법, 업데이트·삭제법을 담은 정리본을 보내준다는 안내. 댓글 258개는 대부분 이 유도 때문으로 보입니다.

## 화면 분석
| 슬라이드 | 화면에만 있던 정보 |
| --- | --- |
| 표지 | "AI GUIDE · 1등 개발자가 매일 쓰는 클로드 직원 72명 드릴게요" + 점토 캐릭터 군단 이미지 (약 3초 영상) |
| 1 | GitHub 저장소 헤더 캡처: `affaan-m/ECC`, Public, Issues 93, PR 70, Branches 97, Tags 20 |
| 2 | 터미널 입력 `/plugin marketplace add https://github.com/…` (URL 일부가 화면에서 잘림) |
| 3 | 터미널 입력 `/plugin install ecc@ecc`, "설치 한 번 → AI 직원 0명 → 72명" 애니메이션 |
| 4 | 입력창에 `/ecc:plan "예약 페이지"` |
| 5 | 스킬 카드 4개: brand-voice, market-research, content-engine, 한국어로 부탁 |
| 6 | X 게시물 캡처: cogsec(@affaan), 2026년 1월 17일, Claude Code v2.1.11 / Opus 4.5 화면 |
| 7 | 정리본 미리보기 (흐리게 처리), 태그: 설치 명령 두 줄 · 한국어 프롬프트 6가지 · 공식 경로 확인 · 업데이트·삭제법 |
| 8 | @prompt_what 채널 홍보 |

## 주장과 확인할 점
- **주장:** 해커톤 1등 개발자.
  **확인:** 사실로 보입니다. 제작자 본인이 쓴 가이드에 zenith.chat으로 Anthropic × Forum Ventures 해커톤에서 우승했다고 적혀 있고, 여러 매체도 같은 내용을 전합니다. 다만 게시물 표현처럼 "우승했다고 직접 밝힌" 수준으로 받아들이는 게 정확합니다. ECC 자체가 수상작은 아니고, 우승 후 공개한 세팅입니다.
- **주장:** GitHub 스타 30만.
  **확인:** 수집 시점에 저장소는 스타 약 304.2k, 포크 약 44.8k였습니다.
- **주장:** 에이전트 72개 · 스킬 327개 · 명령어 98개.
  **확인:** 저장소 README에는 에이전트 71개, 스킬 314개, legacy command shim 98개로 나옵니다. 수치는 버전마다 바뀌므로 대략적인 규모로만 보는 게 좋습니다.
- **주장:** 설치 명령 두 줄.
  **확인:** README의 Claude Code 플러그인 설치법과 같습니다. 가이드형 설치(`npx ecc-universal@2.2.3 setup`)도 따로 있습니다.
- **주장:** `/ecc:plan`으로 계획 먼저.
  **확인:** README에 플러그인 설치 시 `/ecc:plan "기능 설명"`, 수동 설치 시 `/plan`을 쓴다고 나옵니다.
- **주장:** 비공식 복사본 주의.
  **확인:** 공식 README에도 서드파티 재업로드·미러에 악성코드가 있을 수 있다는 경고가 있습니다. 실제로 `everything-claude-code` 이름의 포크·미러가 Gitee 등 여러 곳에 있습니다(옛 저장소 이름이 `affaan-m/everything-claude-code`).
- **기타:** 라이선스 MIT, 최신 릴리스 v2.2.3(2026-10-01). Claude Code, Codex, Qoder는 네이티브 플러그인으로 지원하고, Cursor·OpenCode·Gemini 등은 어댑터로 지원합니다(기능이 일부 빠질 수 있음).

## 바로 써먹을 것
1. Claude Code 입력창에서 설치:
   ```
   /plugin marketplace add https://github.com/affaan-m/ECC
   /plugin install ecc@ecc
   ```
2. `/plugin list`로 `ecc@ecc`가 보이는지 확인합니다.
3. 기능 개발은 계획부터 시킵니다: `/ecc:plan "예약 페이지 만들기"`
4. 관리 명령(가이드형 설치 기준): `npx ecc-universal@2.2.3 list-installed`, `doctor`, `repair`, `uninstall --dry-run` → `uninstall`
5. 콘텐츠 작업: brand-voice / market-research / content-engine 스킬을 한국어로 요청해 봅니다.
6. **주의:** 반드시 `github.com/affaan-m/ECC`에서만 받고, 설치 전에 hooks와 권한 설정을 한 번 훑어보세요. 스킬 수백 개가 한꺼번에 들어오면 컨텍스트와 토큰 사용량이 늘 수 있으니 필요한 것만 켜는 편이 좋습니다(일반적인 주의 사항이며, 게시물에는 없는 내용).

## 게시물 캡션 요약
한국어와 영어로 같은 내용을 씁니다. 해커톤 우승자가 매일 쓰던 세팅을 ECC 플러그인 하나로 묶었고, 설치 명령 두 줄이면 에이전트와 스킬이 한꺼번에 들어오며, 클로드가 코드보다 계획을 먼저 세운다는 내용입니다. 출처로 `github.com/affaan-m/ECC`를 적어 두었습니다.

## 분석 한계
- 표지 영상(약 3초)은 음성이 거의 없어 음성 전사를 하지 않았습니다.
- 2번 슬라이드의 marketplace URL은 화면에서 잘려 있어서 README로 보완했습니다.
- 7번 슬라이드의 "한국어 프롬프트 6가지" 정리본은 댓글로만 받을 수 있어서 내용을 확인하지 못했습니다.
- 스타 수와 에이전트·스킬 수는 수집 시점 기준이며 계속 바뀝니다.

## 출처
- [affaan-m/ECC (GitHub)](https://github.com/affaan-m/ECC)
- [The Shorthand Guide to Everything Claude Code](https://cdn.jsdelivr.net/gh/affaan-m/ECC@main/the-shortform-guide.md)
