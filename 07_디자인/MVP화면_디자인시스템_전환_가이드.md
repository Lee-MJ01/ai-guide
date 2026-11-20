# AI로 만든 MVP 화면 → 디자인 시스템 전환 가이드

> 요약: ChatGPT로 화면 프롬프트 → Figma AI로 화면 생성·다듬기 → 원샷 프롬프트로 변수·컴포넌트·가이드 문서까지 만드는 6단계 실습 흐름. Claude Code + Figma 연결(Case B)과 재사용 스킬 만들기 포함. | 언제: 포트폴리오용 앱 화면, Figma 디자인 시스템 | 키워드: Figma, Variables, Auto Layout, 컴포넌트, 원티드 디자인 시스템 | 출처: 디자이너어(@designerangeuage) 노션 실습 가이드 | 갱신: 2026-11-20

원문(목차): https://app.notion.com/p/AI-MVP-41b4639f584f81c496c0ffb657f72f30
아래는 원문 흐름을 내 말로 요약한 것이다. 프롬프트 원문은 각 STEP 링크에서 복사한다.

## 0. 어떤 방법으로 할까

| | Case A (기본) | Case B (심화) |
| --- | --- | --- |
| 도구 | ChatGPT + Figma AI Agents | ChatGPT + Figma + Claude Code |
| 프롬프트 넣는 곳 | Figma 왼쪽 Agents 창 | Claude Code (데스크톱 앱 Code 탭 또는 VS Code 확장) |
| 준비물 | ChatGPT, AI 기능이 있는 Figma 요금제 | 위 + Claude 유료 계정 + Figma 커넥터(MCP) |

STEP 1~4는 두 방법이 같다. 예상 시간: STEP1 15분 · STEP2~3 20분 · STEP4 10분 · STEP5 30분 · STEP6 15분.

## 1. 절차

