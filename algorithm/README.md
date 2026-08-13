# SBERT 기반 자동 Mapping 계획

현재 Neo4j Knowledge Graph 구축과 수동 Mapping은 완료된 상태이며, 다음 연구 단계에서는 **SBERT + Cosine Similarity**만 적용할 예정입니다.

## 목적

새로운 보안 Control 문장을 입력했을 때 67개 공통 Category 중 의미적으로 가장 유사한 Category를 자동 추천합니다.

## 처리 흐름

```text
Control 문장
    ↓
SBERT
    ↓
Control Vector

67개 Category 문장
    ↓
SBERT
    ↓
Category Vector

Control Vector ↔ Category Vector
    ↓
Cosine Similarity
    ↓
Top-1 / Top-3 Category 추천
    ↓
기존 수동 Mapping과 비교
    ↓
Accuracy 평가
```

## Cosine Similarity

두 문장 벡터의 의미적 유사도를 다음과 같이 계산합니다.

```text
Similarity(A, B) = (A · B) / (||A|| ||B||)
```

- `A`: Control 문장 벡터
- `B`: Category 문장 벡터
- 값이 클수록 의미적으로 더 유사하다고 판단합니다.

## Accuracy

```text
Accuracy = 정확하게 추천한 Control 수 / 전체 평가 Control 수 × 100
```

## Ground Truth

현재 `data/primary_mapping.csv`의 수동 Primary Mapping을 평가 기준 데이터로 사용할 수 있습니다.

## 주의

아직 실제 SBERT 모델 선정, 데이터 분할, 전처리 방식, 실험 결과는 확정하지 않았습니다. 이 문서는 향후 구현을 위한 설계 문서이며, 실험이 완료되기 전에는 성능 수치를 기재하지 않습니다.
