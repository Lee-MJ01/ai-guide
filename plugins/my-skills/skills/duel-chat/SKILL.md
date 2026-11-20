---
name: duel-chat
description: |
  Claude와 Codex를 라운드제로 맞붙여 결과물을 만든다 (Claude 데스크톱 대화창용).
  로컬 MCP 서버 `duel` 의 도구(duel_check, duel_git, duel_start, duel_status,
  duel_stop, duel_result, duel_diagnose)로 이 PC의 duel.mjs 를 돌린다.
  Use when asked to "duel", "듀얼", "둘이 상의해", "코덱스랑 토론", "코덱스랑 싸워봐",
  "두 모델로 검증", "adversarial review", "debate this", or "Claude vs Codex".
---

# duel-chat — 대화창에서 Claude ↔ Codex 토론

셸이 없는 대화창 전용이다. 모든 실행은 MCP 서버 `duel` 의 도구로 한다.
`duel_check` 도구가 보이지 않으면 멈추고 이렇게 알린다:
"`duel` MCP 서버가 연결되지 않았습니다. Claude 데스크톱 앱에서만 동작하며,
앱을 완전히 종료 후 재시작해야 합니다. 웹/모바일에서는 쓸 수 없습니다."

아래 단계를 **순서대로** 실행한다. 건너뛰지 마라.

## Step 0 — 과제와 대상 폴더 확정

- 과제: 한 줄로 명확하게. 모호하면 한 번만 되묻는다.
- 대상 폴더: **절대 경로**가 필요하다. 대화창에는 현재 디렉터리 개념이 없으므로
  사용자가 경로를 안 줬으면 반드시 물어본다. 추측하지 마라.

## Step 1 — 준비 상태 점검

`duel_check { dir, task }` 호출. JSON 필드:

| 필드 | 의미 |
|------|------|
| `ready` | 두 CLI 모두 실행 가능 |
| `agents` | 각 CLI 버전 (`null` 이면 실행 불가) |
| `repo` / `branch` / `protected` | git 상태 |
| `dirty` / `dirtyFiles` | 커밋 안 된 변경 |
| `suggestedBranch` | 제안 브랜치명 |

`ready: false` 면 멈추고 어느 CLI가 죽었는지 알린다.
`claude` 가 `null` → 로그인 또는 PATH 문제. `codex` 가 `null` → `codex update` 안내.

## Step 2 — 브랜치 게이트 (생략 금지)

두 에이전트는 매 턴 `git add -A` 로 커밋한다. 선택지는 **번호 목록으로 제시하고
사용자의 답을 기다린다.** 답 없이 진행하지 마라.

### `repo: false`
되돌릴 방법이 없다고 알리고 묻는다:
1. **git init 후 진행** (권장) → `duel_git { action: "init" }`, 그리고 실행 시
   `new_branch: "duel/<주제>"` 를 **반드시** 같이 넘긴다 (첫 커밋 후 `master` 가
   보호 브랜치로 잡혀 `BLOCKED_PROTECTED_BRANCH` 로 거부되는 함정 회피. 다시 묻지 마라)
2. **그대로 진행** → `no_git: true`. 되돌리기 불가
3. **취소**

### `protected: true`
1. **새 브랜치 만들고 진행** (권장) — `suggestedBranch` 를 기본 제시 → `new_branch`
2. **현재 브랜치에서 강행** → `allow_protected: true`.
   고르면 "`<브랜치>` 에 기계 커밋이 직접 쌓인다"고 한 줄 확인
3. **취소**

### `dirty: true`
첫 턴 커밋이 미커밋 변경을 통째로 흡수한다.
1. **먼저 커밋하고 진행** (권장) → `duel_git { action: "commit_all", message }`
2. **스태시하고 진행** → `duel_git { action: "stash" }`, 끝나고 `git stash pop` 안내
3. **그대로 진행**

## Step 3 — 실행 옵션

과제 성격으로 판단하고, 애매할 때만 묻는다.

| 상황 | 옵션 |
|------|------|
| 코드를 실제로 고쳐야 함 | `mode: "code"` (기본) |
| 설계·기획만 | `mode: "design"` (`PLAN.md` 만 생성) |
| 기본 깊이 | `rounds: 4` |
| 크거나 위험한 변경 | `rounds: 6, min_attacks: 5` |
| 빠른 확인 | `rounds: 2, judge: "none"` |
| `rounds` 5 이상 | `compact_transcript: true` 추가 |

4라운드에 대략 10~15분.

