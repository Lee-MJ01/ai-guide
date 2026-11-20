# Basic Memory · 여러 AI가 같이 쓰는 기억 노트 (MCP)

> 요약: AI가 대화 내용을 내 폴더의 마크다운 노트로 저장하고, 다음 대화나 다른 AI(Claude Desktop·Claude Code·Cursor·ChatGPT)에서 그 노트를 찾아 이어서 일하게 하는 MCP 서버 세팅법. | 언제: 새 채팅마다 프로젝트 설명을 반복할 때, AI를 갈아타며 작업할 때 | 키워드: 기억, 메모리, MCP, 세션 이어가기, Obsidian | 관련: Claude Code 플러그인 basic-memory | 출처: 공유받은 세팅 가이드(claude.ai 아티팩트, 원문 텍스트로 받음) + 공식 문서 교차 확인 | 갱신: 2026-11-20

## 한 줄 개념

AI에게 공용 노트장을 주는 것. "저장해줘" → 내 PC 폴더에 md 파일로 기록 → 다음엔 어떤 AI든 그 노트를 검색·읽기. 기억이 AI 회사 서버가 아니라 내 폴더에 있어서, 한도가 끝나 다른 AI로 넘어가도 설명을 다시 할 필요가 없다.

## 로컬 vs 클라우드

| | 로컬 | 클라우드 |
| --- | --- | --- |
| 가격 | 무료 (오픈소스) | 유료 구독 |
| 붙는 AI | Claude Desktop, Claude Code, Cursor, Codex | 왼쪽 + ChatGPT(Plus 이상) |
| 노트 위치 | 내 PC (기본 `~/basic-memory`) | 클라우드 (로컬 폴더로 동기화 가능) |
| 여러 기기 | 직접 챙겨야 함 | 자동 |

ChatGPT는 PC에 깔린 프로그램에 못 붙고 인터넷 서버에만 붙기 때문에, ChatGPT까지 쓰려면 클라우드가 필요하다. 처음엔 로컬로 시작해도 노트 형식이 같아 나중에 옮길 수 있다.

## 설치 (로컬)

- 요구사항: **Python 3.12 이상** (`python --version`)
- Windows·공통: `uv tool install basic-memory` (uv가 없으면 astral.sh에서 먼저 설치)
- macOS/Linux 한 줄 설치: `curl -LsSf https://basicmemory.com/install/latest.sh | sh` (uv 설치 + Claude Desktop 설정 여부를 물어봄)
- Homebrew: `brew tap basicmachines-co/basic-memory` → `brew install basic-memory`
- 확인: `basic-memory --version`
- 노트 위치 바꾸기: `basic-memory project add "my-notes" ~/Documents/my-notes` → `basic-memory project default "my-notes"` → AI 앱 재시작

## AI에 연결

연결 후 "Basic Memory 도구 뭐 있어?"라고 물어 도구 목록이 나오면 성공.

**Claude Desktop** — 설정 파일(Windows `%APPDATA%\Claude\claude_desktop_config.json`, macOS `~/Library/Application Support/Claude/claude_desktop_config.json`)의 `mcpServers` 안에 추가하고 앱을 완전히 종료 후 재시작:
```json
"basic-memory": { "command": "uvx", "args": ["basic-memory", "mcp"] }
```
Homebrew로 깔았으면 `"command": "basic-memory", "args": ["mcp"]`.

**Claude Code** — 공식 문서 기준 명령 (받은 가이드의 `claude mcp add basic-memory basic-memory mcp`는 `basic-memory`를 직접 설치한 경우의 형태):
```
claude mcp add basic-memory -- uvx basic-memory mcp
```
확인은 Claude Code 안에서 `/mcp`. 세션 요약·압축 전 저장 같은 기능은 별도 Claude Code 플러그인(`basic-memory@basicmachines-co`)을 MCP 연결 후 추가 설치.
클라우드: `claude mcp add -s user -t http basic-memory-cloud https://cloud.basicmemory.com/mcp` → `/mcp`에서 Authenticate.

**Cursor** — 설정의 MCP 메뉴 → 커스텀 MCP 추가 → Claude Desktop과 같은 JSON. 클라우드는 `"url": "https://cloud.basicmemory.com/mcp"`.

**ChatGPT** — Plus 이상 + 클라우드 계정. 설정 → 개발자 메뉴 → MCP 서버 추가(주소 `https://cloud.basicmemory.com/mcp`) → 로그인 허용 → 대화창 도구에서 켜기. 처음엔 검색·읽기만 열리므로 저장하려면 개발자 설정에서 전체 도구 사용을 켠다.

## 이렇게 말하면 된다

| 상황 | 말 |
| --- | --- |
| 하루 마무리 | "오늘 정한 거 Basic Memory에 노트로 저장해줘" |
| 다음 날 | "어제 하던 결제 버그 노트 찾아서 이어서 하자" |
| AI 갈아탐 | "Basic Memory에서 결제-중복-버그 노트 읽고 이어서 해줘" |
| 덧붙이기 | "그 노트에 오늘 결정 추가해줘" |

습관 하나: 작업 끝낼 때 "오늘 거 정리해서 저장해줘".

## 노트 형식

```markdown
---
title: 결제-중복-버그
tags: [payment]
---
# 결제 중복 버그
## Observations
- [bug] 웹훅이 두 번 들어와 결제가 중복 기록됨 #payment
- [decision] 멱등키로 중복 차단
## Relations
- relates_to [[웹훅 재시도 정책]]
```
`[분류]`, `#태그`, `[[다른 노트]]` 링크. Obsidian으로 열어 직접 고칠 수 있다.

## 안 될 때

| 증상 | 대처 |
| --- | --- |
| 도구 목록에 없음 | 앱 완전 종료 후 재시작, `basic-memory --version` 확인, JSON 쉼표 확인 |
| Claude Desktop ENOENT 오류 | `where uvx`(macOS `which uvx`) 결과 전체 경로를 `command`에 넣기 |
| Claude Code에서 안 잡힘 | `claude mcp remove basic-memory` 후 다시 add |
| 클라우드 로그인 오류 | 서버 삭제 후 다시 추가·로그인 |
| ChatGPT에 MCP 메뉴 없음 | 요금제 Plus 이상인지 확인 |
| 저장했는데 노트가 안 보임 | `basic-memory status`로 동기화 확인 |

## 이 가이드 폴더와의 관계 (내 판단)

- **역할이 다르다.** 이 가이드 폴더 = 내가 정리한 "작업 방법·스킬 목록"(정적인 지침). Basic Memory = 작업하면서 쌓이는 "진행 상황·결정 기록"(동적인 기억).
- 노트 폴더를 Google Drive 안에 두지 않는다. Basic Memory는 로컬 인덱스 DB를 같이 쓰므로 Drive 동기화와 충돌할 수 있다. 여러 기기가 필요하면 클라우드 플랜이나 git으로 동기화한다.
- 이 가이드 폴더를 Basic Memory 프로젝트로 등록하면 AI가 index.md를 따라가는 대신 검색 도구로 찾을 수 있지만, AI가 가이드 문서에 노트를 써 넣을 위험이 있어 지금은 권하지 않는다.
- 설치하면 `06_스킬_플러그인/컴퓨터별_설치현황.md`에 기록한다 (MCP 서버는 PC별 설치).
