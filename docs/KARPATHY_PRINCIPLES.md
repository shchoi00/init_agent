# Karpathy-inspired principles

이 문서는 인터넷에서 흔히 “Karpathy의 네 가지 코딩 원칙”이라고 불리는
규칙의 출처와, 이를 Codex에 어떻게 적용할지를 구분해서 설명합니다.

## 먼저 출처를 정확히 구분하기

다음 네 제목은 Andrej Karpathy가 직접 작성해 배포한 공식 specification이
아닙니다.

1. Think Before Coding
2. Simplicity First
3. Surgical Changes
4. Goal-Driven Execution

Karpathy가 2026년 1월 26일 자신의 coding-agent 사용 경험과 LLM의 실패
패턴을 공개했고, 이후 커뮤니티의
[`andrej-karpathy-skills`](https://github.com/multica-ai/andrej-karpathy-skills)
저장소가 그 관찰을 위 네 제목으로 구조화했습니다.

- [Karpathy의 원 발언](https://x.com/karpathy/status/2015883857489522876)
- [커뮤니티가 정리한 네 원칙](https://github.com/multica-ai/andrej-karpathy-skills)

따라서 저장소에서는 이를 “Karpathy-inspired”라고 부릅니다. 출처가
커뮤니티의 재구성이라는 점을 숨기지 않되, 원 발언이 지적한 실제 문제에는
충실하게 적용합니다.

## 1. Think Before Coding

### 해결하려는 실패

Agent가 불명확한 요청을 하나의 해석으로 조용히 고정하고, 틀린 가정을
기반으로 긴 구현을 진행하는 문제입니다.

### 적용 규칙

- 명시적 요청, 배경, 예시와 미래 가능성을 구분합니다.
- 결과가 크게 달라지는 가정은 구현 전에 드러냅니다.
- 여러 해석이 실질적으로 다르면 임의로 하나를 고르지 않습니다.
- 모르는 것을 아는 것처럼 처리하지 않습니다.
- 더 단순한 접근이나 중요한 tradeoff가 있으면 먼저 제시합니다.

### 과도하게 적용하지 않기

모든 사소한 선택을 질문으로 돌리라는 뜻은 아닙니다. 작고 되돌릴 수 있는
선택은 가정을 밝히고 진행합니다. 질문은 결과나 권한이 달라질 때 사용합니다.

## 2. Simplicity First

### 해결하려는 실패

Agent는 실제 요구보다 일반적인 API, 추상화 계층, configuration과 error
handling을 만들면서 변경 크기를 키우는 경향이 있습니다.

### 적용 규칙

- 현재 요청을 해결하는 최소 구현을 우선합니다.
- 한 번만 쓰는 코드를 위해 추상화를 만들지 않습니다.
- 요구하지 않은 확장성이나 선택지를 미리 구현하지 않습니다.
- 이미 존재하는 abstraction과 canonical path를 먼저 찾습니다.
- 동일한 결과라면 코드와 개념이 적은 해결책을 선택합니다.

### 단순함의 의미

“짧기만 한 코드”가 목적은 아닙니다. 올바른 validation이나 필수 error
handling을 생략하면 단순한 것이 아니라 불완전한 것입니다. 비교 기준은
정확성과 유지보수성을 만족한 해결책 사이의 불필요한 복잡성입니다.

## 3. Surgical Changes

### 해결하려는 실패

버그 하나를 수정하면서 주변 formatting, comment, 이름, dead code까지
건드려 diff가 커지고 회귀 위험이 증가하는 문제입니다.

### 적용 규칙

- 모든 변경 줄은 사용자 요청 또는 그 변경으로 생긴 cleanup에 연결돼야 합니다.
- 주변 코드의 style을 개인 취향으로 바꾸지 않습니다.
- 관계없는 refactor와 formatting을 같은 변경에 섞지 않습니다.
- 기존의 무관한 문제는 보고만 하고 요청 없이 함께 수정하지 않습니다.
- 자신의 변경 때문에 unused가 된 항목은 정리합니다.

이 원칙은 “절대로 구조를 개선하지 말라”는 뜻이 아닙니다. 구조 변경이
요청의 핵심이거나 올바른 구현에 필수라면 근거와 범위를 설명하고 수행합니다.

## 4. Goal-Driven Execution

### 해결하려는 실패

“코드를 작성했다”, “명령이 종료됐다”를 실제 성공으로 오인하는 문제입니다.

### 적용 규칙

- 구현 전에 관찰 가능한 완료 조건을 정합니다.
- bug fix는 가능하면 먼저 failure를 재현합니다.
- 여러 단계라면 각 단계에 검증 방법을 연결합니다.
- agent는 성공 조건을 충족하거나 검증 불가능한 이유를 확인할 때까지 반복합니다.
- 최종 보고는 주장 대신 test, metric, diff 또는 artifact를 제시합니다.

예:

```text
약한 목표: validation을 추가한다.
강한 목표: invalid input을 재현하는 test를 만들고, 구현 후 그 test와 기존
          regression suite가 통과하는지 확인한다.
```

## Karpathy 본인의 연구 workflow에서 가져올 원칙

코딩 네 원칙과 별도로, Karpathy가 직접 작성한 자료에는 computational
research agent에 더 직접적으로 유용한 규율이 있습니다.

### Neural-network recipe

Karpathy는 neural-network training을 내부가 새는 abstraction이며, 많은
오류가 exception 없이 성능만 조금 나빠지는 형태로 나타난다고 설명합니다.
따라서 빠르게 복잡한 모델부터 시도하는 것보다 다음 순서를 강조합니다.

- 모델을 만지기 전에 데이터를 직접 검사하고 분포와 outlier를 이해
- 단순한 end-to-end pipeline과 dumb baseline부터 구축
- seed를 고정하고 initialization loss가 예상값인지 확인
- 극소수 sample 또는 한 batch를 완전히 overfit할 수 있는지 확인
- network 직전의 실제 input tensor를 시각화
- 한 번에 복잡성 하나만 추가하고 예상한 변화가 발생하는지 확인
- 관련 논문의 가장 단순한 architecture로 먼저 신뢰 가능한 baseline 확보

원문: [A Recipe for Training Neural Networks](https://karpathy.github.io/2019/04/25/recipe/)

Codex에 적용하면 “새 아이디어를 많이 내라”보다 먼저 “현재 evaluation을
신뢰할 수 있는가, 단순 baseline이 정상인가, 실패가 조용히 숨을 수 있는가”를
확인하게 됩니다.

### Autoresearch

Karpathy의 `autoresearch`는 agent에게 무한한 자유를 주는 대신 실험 계약을
매우 좁고 측정 가능하게 만듭니다.

- 수정 가능한 파일을 하나로 제한
- evaluation harness는 고정하고 수정 금지
- 모든 실험의 시간 budget을 동일하게 고정
- 첫 실행은 반드시 baseline
- metric과 memory를 모든 성공·실패 run에 기록
- 개선되면 keep, 아니면 discard
- metric 개선 크기와 추가된 complexity를 함께 판단

원문:

- [karpathy/autoresearch](https://github.com/karpathy/autoresearch)
- [autoresearch `program.md`](https://github.com/karpathy/autoresearch/blob/master/program.md)

여기서 일반화할 원칙은 “모든 연구를 영원히 자동 실행”하는 것이 아닙니다.
핵심은 다음과 같습니다.

```text
agent의 자유도를 높이고 싶다면
  수정 범위, 평가 기준, 비용, 기록 형식을 더 명확하게 고정한다.
```

실제 연구마다 metric, budget, 안전 조건과 중단 기준이 다르므로
`autoresearch`의 `NEVER STOP` 같은 프로젝트 전용 규칙은 전역
`AGENTS.md`에 복사하지 않습니다.

## 현재 전역 템플릿에 반영된 방식

| 원칙 | 전역 규칙에서의 구현 |
|---|---|
| Think Before Coding | 요청·배경 구분, 중요한 ambiguity만 질문 |
| Simplicity First | 최소 coherent change, speculative abstraction 금지 |
| Surgical Changes | 모든 변경 줄을 요청에 연결, unrelated refactor 금지 |
| Goal-Driven Execution | 완료 조건과 단계별 검증, evidence gap 보고 |
| Research recipe | baseline, confounder, leakage, 최소 정보 실험 |
| Autoresearch | 명확한 metric·cost·decision criterion과 provenance |

이 규칙들은 단순한 작업에 의식을 추가하기 위한 것이 아니라, agent가 긴
작업에서 잘못된 가정과 과도한 변경을 증폭시키지 않도록 하기 위한
guardrail입니다.