**STEP 1 · 화면 프롬프트 만들기** ([원문](https://app.notion.com/p/STEP-1-ChatGPT-41b4639f584f813e8a4dffec0f9a7917))
- ChatGPT GPTs에서 "곽송호의 바이브 디자인/코딩 프롬프트 생성"을 열고 "신규 디자인 프롬프트 생성".
- UX 목표 → 주요 사용자 → 핵심 가설 → 넣을 것/뺄 것, 4개 질문에 답하면 국문·영문 화면 제작 프롬프트가 나온다.
- Case A는 국문 프롬프트 복사. Case B는 "국문 PDF로 만들어 줘"로 받아 `프로젝트폴더/input/`에 넣는다.

**STEP 2~3 · Figma AI로 화면 만들고 다듬기** ([원문](https://app.notion.com/p/STEP-2-3-Figma-AI-41b4639f584f817286f6e32136501157))
- 새 Design 파일 → Agents 창에 프롬프트 붙여넣기 → 약 5분 뒤 화면 5개(MVP v0).
- 사용량 절약: 프롬프트 끝에 "핵심 화면 5개만 먼저 만들어줘"를 붙인다.
- 다듬기 ① 브랜드 분위기: 참고 URL을 주고 톤만 반영하게 한다. 포트폴리오용이면 **지원 회사 홈페이지 URL**을 주고 "로고·캐릭터·브랜드 색은 복제하지 말고 분위기와 정보 위계만 참고"라고 명시.
- 다듬기 ② 타겟에 맞게 콘텐츠·썸네일 교체. 글자·사진 한두 개는 손으로 고치는 게 빠르다.

**STEP 4 · 이 화면으로 취업할 수 있을까?** ([원문](https://app.notion.com/p/STEP-4-41b4639f584f81e99da9ee251970419a))
- Layers를 열어 확인: 전부 일반 Frame(#)이고 컴포넌트(◇)가 없음, 상태 전환 메뉴 없음, 색이 HEX 하드코딩, Styles 비어 있음.
- 실제 UI/UX 인턴 공고(원문 예: NHN)의 우대사항은 "팀이 함께 쓰고 개발자에게 넘길 수 있는 구조"를 요구한다 → STEP 5의 이유.

**STEP 5 · 원샷 프롬프트로 디자인 시스템 만들기** ([원문](https://app.notion.com/p/STEP-5-41b4639f584f81c09e75c3c39fa1ea86), [프롬프트 단독 페이지](https://app.notion.com/p/AI-41c4639f584f81e5b9f5df629eb9053a))
- 프롬프트는 수정 없이 붙여넣는다. AI가 0단계에서 화면 목록·서비스 성격·반복 UI를 스스로 찾는다.
- 구조·이름 규칙은 Figma 커뮤니티의 "Wanted Design System"을 따르되 색·로고는 가져오지 않는다. 다른 공개 디자인 시스템을 쓰려면 그 이름만 바꾼다. ([원티드 DS Figma](https://www.figma.com/design/CLk3Bnbc4d9oZjXTa2tEXR/Wanted-Design-System--Community-?node-id=0-1))
- 10~20분 걸리고 중간에 멈출 수 있다. 멈추면: "이어서 진행해. 이미 만든 변수·스타일·컴포넌트는 다시 만들지 말고 남은 단계부터 이어서 해."
- 단계별 내용과 검수 기준 → `디자인시스템_원샷프롬프트_구조.md`

**STEP 6 · 새 화면도 규칙대로 만들기** ([원문](https://app.notion.com/p/STEP-6-41b4639f584f813699e3c65f7e2fc1c7))
- Figma AI는 지난 대화를 기억하지 못하므로, 규칙을 파일 안 "Ⓜ Makers' Principle" 페이지에 적어 두고 매번 "그 페이지를 먼저 읽고 따르라"고 시킨다. 페이지가 없으면 원샷 프롬프트의 7단계만 다시 실행.
- 프롬프트에서 바꿀 곳은 "만들 화면: 화면 이름 – 들어갈 요소" 한 줄. 자리표시가 남아 있으면 AI가 먼저 묻도록 안전장치 문장을 넣는다.
- 새 화면에 필요한 컴포넌트가 없으면 먼저 컴포넌트로 만들고, 문서·Updates 버전(v1.1)을 같이 갱신하게 한다.

## 2. Case B · Claude Code로 하기 ([원문](https://app.notion.com/p/Case-B-Claude-Code-41b4639f584f81f3a87dc37b261cbfbb))

1. **열기:** Claude 데스크톱 앱 Code 탭에서 프로젝트 폴더 선택, 또는 VS Code에 "Claude Code for VS Code" 설치 후 폴더 열기.
2. **Figma 연결(한 번):** 데스크톱 앱 설정 → 커넥터에서 Figma 연결. VS Code라면 Claude Code에게 Figma 공식 MCP 서버(`https://mcp.figma.com/mcp`, HTTP, user 범위) 연결을 시키고 안내대로 로그인. 확인: "Figma 연결됐는지, 내 계정 이름 알려줘".
3. **프로젝트 준비(한 번):** Figma 파일 링크·서비스명·타겟을 주고 `CLAUDE.md`, `input/`, `docs/design-system.md`, `docs/CHANGELOG.md`를 만들게 한다. CLAUDE.md에 들어갈 핵심 규칙:
   - Figma에 쓰기 전 figma-use 스킬을 먼저 불러온다
   - 큰 작업은 단계로 나누고 단계마다 스크린샷으로 확인, 중간에 확인 질문 없이 끝까지
   - 지우거나 덮어쓰기 전에 Archive 페이지에 복제
   - 디자인 시스템 규칙(Instance+Auto Layout만, Semantic 변수·Text Style만, 컴포넌트 먼저, 문서 동시 갱신, 이름 규칙)
4. **실행:** 첫 줄에 "아래 원샷 프롬프트를 CLAUDE.md에 적힌 Figma 파일에 끝까지 실행해줘. 가이드 문서는 docs 폴더에도 같은 내용으로 정리해줘."를 쓰고 원샷 프롬프트를 붙여넣는다. 20분 이상 걸릴 수 있다.
5. **스킬로 만들기(STEP 6 대체):** 새 화면 만드는 순서를 개인 스킬 `ds-new-screen`(`~/.claude/skills/ds-new-screen/SKILL.md`)으로 저장해 두면 `/ds-new-screen 08 채팅 목록 – …` 한 줄로 실행된다. 스킬엔 순서만 넣고, 프로젝트별 규칙은 매번 그 Figma 파일의 Makers' Principle에서 읽게 하므로 다른 프로젝트에도 그대로 쓸 수 있다. 스킬 순서 요지: Makers' Principle 읽기(없으면 중단) → 컴포넌트·변수 목록 확인 → Instance+Auto Layout으로 화면 생성 → 없는 컴포넌트 먼저 생성 → Guidelines·Updates·docs 갱신 → 입력 화면은 미입력·오류·완료 상태 프레임 → 하드코딩·Detach 검사 후 표로 보고.
   - 이 스킬을 claude.ai 계정 스킬로 저장하면 모든 기기에서 쓸 수 있다(`06_스킬_플러그인/스킬_플러그인_레지스트리.md` A 종류).

## 3. 결과 확인 체크리스트

- [ ] 입력창 State·Status를 바꾸면 에러 모양 등으로 바뀐다
- [ ] 버튼 Disable=True면 흐려진다
- [ ] 하단 탭 Active Tab만 바꾸면 활성 탭이 바뀐다
- [ ] 요소 색에 HEX 대신 `Primary/Normal` 같은 변수 이름이 보인다
- [ ] 페이지 목록에 Foundation, Component, Guidelines, Makers' Principle이 있다
- [ ] (포트폴리오) 내가 직접 고친 부분을 기록해 두었다 — 원문이 강조하는 포인트

## 4. 확인하지 못한 부분

- STEP 1의 질문 4개 "예시 보기" 토글 내용, 완성 예시 PDF, 시연 영상(수업 중 공유), Figma 완성 파일 내부, NHN 공고 이미지는 열어 보지 못했다.
