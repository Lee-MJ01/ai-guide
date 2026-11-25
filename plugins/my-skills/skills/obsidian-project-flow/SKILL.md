---
name: "obsidian-project-flow"
description: "여러 세션·여러 AI에 걸친 큰 프로젝트에서 저장소 안 Obsidian 볼트(docs/_ai/STATUS.md + 세션 기록 + ADR)로 작업 흐름을 이어갈 때 사용. '이어서 하자', '어디까지 했지', '세션 정리·인수인계해 줘', '이 프로젝트 문서 체계 잡아 줘', 큰 프로젝트 시작 시."
---

# Obsidian Project Flow

원칙: **기억은 대화가 아니라 저장소에 둔다.** 다음 AI(Claude·Codex·Cursor·Gemini 누구든)가 파일만 읽고 바로 이어갈 수 있게, 시작할 때 읽고 끝날 때 남긴다. Obsidian 앱은 사람이 보는 창일 뿐이고 AI는 파일을 직접 읽고 쓴다.

자세한 배경·폴더 구조·템플릿: ai-guide `02_개발학습/Obsidian_개발팀_프로젝트_가이드.md` 9장 (`https://raw.githubusercontent.com/Lee-MJ01/ai-guide/master/` + URL 인코딩 경로).

## 0. 볼트 찾기 (매 세션 첫 단계)

1. 프로젝트 루트(보통 git 루트)의 `AGENTS.md`에서 `obsidian-project-flow` 블록을 찾는다. 거기 적힌 볼트 경로를 쓴다.
2. 없으면 `_ai/STATUS.md`를 검색한다(`git ls-files '*_ai/STATUS.md'` 또는 파일 검색, 깊이 3까지).
3. 둘 다 없으면 → **1. 시작** 모드. 찾았으면 → **2. 이어가기** 모드.

| 사용자가 이렇게 말하면 | 모드 |
| --- | --- |
| "프로젝트 시작", "문서 체계 잡아 줘", 볼트 없음 | 1. 시작 |
| "이어서", "어디까지 했지", 새 세션의 첫 작업 요청 | 2. 이어가기 |
| 작업 도중 결정·오류 해결·설계 변경 | 3. 작업 중 기록 |
| "정리해 줘", "인수인계", "오늘 여기까지", 큰 단계 완료, 대화가 길어짐, AI를 바꾸기 직전 | 4. 마무리 |

## 1. 시작 (볼트가 없을 때)

1. 위치를 한 번만 확인한다. 기본값: git 저장소면 `<루트>/docs/`, 아니면 프로젝트 폴더 자체. 이미 `docs/`가 다른 용도(정적 사이트 등)면 사용자에게 묻는다.
2. 최소 골격만 만든다(나머지 폴더는 필요할 때 추가).
   ```
   docs/
   ├── 00. Home/Project Dashboard.md
   ├── 01. Project/Project Overview.md
   ├── 02. Architecture/ADR/
   ├── 03. Development/
   ├── 04. Meetings/
   ├── 05. Operations/
   ├── 99. Templates/          ← 아래 템플릿 + 필요 시 ADR·회의록·트러블슈팅 양식
   └── _ai/
       ├── STATUS.md
       └── sessions/
   ```
3. 루트 `AGENTS.md`에 아래 **AGENTS 블록**을 넣는다. 파일이 있으면 기존 내용은 그대로 두고 블록만 끝에 추가한다(이미 블록이 있으면 손대지 않음).
4. 루트 `CLAUDE.md`가 없으면 `@AGENTS.md` 한 줄로 만든다. 있으면 `@AGENTS.md` 줄이 없을 때만 맨 위에 추가한다.
5. `.gitignore`에 없으면 추가: `.obsidian/workspace.json`, `.obsidian/workspaces.json`, `.obsidian/workspace-mobile.json`, `.trash/`
6. 대화에서 알 수 있는 목표·범위·기술 스택으로 `Project Overview.md`와 `STATUS.md`를 채운다. 모르는 칸은 `(미정)`으로 두고 지어내지 않는다.
7. 첫 세션 기록을 남기고(4장 절차), 만든 파일 목록을 사용자에게 보고한다.

## 2. 이어가기 (세션 시작)

읽는 순서를 지킨다. 볼트 전체를 훑지 않는다.
1. `AGENTS.md`의 블록 → `_ai/STATUS.md`
2. `_ai/sessions/`에서 파일명 기준 최근 1~2개
3. STATUS의 "열어볼 문서"에 적힌 파일만
4. 드리프트 확인: `git log --oneline -10`과 `git status`를 STATUS의 "마지막 커밋"과 비교한다. STATUS 이후 커밋이나 기록 안 된 변경이 있으면 그 내용을 먼저 파악하고 보고에 포함한다.
5. 사용자에게 3~5줄로 보고한다: 지난번 어디까지 / 지금 단계 / 다음 할 일 1순위 / 막힌 점(있으면). 그다음 사용자의 요청을 수행한다. 요청이 STATUS의 다음 할 일과 다르면 요청을 따르고, 마무리 때 STATUS에 반영한다.

## 3. 작업 중 기록

