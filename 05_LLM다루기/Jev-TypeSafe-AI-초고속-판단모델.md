# Jev (TypeSafe AI) — 문장 대신 '판단'만 반환하는 초고속 모델

> **주제 분류**: LLM 모델 / 판단·분류 자동화
> **정리일**: 2026-09-22
> **원본**: 인스타그램 2건 병합
> - @ai_freaks.kr — [“GPT 공동 개발자의 AI, 심상치 않다”](https://www.instagram.com/p/DdX5q1eGvUL/) (2026-09-17, 좋아요 1,091 / 댓글 999)
> - @prompt_what — [LLM이 8.5초 걸리던 판단을 0.1초에](https://www.instagram.com/p/DdgZRo8lHeV/) (2026-09-20, 좋아요 474 / 댓글 185)
> - 공식: `typesafe.ai`

---

## 1. 한 줄 요약

ChatGPT 공동 개발자 **Diogo Almeida(디오고 알메이다)** 가 설립한 **TypeSafe AI** 가 2026년 9월 15일 첫 모델 **Jev(제브)** 를 공개. 문장을 쓰지 않고 **선택지·점수·참거짓 + 신뢰도 값**만 반환해서, 기존 LLM이 8.566초 걸리던 판단 과제를 **0.114초**에 끝낸다.

---

## 2. 핵심 스펙

| 항목 | 내용 |
|---|---|
| 모델명 | Jev (데모 표기: `Jev 1.13.0`) |
| 제작사 | TypeSafe AI (`typesafe.ai`) |
| 공개일 | 2026-09-15 |
| 출력 방식 | 자연어 문장 없음 → `choice` / `score` / `true·false` + `confidence` |
| 속도 | 동일 과제 8.566s → 0.114s (**약 193.6배**, 회사 발표 기준) |
| 비용 | 동일 과제 $0.018388 → $0.000981 (**약 444.6배 저렴**, 회사 발표 기준) |
| 요금 | 입력 100만 토큰당 **$0.042**, **출력 토큰 무료** |
| 상태 | 얼리 액세스 신청 순차 제공 |

> ⚠️ 속도·비용 배수는 모두 **제조사 자체 발표 수치**. 벤치마크 기준·실험 데이터 출처는 공개 자료에 미표기.

---

## 3. 기존 LLM과 무엇이 다른가

### 3-1. 학습 방식의 차이

- **기존 LLM (RLHF)**: 사람이 선호하는 *자연스러운 답*을 하도록 학습 → 틀린 답도 자신 있게 말하는 **할루시네이션** 발생.
  - 영상에서 지적한 RLHF의 부작용 3가지: `Mode dropping`, `Overconfidence`, `Lack of reliability`
  - "대화에는 좋지만(great for a natural conversation), 컴퓨터에겐 쓸모없다(useless for computers)"
- **Jev (RLCD)**: **정확한 판단 + 신뢰도 보정(calibration)** 중심 학습.
  - `RLCD` = **R**einforcement **L**earning from **C**alibrated **D**ecisions
  - 아키텍처 구성요소: `New Architecture` / `Sampler` / `Training algorithm`
  - 자사 포지셔닝 문구: `System One Model`, `Composable AI: Build Prod, Not God`

### 3-2. 출력 구조 비교 (공식 데모 `typesafe-race`)

같은 고객 문의 27개 항목 분류 과제:

**Jev (TypeSafe)**
```text
$ uv run typesafe-race ask typesafe
Sending request to parallel TypeSafe API...

"Revenue currently impacted?": {"no": 0.85, "type": "no"},
"What business impact?": {"choice": "degraded", "confidence": 0.90, ...},
"Account health status?": {"choice": "watch", "confidence": 0.31, ...},
"Which primary department?": {"choice": "technical", "confidence": 1.0, ...},
...
cost $0.000981
completed in 0.114s
```

**기존 LLM (autoregressive)**
```text
$ uv run typesafe-race ask llm
Sending request to autoregressive OpenAI API. Waiting for first token...
{
  "Revenue currently impacted?": true,
  "What business impact?": "degraded",
  "Account health status?": "watch",
  ...
}
cost $0.018388
completed in 8.566s
```

**차이의 핵심 3가지**
1. **병렬 vs 순차** — Jev는 27개 판단을 한 번에 통째로 출력, LLM은 첫 토큰 대기 후 한 줄씩 생성
2. **신뢰도 동반** — Jev는 각 항목에 `confidence` 값을 함께 반환, LLM은 단순 `true/false`·단어만 반환
3. **비용 구조** — 출력 토큰이 무료라 반복 판단 업무에서 비용이 거의 입력값에만 비례

---

## 4. 성능 데모 — WikiRace 벤치마크

로컬(`localhost:4300`)에서 위키피디아 `Baseball → Sun` 최단 경로 탐색 경주:

| 순위 | 모델 | 시간 | 홉 수 |
|---|---|---|---|
| 1위 | **Jev 1.13.0** | **0.419s** | 3 |
| 2위 | Claude Sonnet 5 | 3.724s | 4 |
| 3위 | Claude Haiku 4.5 | 4.975s | 6 |
| 4위 | GPT-5.6 Terra | 9.453s | 6 |

> ⚠️ 로컬호스트 환경 테스트. API 호출 조건·레이턴시 통제 여부는 영상만으로 검증 불가.

---

## 5. 가격 포지셔닝 (공식 비교표)

`Price per million tokens (USD)`

| 모델 | INPUT | OUTPUT |
|---|---|---|
| Astra | $10 | $50 |
| Fable 5.1 | $10 | $50 |
| Opus 5 | $5 | $25 |
| Sol | $4 | $20 |
| Terra | $2 | $12 |
| Sonnet 5 | $2 | $10 |
| Haiku 4.5 | $1 | $5 |
| Luna | $0.2 | $1.2 |
| **TypeSafe AI (Jev)** | **$0.0** | **FREE** |

`Intelligence / Cost` 산점도에서도 Jev는 **최저 비용 + 최고 성능(90% 근접)** 좌상단에 배치.

---

## 6. 어디에 쓰나 — 적합 / 부적합

### ✅ 적합 (같은 판단을 대량 반복하는 자동화)
- 고객 문의 자동 분류 / 우선순위 라우팅
- 스팸 메일 판별
- 유해 댓글 필터링
- 대량 문서·논문 분류
- 로보틱스·자율주행 등 **저지연 실시간 판단** (해외 커뮤니티 반응)

### ❌ 부적합
- 자유로운 대화형 챗봇 → **문장을 생성하지 않음**
- 글쓰기·요약·번역 등 생성 과제

> 사용법: 자유 질문이 아니라 **형식에 맞춰 질문**하면 모델이 스스로 기준을 세워 판단값을 반환.

### 공개 2일 내 실사용 보고 사례
- 광고 **724개를 40초**에 분석
- 논문 **1,018개를 $0.08**에 분류

---

## 7. 얼리 액세스 신청

1. `typesafe.ai` 접속
2. 우측 상단 **Join Waitlist** 클릭
3. 팝업(`Join Our Waitlist` / `Get early access to Jev`)에 이메일 입력 후 `submit`
4. `Waitlist Joined` 확인
5. 선택: `Want in sooner?` → `Answer a few questions` 로 순번 앞당기기 가능

---

## 8. 검증 유의사항

- 속도 193.6배 / 비용 444.6배는 **회사 자체 발표**, 독립 벤치마크 아님
- 비교 대상으로 쓰인 `GPT-5.6 Terra`, `gpt-5.6-terra` 등은 공식 확인이 어려운 명칭
- 데모는 CLI 연출 영상 — 실제 네트워크·서버 트래픽에 따라 레이턴시·비용 변동 가능

---

## 9. 관련 문서

- [[AI-브라우저-업무자동화]] — 반복 업무 자동화의 다른 접근(브라우저 조작형)
- [[GPT-Astra-개발환경-연동도구-3종]] — 개발 환경 쪽 도구 연동
