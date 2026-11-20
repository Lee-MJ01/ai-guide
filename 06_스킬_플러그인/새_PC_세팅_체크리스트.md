# 새 PC 세팅 체크리스트

> 요약: 새 PC에서 이 가이드와 스킬·플러그인을 쓰기까지의 순서. 위에서부터 하면 된다. | 언제: 새 PC, 포맷 후, 실습실 PC | 갱신: 2026-11-20

## 1. 기본 (계정만으로 끝나는 것)

- [ ] Claude 데스크톱 앱 로그인 → 계정 스킬(kr-cover-letter 등)이 자동으로 들어온다
- [ ] (큰 자료가 필요할 때만) Google Drive 데스크톱 설치·로그인 → `G:\내 드라이브\AI_공통_작업_가이드`
  - PDF 분석·freellmapi를 쓸 PC라면 이 폴더를 "오프라인 사용 가능"으로 설정 (온라인 전용 파일은 AI가 못 열 수 있음)
  - 용량이 부족하면 스트리밍 모드로 두고, 필요한 파일만 오프라인으로 지정

## 2. Claude Code를 쓸 PC라면

- [ ] Node.js, Git 설치 → Claude Code 설치·로그인 (`claude --version`으로 확인)
- [ ] 가이드 받기: `git clone --depth 1 https://github.com/Lee-MJ01/ai-guide.git %USERPROFILE%\ai-guide` (Drive 폴더 안에 받지 않는다)
- [ ] `~/.claude/CLAUDE.md`에 `00_공통기준/AI_연결_설정.md`의 2번 문구 추가
- [ ] 필요한 플러그인만 설치 (`스킬_플러그인_레지스트리.md`의 B·E 표)
  - 개발 작업: ECC (`scripts/install-ecc.cmd` 더블클릭으로 설치+로그)
  - 글 다듬기: korean-skills
  - 영상: hyperframes
  - `my-skills@ai-guide`는 계정 동기화가 되면 설치하지 않는다(중복)
- [ ] `claude plugin list` 결과를 `컴퓨터별_설치현황.md`에 기록하고 push

## 3. 스킬별 추가 준비 (쓸 때만)

| 스킬 | 필요한 것 |
| --- | --- |
| pdf-drive-analyzer | Python + `pip install pymupdf`, Google Drive 폴더 |
| freellmapi | Docker Desktop, Google Drive 폴더 |
| duel-chat | Codex CLI + 로컬 MCP 서버 `duel` 등록 |
| youtube-watch | Claude 데스크톱 앱 (내장 브라우저) |
| basic-memory | Python 3.12+, uv |

## 4. 주의

- 플러그인을 많이 켜 두면 매 대화마다 스킬 설명이 컨텍스트에 실려 토큰이 늘어난다. 안 쓰는 플러그인은 `/plugin`에서 끈다.
- 공용 PC(실습실 등)에서는 작업 후 Claude·Drive·GitHub 로그아웃. `[Drive]/05_LLM다루기/FreeLLMAPI-Sync`에 비밀키가 있다.