- **기술 결정**(대안을 비교해 고른 것) → `02. Architecture/ADR/ADR-NNNN 제목.md` 새 파일. 번호는 기존 최대+1. 상태 `proposed`/`accepted`, 대안·근거·결과를 짧게.
- **해결한 오류**(재발 가능) → `03. Development/<영역>/Troubleshooting/` 에 증상→원인→해결→재발 방지.
- **설계·API·DB 변경** → 해당 문서를 같이 고친다. 코드와 문서가 어긋난 채 세션을 끝내지 않는다.
- 문서끼리는 `[[문서명]]`으로 연결한다. `_ai/` 파일에서는 다른 AI가 바로 열 수 있게 백틱 상대경로(`docs/02. Architecture/ADR/ADR-0003 ….md`)를 쓴다.
- 대화가 길어져 컨텍스트가 압축될 것 같으면 기다리지 말고 4장을 한 번 실행한다(중간 체크포인트).

## 4. 마무리 (체크포인트·인수인계)

1. `git pull --ff-only`(원격이 있고 허락된 경우)로 다른 AI·사람의 변경을 먼저 받는다.
2. **세션 기록 추가**: `_ai/sessions/YYYY-MM-DD-HHMM_<agent>_<주제>.md` (아래 템플릿). 기존 세션 파일은 고치지 않는다.
3. **STATUS 덮어쓰기**(아래 템플릿): 다음 AI가 이 파일만 읽고 시작할 수 있어야 한다. 80줄 이내. "다음 할 일"은 순서대로, 바로 실행 가능한 문장으로("로그인 API 테스트 작성" O, "테스트 보강" X).
4. 점검: STATUS의 경로가 실제로 존재하는지, 비밀 값·토큰·개인정보가 없는지, 날짜가 절대 날짜(`2026-11-25`)인지.
5. 커밋: 사용자가 허락했거나 `AGENTS.md`의 "커밋 정책"이 허용할 때만 `docs: session handoff YYYY-MM-DD (<agent>)`로 커밋한다. **push·PR은 사용자가 요청할 때만.** 허락이 없으면 변경 파일 목록만 보고한다.
6. 사용자에게 한두 줄로: 무엇을 남겼는지, 다음에 "이어서 하자"라고만 하면 된다는 것.

파일을 쓸 수 없는 환경(일반 채팅 등)이면 STATUS와 세션 기록 내용을 코드 블록으로 보여 주고, 저장 위치를 알려 준다.

## 5. 공통 규칙

- 여러 AI·사람이 동시에 일할 수 있다: 세션 기록은 각자 새 파일이라 충돌이 없다. STATUS는 고치기 직전에 다시 읽고, 내가 읽은 뒤 바뀌었으면 합쳐서 쓴다(남의 내용을 지우지 않는다).
- `<agent>` 표기: `claude-code`, `claude-app`, `codex`, `cursor`, `gemini` 등 소문자 한 단어.
- 작업 상태·담당자·마감의 원본이 GitHub Issues 등 다른 도구면 STATUS에는 링크만 두고 복제하지 않는다.
- 문서 사이트(MkDocs·Quartz)로 배포한다면 `_ai/`를 배포 제외 목록에 넣는다.
- 사용자 지시가 이 스킬과 다르면 사용자 지시를 따른다.

## 템플릿

### AGENTS 블록 (루트 `AGENTS.md`에 추가)
```markdown
<!-- obsidian-project-flow:start -->
## 작업 흐름 (모든 AI 공통)
- 문서 볼트: `docs/` (Obsidian으로 열 수 있는 Markdown)
- 작업 시작 전: `docs/_ai/STATUS.md` → `docs/_ai/sessions/` 최근 1~2개 → STATUS가 가리키는 문서만 읽는다.
- 작업 중: 기술 결정은 `docs/02. Architecture/ADR/`에 새 ADR, 설계가 바뀌면 관련 문서도 같이 고친다.
- 작업 끝·중간 체크포인트: `docs/_ai/sessions/YYYY-MM-DD-HHMM_<agent>_<주제>.md`를 새로 만들고 `docs/_ai/STATUS.md`를 최신으로 덮어쓴다.
- 커밋 정책: (예: 문서 변경은 로컬 커밋까지 허용, push·PR은 사용자 요청 시만)
- 비밀 값·토큰·개인정보는 어떤 문서에도 쓰지 않는다.
<!-- obsidian-project-flow:end -->
```

### `_ai/STATUS.md`
```markdown
---
type: status
updated: 2026-11-25 23:40
agent: claude-code
phase: 구현
---
# STATUS

## 목표
(이 프로젝트가 끝나면 무엇이 되어 있어야 하나, 1~2줄)

## 현재 단계
(기획 / 설계 / 구현 / 테스트 / 배포 중 어디, 무엇을 만드는 중인지)

## 다음 할 일 (순서대로)
1. 
2. 
3. 

## 진행 중 (손댔지만 안 끝난 것)
- 

## 막힌 점·사용자에게 물어볼 것
- 

## 최근 결정
- ADR-0003 … (`docs/02. Architecture/ADR/ADR-0003 ….md`)

## 열어볼 문서
- `docs/…`

## 마지막 커밋
`abc1234` 메시지 (커밋 안 한 변경이 있으면 여기에 적기)
```

### `_ai/sessions/YYYY-MM-DD-HHMM_<agent>_<주제>.md`
```markdown
---
type: session
date: 2026-11-25
agent: claude-code
topic: 로그인 API
---
# 2026-11-25 로그인 API (claude-code)

## 요청
## 한 일
## 바꾼 파일
- `src/...` — 무엇을
## 결정 (ADR 링크)
## 확인 못 한 것·남은 일
## 다음 AI에게
(함정, 주의할 점, 시도했다가 버린 방법)
```
