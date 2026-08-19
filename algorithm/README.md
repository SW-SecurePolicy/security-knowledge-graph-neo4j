# SBERT Category Top-3 추천 프로토타입

새로운 보안 Control 문장을 입력하면 Neo4j의 Category를 읽고, 의미적으로 가장 비슷한 Category 3개를 추천합니다.

프로그램은 각 Category의 `Domain 이름 + Category 이름`을 비교 문장으로 만들고, 다국어 SBERT 모델 `sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2`로 임베딩합니다. 입력 문장과 모든 Category 문장의 Cosine Similarity를 계산한 뒤 점수가 높은 Top-3만 출력합니다.

이 프로토타입은 Neo4j를 **조회만** 합니다. Control, 관계, 속성을 새로 만들거나 변경하지 않습니다.

설치부터 내부 처리 방식까지 포함한 상세 설명은 [`docs/sbert_prototype.md`](../docs/sbert_prototype.md)를 참고하세요.

## 1. 실행 환경 준비

Mac 터미널에서 저장소 루트로 이동하고 Python 가상환경을 만듭니다.

```bash
cd security-knowledge-graph-neo4j

python3 -m venv .venv
source .venv/bin/activate
```

가상환경을 활성화한 상태에서 필요한 패키지를 설치합니다.

```bash
pip install -r algorithm/requirements.txt
```

## 2. Neo4j 연결 정보 설정

예제 환경설정 파일을 실제 설정 파일로 복사합니다.

```bash
cp algorithm/.env.example algorithm/.env
```

텍스트 편집기로 `algorithm/.env`를 열고 `NEO4J_PASSWORD`를 자신의 Neo4j 비밀번호로 바꿉니다.

```text
NEO4J_URI=bolt://localhost:7687
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=실제_Neo4j_비밀번호
NEO4J_DATABASE=neo4j
```

URI, 사용자 이름 또는 데이터베이스 이름이 기본값과 다르다면 해당 값도 실제 환경에 맞게 변경합니다. `algorithm/.env`는 Git에 커밋되지 않도록 루트 `.gitignore`에 등록되어 있습니다.

## 3. Neo4j 실행

프로그램을 실행하기 전에 Neo4j 서버를 먼저 시작해야 합니다. 또한 이 저장소의 Cypher를 이용해 16개 Domain과 67개 Category가 구축되어 있어야 합니다.

Neo4j Desktop을 사용한다면 해당 DBMS를 시작합니다. 다른 방식으로 설치했다면 그 환경의 명령으로 Neo4j를 실행합니다.

## 4. 프로그램 실행

저장소 루트에서 다음 명령을 실행합니다.

```bash
python algorithm/sbert_prototype.py
```

`algorithm/.env` 경로는 스크립트 위치를 기준으로 찾기 때문에 저장소 루트에서 실행해도 안정적으로 동작합니다. SBERT 모델은 최초 실행 시 다운로드될 수 있으므로 인터넷 연결이 필요할 수 있습니다.

프롬프트가 나타나면 테스트할 Control 문장을 입력합니다.

```text
사용자의 시스템 접근 권한은 업무 수행에 필요한 최소한의 범위로 부여하고 정기적으로 검토한다.
```

## 5. 결과 해석

출력 예시는 다음과 같습니다. 순위와 유사도 값은 모델이 실제로 계산한 결과에 따라 달라집니다.

```text
=== SBERT Category 추천 결과 ===

입력 Control:
사용자의 시스템 접근 권한은 업무 수행에 필요한 최소한의 범위로 부여하고 정기적으로 검토한다.

1위 IAM-03 권한·최소권한
유사도: 0.8421

2위 IAM-04 특권·특수권한
유사도: 0.7312

3위 IAM-05 정보·시스템 접근통제
유사도: 0.6845
```

- `1위`가 입력 Control과 의미적으로 가장 가까운 Category입니다.
- 유사도는 두 임베딩의 Cosine Similarity이며, 값이 클수록 의미적으로 더 비슷하다고 해석합니다.
- 이 결과는 자동 확정 Mapping이 아니라 검토를 돕는 추천 결과입니다.
- 실행할 때마다 Neo4j의 전체 Category를 다시 조회하고 비교합니다.

## 현재 범위

현재는 `새 Control 입력 → SBERT 임베딩 → 전체 Category와 Cosine Similarity 비교 → Top-3 추천`만 구현합니다. Neo4j 데이터 저장, `BELONGS_TO`/`RELATED_TO` 관계 생성, Accuracy 평가, 248개 Control 일괄 테스트, 웹 UI와 그래프 시각화는 포함하지 않습니다.
