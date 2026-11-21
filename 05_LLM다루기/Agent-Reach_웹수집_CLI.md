# Agent-Reach · 에이전트가 유튜브·레딧·GitHub를 직접 검색하고 읽게 하는 CLI

> 요약: Claude Code 같은 CLI 에이전트가 기본 검색으로 못 닿는 곳(유튜브 자막, 레딧, GitHub, 로그인 필요한 플랫폼)을 한 명령으로 읽게 해 주는 무료 도구. 한국어 소개 글과 공식 README를 교차 확인했다. | 언제: Claude Code에서 유튜브·레딧·GitHub 자료를 모아 정리할 때, 웹 가져오기가 막힐 때 | 키워드: 웹 수집, 유튜브 자막, 레딧, GitHub, yt-dlp, 리서치 | 관련 스킬: youtube-watch, ai-guide-intake | 출처: https://milesahead.kr/resources/agent-reach/ , https://github.com/Panniantong/Agent-Reach | 갱신: 2026-11-22

## 자료 정보

- **소개 글:** milesahead.kr 자료실 (2026-11-20 기준, 글쓴이가 맥에서 설치·시험. 윈도우는 미시험)
- **공식 저장소:** `Panniantong/Agent-Reach` · MIT · README 기본 언어 중국어(영어판 있음)
- **분석 방식:** 소개 글은 WebFetch, README는 내장 브라우저로 확인 (2026-11-22)

## 핵심 요약

Claude Code·Codex 등은 웹 검색과 페이지 읽기는 되지만 유튜브 자막, 로그인 뒤 콘텐츠, 중국 플랫폼 등은 잘 못 읽는다. Agent-Reach는 이런 플랫폼별 도구(yt-dlp, Jina Reader, Exa 등)를 대신 설치·점검해 두고 `agent-reach <채널> <동작>` 한 형태로 부르게 한다. 각 동작은 "우선 도구 → 실패 시 예비 도구" 순서로 시도한다. 읽기 전용이라 글쓰기·댓글·좋아요·DM은 하지 않는다.

## 채널 (README 표 요약)

| 등급 | 채널 | 메모 |
| --- | --- | --- |
| 기본(설치 즉시) | web, github, youtube, bilibili, v2ex | 유튜브 자막 가능. 음성→문자는 Groq·OpenAI 키 필요 |
| 선택("XX 추가해 줘") | reddit, linkedin, xiaohongshu, xueqiu, boss, xiaoyuzhou | 대부분 로그인 필요. linkedin 공개 공고는 로그인 없이 |
| 실험(언제든 깨질 수 있음) | twitter(X), facebook, instagram | 로그인 필요 |

## 바로 써먹을 것

**설치 (Claude Code에 아래 문장을 그대로 보낸다)**
```
Agent Reach 설치해 줘: https://raw.githubusercontent.com/Panniantong/Agent-Reach/main/docs/install.md
```
- 업그레이드도 같은 문장. uv가 없으면 먼저 설치한다(관리자 비밀번호 불필요).
- **PyPI의 `agent-reach`는 다른 프로그램이다.** `pip install agent-reach` 하지 않는다.
- 모든 파일은 `~/.agent-reach/` 한 곳에 모인다.

**확인·관리 (말로 요청)**
- "Agent Reach 상태 점검해 줘" → youtube·web·github가 PASS면 끝
- "레딧 추가해 줘" / "빼 줘", "Agent Reach 업그레이드", "Agent Reach 제거"(지울 목록을 먼저 보여 줌)
- 기능 표가 중국어로 나오면 "한국어로 설명해 줘"

**쓰는 예**
- "에어프라이어 산 사람들이 제일 후회하는 점을 유튜브·레딧에서 모아 줘" (소개 글 시험: 약 1분 34초, 레딧 글 약 60개 + 영상 3개, 항목마다 출처 링크)
- "유튜브에서 한국어 영상만 찾아서 자막 요약해 줘"
- 이 가이드 작업: Claude Code에서 ai-guide-intake를 돌릴 때 GitHub README·유튜브 자막을 읽는 보조 수단. 클라우드 세션은 네트워크 허용 목록 때문에 막힐 수 있으니 PC의 Claude Code에서 쓴다.

**youtube-watch와 나눠 쓰기:** 자막만 필요하면 Agent-Reach(Claude Code, 브라우저 불필요), 화면 글자·코드까지 봐야 하면 youtube-watch(Claude 앱 내장 브라우저, 프레임 분석).

## 주장과 확인할 점

- **주장:** GitHub 별 11만 3천 개 이상(소개 글, 2026-11-20). → 이번에 별 수는 다시 확인하지 못함.
- **로그인 재사용 주의:** 로그인이 필요한 사이트는 처음 쓸 때 **내 Chrome에서 그 사이트의 로그인 정보를 복사**해 전용 브라우저에서 쓴다(비밀번호 저장소는 읽지 않는다고 함). 주 계정이 자동 접근으로 제한될 수 있어 README도 **부계정**을 권한다. API 키는 채팅에 붙이지 말고 터미널에서 `agent-reach configure groq-key`로 넣는다.
- **레딧:** 소개 글은 로그인 없이 검색 결과 앞부분(약 1,000자)만 읽혔다고 했고, 현재 README는 레딧을 로그인 필요한 "선택" 채널로 분류한다. 버전에 따라 다르니 상태 점검 결과를 믿는다.
- **결과 품질(소개 글 경험):** 무료 웹 검색은 횟수 제한이 있어 한 번 막히면 약 1시간 대기. 유튜브 자동 자막은 받아쓰기 오류가 섞임. "성공"이라도 로그인 안내문·제목만 가져온 경우가 있어 글자 수와 첫 문장을 확인. 결과 링크는 직접 열어 확인.
- README에 사칭 코인·지갑 연결 사기 경고가 있다. 공식 토큰은 없다.

## 분석 한계

- 직접 설치해 보지 않았다. 윈도우 동작은 소개 글도 미시험.
- 네이버 블로그·카페 지원은 소개 글 목차에만 있고 본문·README에서는 확인되지 않았다.

## 출처

- 소개 글: https://milesahead.kr/resources/agent-reach/
- 공식: https://github.com/Panniantong/Agent-Reach (설치 문서 `docs/install.md`)
