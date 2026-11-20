# AI 연결 설정 · 가이드를 자동으로 보게 하기

> 요약: Claude 앱과 Claude Code가 작업 전에 GitHub `Lee-MJ01/ai-guide`의 `index.md`를 먼저 보도록 넣는 설정 문구와 위치. | 언제: 새 PC, 새 계정, 새 프로젝트 세팅 | 갱신: 2026-11-20

AI는 이 가이드를 스스로 찾아오지 않는다. 아래 문구를 한 번 넣어 두어야 "요청 → index.md 확인" 흐름이 자동으로 돌아간다.

## 1. Claude 앱 (웹·데스크톱·모바일 공통, 계정에 한 번)

설정 → 프로필 → 개인 선호도(또는 이 작업용 프로젝트의 지침)에 붙여넣는다.

```text
반복 작업·스킬·플러그인이 필요한 요청이면, 먼저 내 GitHub 저장소 Lee-MJ01/ai-guide의 index.md를 확인하고 규칙대로 필요한 문서 1~2개만 읽은 뒤 작업해줘.
가이드를 고칠 때는 00_공통기준/저장소_운영_규칙.md를 따르고, git을 쓸 수 없는 환경이면 바꿀 내용만 보여줘.
PDF·zip 같은 큰 파일과 비밀 설정은 Google Drive "AI_공통_작업_가이드" 폴더에 있어.
간단한 질문에는 가이드를 열지 마.
```

- 마지막 줄이 토큰 절약 핵심이다. 모든 질문마다 인덱스를 읽으면 오히려 낭비다.
- 저장소가 공개라서 일반 채팅에서도 `https://raw.githubusercontent.com/Lee-MJ01/ai-guide/master/index.md`로 읽힌다.
- 개인 배경(`[Drive]/_개인/사용자_배경.md`)은 Drive에만 있으니, 자소서·면접 작업 때는 Google Drive 커넥터나 PC 폴더 연결이 필요하다.

## 2. Claude Code (PC마다 한 번)

1. 가이드를 받는다 (동기화 폴더 밖, 1MB 안팎):
   ```
   git clone --depth 1 https://github.com/Lee-MJ01/ai-guide.git %USERPROFILE%\ai-guide
   ```
   macOS·Linux: `git clone --depth 1 https://github.com/Lee-MJ01/ai-guide.git ~/ai-guide`
2. `~/.claude/CLAUDE.md` (Windows `C:\Users\<사용자>\.claude\CLAUDE.md`) 맨 아래에 추가한다. 모든 프로젝트에 적용된다.

```markdown
## 공통 작업 가이드
- 반복 작업·스킬·플러그인이 필요한 요청이면 먼저 `git -C ~/ai-guide pull --ff-only` 후 `~/ai-guide/index.md`를 읽고 규칙대로 문서 1~2개만 연다.
- `~/ai-guide`가 없으면 `git clone --depth 1 https://github.com/Lee-MJ01/ai-guide.git ~/ai-guide`로 받는다. Google Drive 같은 동기화 폴더 안에는 받지 않는다.
- 가이드를 고칠 때는 `~/ai-guide/00_공통기준/저장소_운영_규칙.md`를 따른다 (pull → 수정 → 인덱스 갱신 → 커밋 → 바로 push).
- 필요한 플러그인이 `claude plugin list`에 없으면 `06_스킬_플러그인/스킬_플러그인_레지스트리.md`의 설치 명령을 제안한다.
- 간단한 질문에는 가이드를 열지 않는다.
```

## 3. 확인

- Claude 앱: "자소서 첨삭해 줘"라고 했을 때 `01_취업준비/index.md`를 먼저 여는지 본다.
- Claude Code: 새 세션에서 `/memory`로 CLAUDE.md에 문구가 들어갔는지 확인한다.