**Codex 모델.** 기본은 `~/.codex/duel.config.toml` 프로필 — `gpt-6-sol`, 추론
`medium`, 토론에 불필요한 플러그인·도구 비활성(호출당 고정 입력 약 28% 절감).
사용자가 모델을 지정할 때만 `codex_model` / `codex_effort` 를 넘긴다.
프로필 없이 평소 Codex 설정을 쓰려면 `codex_profile: "none"`.

**`compact_transcript`.** 토론자에게는 최근 2턴만 전문, 그 이전 턴은 앞부분만
보낸다(심판은 항상 전문). 라운드가 길수록 효과가 크지만 이미 끝난 쟁점을 다시
꺼낼 위험이 생긴다. 4라운드 이하에서는 켜지 마라.

**`first` 를 오해하지 마라.** `first: "codex"` 는 codex를 **제안자**로 만든다.
심판 기본값은 제안자의 반대쪽이므로 `first` 를 바꾸면 심판도 바뀐다.

비용을 신경 쓰면 이 순서로 제안: `rounds` 낮추기 → 설계만 필요하면 `mode: "design"`
(파일 탐색이 줄어 턴당 도구 호출이 적다) → 과제에 "기존 절을 고쳐라, 새 절을 붙이지
마라" 추가 → `compact_transcript: true` → `budget` (Claude 턴당 USD 상한) →
`claude_model: "sonnet"` (마지막 수단, 반박 턴 품질 손해 큼).

Codex 입력 토큰이 많은 이유를 물으면: `codex exec` 는 에이전트 루프라 도구를 쓸
때마다 누적 컨텍스트 전체를 다시 보낸다. 대부분 캐시 적중이라 실제 차감은 더 작다.

## Step 4 — 실행과 진행 확인

`duel_start { task, dir, rounds, ... }` → `runId` 를 받는다. 백그라운드로 돈다.

사용자에게 알린다: "실행 시작 (runId `<id>`). 수 분~수십 분 걸립니다.
'상태' 라고 하시면 진행 상황을 확인합니다."

대화창은 스스로 기다릴 수 없다. 진행 확인은 이렇게 한다:
- 사용자가 상태를 물을 때마다 `duel_status { runId }` 호출
- `progress` 의 새 줄만 라운드별 한 줄로 요약. 예: `R2 Codex 공격 완료 (249s)`
- 이미 보고한 줄은 다시 보고하지 마라
- `aborting` / `BLOCKED` / `failed` 가 보이면 Step 6
- `running: false` 가 되면 Step 5

## Step 5 — 결과 보고

`duel_result { dir }` 호출. 전체 토론이 필요하면 `include_transcript: true`.

`verdict.md` 에서 **이 세 개를 반드시 옮긴다:**

1. **검증 결과 표의 `아니오` 항목** — "고쳤다"고 했지만 실제로 안 된 것.
   하나도 빠뜨리지 마라. 이 시스템의 존재 이유다.
2. **미해결 — 사용자 결정 필요** — 선택지와 대가를 그대로 전달. "이게 맞다"로 바꾸지 마라.
3. **토론 품질** — 서로 봐줬다면 `min_attacks` 를 올려 재실행 권고.

결과에 포함된 git log 로 라운드별 커밋을 알리고, 마음에 안 드는 라운드는
`git reset --hard <커밋>` 으로 되돌릴 수 있다고 한 줄 덧붙인다
(이 명령은 사용자가 직접 터미널에서 실행한다).

## Step 6 — 중간에 죽었을 때

로그 메시지만 보고 원인을 단정하지 마라. `duel_diagnose` 를 호출해
두 CLI를 직접 찔러본다.

| 결과 | 원인 | 처리 |
|---|---|---|
| `You've hit your usage limit ... try again at <시각>` | 사용량 한도 | 그 시각까지 재실행 불가. 끝난 라운드는 커밋에 남아있다고 알림 |
| `requires a newer version of Codex` | CLI 구버전 | `codex update` |
| 로그인 프롬프트 / 401 | 세션 만료 | 해당 CLI 재로그인 |
| 둘 다 `OK` + `PONG` | 일시적 실패 | 재실행 |

이미 끝난 라운드는 살아있다. 이어 붙일 때는 `rounds: 2` 로 돌리고 과제 문장에
**이미 확정된 사항을 "재논쟁 금지"로 명시**한다.

실행을 끊어야 하면 `duel_stop { runId }`.

## 하지 말 것

- 브랜치 게이트를 조용히 건너뛰기
- `yolo: true` 를 알아서 넘기기. 사용자가 직접 요청했고 격리 환경일 때만
- 심판 보고서를 "잘 됐습니다"로 요약하기
- 대상 폴더 경로를 추측하기
