# SBERT 기반 Category Top-3 추천 프로토타입

## 1. 개요

이 프로토타입은 새로운 보안 Control 문장을 입력받아 Security Knowledge Graph의 67개 Category 중 의미적으로 가장 유사한 Category 3개를 추천합니다.

Neo4j에 구축된 `Domain`과 `Category`를 조회하고, 다국어 SBERT 모델로 문장 임베딩을 생성한 뒤 Cosine Similarity를 계산합니다. 추천 결과는 터미널에 출력하며 Neo4j 데이터는 변경하지 않습니다.

```text
새로운 Control 문장
        ↓
Neo4j에서 67개 Category 조회
        ↓
Domain 이름 + Category 이름으로 비교 문장 생성
        ↓
SBERT 문장 임베딩
        ↓
Cosine Similarity 계산
        ↓
유사도 내림차순 정렬
        ↓
Category Top-3 출력
```

## 2. 사용 기술

- Python
- Neo4j Python Driver
- Sentence Transformers
- `sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2`
- Cosine Similarity
- `python-dotenv`

한국어를 포함한 다국어 문장을 비교할 수 있도록 multilingual Sentence Transformers 모델을 사용합니다.

## 3. 관련 파일

```text
algorithm/
├── sbert_prototype.py   # Top-3 추천 실행 프로그램
├── requirements.txt    # Python 의존성
├── .env.example        # Neo4j 연결 정보 예시
└── README.md            # 빠른 실행 안내

docs/
└── sbert_prototype.md   # 상세 실행 및 동작 문서
```

실제 Neo4j 계정 정보가 들어가는 `algorithm/.env`는 루트 `.gitignore`에 등록되어 Git으로 관리되지 않습니다.

## 4. 실행 전 준비

다음 조건이 준비되어 있어야 합니다.

1. Python 3가 설치되어 있어야 합니다.
2. Neo4j가 실행 중이어야 합니다.
3. 저장소의 Cypher를 이용해 Knowledge Graph가 구축되어 있어야 합니다.
4. Neo4j에 16개 Domain과 67개 Category가 존재해야 합니다.

Category는 다음 구조로 연결되어 있습니다.

```text
(:Security)-[:HAS_DOMAIN]->(:Domain)-[:HAS_CATEGORY]->(:Category)
```

## 5. Python 환경 구성

터미널에서 저장소 루트로 이동합니다.

```bash
cd security-knowledge-graph-neo4j
```

Python 가상환경을 만들고 활성화합니다.

```bash
python3 -m venv .venv
source .venv/bin/activate
```

필요한 패키지를 설치합니다.

```bash
pip install -r algorithm/requirements.txt
```

설치되는 주요 패키지는 다음과 같습니다.

```text
sentence-transformers
neo4j
python-dotenv
```

## 6. Neo4j 연결 정보 설정

예제 파일을 복사해 실제 환경설정 파일을 만듭니다.

```bash
cp algorithm/.env.example algorithm/.env
```

`algorithm/.env`를 열어 현재 Neo4j 환경에 맞게 값을 입력합니다.

```text
NEO4J_URI=bolt://localhost:7687
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=실제_Neo4j_비밀번호
NEO4J_DATABASE=neo4j
```

환경설정 파일은 현재 터미널 위치가 아니라 `sbert_prototype.py`의 위치를 기준으로 읽기 때문에 저장소 루트에서 안정적으로 실행할 수 있습니다.

## 7. 프로그램 실행

Neo4j를 실행한 상태에서 저장소 루트에서 다음 명령을 실행합니다.

```bash
python algorithm/sbert_prototype.py
```

프로그램을 실행하면 다음 메뉴가 나타납니다.

```text
=== SBERT Category 추천 메뉴 ===
1. 새로운 Control 문장 검사
2. Neo4j에 Control 항목 추가 (미구현)
0. 프로그램 종료
```

각 메뉴의 역할은 다음과 같습니다.

| 메뉴 | 동작 |
|---|---|
| `1` | 새로운 Control 문장을 입력하고 Category Top-3를 검사합니다. |
| `2` | 향후 Neo4j 저장 기능을 위한 항목이며 현재는 안내만 표시합니다. |
| `0` | 프로그램을 종료합니다. |

`1`을 선택하면 새로운 Control 문장 입력 안내가 나타납니다.

```text
새로운 Control 문장을 입력하세요: 사용자의 시스템 접근 권한은 업무 수행에 필요한 최소한의 범위로 부여하고 정기적으로 검토한다.
```

SBERT 모델은 최초 실행 시 로컬 환경으로 다운로드될 수 있습니다. 이후에는 저장된 모델을 이용해 임베딩을 생성합니다.

추천 결과가 출력되면 프로그램이 종료되지 않고 메뉴로 돌아갑니다. 따라서 실행 명령을 다시 입력하지 않고 `1`을 선택해 여러 Control 문장을 연속으로 검사할 수 있습니다.

## 8. 실행 결과

프로그램은 유사도가 높은 Category 3개를 다음 형식으로 출력합니다. Category 순위와 유사도는 모델의 실제 계산 결과에 따라 결정됩니다.

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

위 유사도 숫자는 출력 형식을 설명하기 위한 예시입니다.

- `1위`는 입력 Control과 의미적으로 가장 가까운 Category입니다.
- 유사도는 입력 Control 임베딩과 Category 임베딩 사이의 Cosine Similarity입니다.
- 점수는 소수점 넷째 자리까지 출력합니다.
- 결과는 Mapping을 자동 확정하는 값이 아니라 검토를 위한 추천입니다.

## 9. 내부 동작 방식

### 9.1 환경설정 읽기

`python-dotenv`가 `algorithm/.env`에서 Neo4j URI, 사용자 이름, 비밀번호와 데이터베이스 이름을 읽습니다.

### 9.2 메뉴 선택과 Control 문장 입력

사용자가 메뉴에서 `1`을 선택한 후 새로운 Control 문장을 입력합니다. 이 문장이 Category와 비교할 기준 문장이 됩니다. 추천 결과 출력 후에는 다시 메뉴로 돌아가 다음 문장을 검사하거나 프로그램을 종료할 수 있습니다.

메뉴의 `2`는 향후 Neo4j Control 저장 기능을 표시하기 위한 항목입니다. 현재 프로토타입에서는 안내 문구만 출력하고 Neo4j 데이터를 생성하거나 수정하지 않습니다.

### 9.3 Category 조회

Neo4j 공식 Python Driver로 데이터베이스에 연결하고 읽기 트랜잭션에서 다음 Cypher를 실행합니다.

```cypher
MATCH (d:Domain)-[:HAS_CATEGORY]->(c:Category)
RETURN
    d.id AS domain_id,
    d.name AS domain_name,
    c.id AS category_id,
    c.name AS category_name
ORDER BY c.id
```

이 쿼리는 `MATCH`와 `RETURN`만 사용하며 그래프 데이터를 생성하거나 수정하지 않습니다.

### 9.4 Category 비교 문장 생성

조회한 각 Category에 대해 다음 형식의 문장을 만듭니다.

```text
{domain_name} {category_name}
```

예를 들어 `IAM` Domain과 `IAM-03` Category는 다음 비교 문장으로 구성됩니다.

```text
계정·접근통제 권한·최소권한
```

Domain의 상위 문맥을 Category 이름에 함께 넣어 모델이 Category 의미를 비교할 수 있도록 합니다.

### 9.5 SBERT 임베딩

다음 모델을 불러옵니다.

```text
sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2
```

`SentenceTransformer.encode()`를 이용해 다음 두 종류의 임베딩을 생성합니다.

1. 사용자가 입력한 Control 문장 임베딩
2. Neo4j에서 조회한 전체 Category 비교 문장 임베딩

프로토타입은 실행할 때마다 전체 Category 문장을 임베딩하고 비교합니다.

### 9.6 Cosine Similarity 계산

Control 임베딩과 각 Category 임베딩 사이의 Cosine Similarity를 계산합니다.

```text
Similarity(A, B) = (A · B) / (||A|| ||B||)
```

- `A`: 새로운 Control 문장의 임베딩
- `B`: Category 비교 문장의 임베딩

계산에는 Sentence Transformers의 `util.cos_sim()`을 사용합니다.

### 9.7 Top-3 선정

67개 유사도 값을 높은 순서대로 정렬한 후 앞의 3개 Category만 선택합니다. 선택된 Category ID, Category 이름과 유사도를 터미널에 출력합니다.

### 9.8 Neo4j 연결 종료

Category 조회가 끝나면 Neo4j driver를 닫아 연결 자원을 정상적으로 정리합니다.

## 10. 코드 구성

| 구성 요소 | 역할 |
|---|---|
| `load_config()` | `.env`의 Neo4j 연결 정보 로드 및 확인 |
| `_read_categories()` | 읽기 트랜잭션에서 Category 조회 |
| `fetch_categories()` | Neo4j 연결, 조회, driver 종료 관리 |
| `Category.comparison_text` | Domain 이름과 Category 이름 결합 |
| `recommend_categories()` | 임베딩, Cosine Similarity, Top-3 정렬 |
| `read_control_text()` | 터미널 Control 문장 입력 처리 |
| `read_menu_choice()` | 반복 검사, 미구현 저장 항목, 종료 메뉴 처리 |
| `print_recommendations()` | 추천 결과와 유사도 출력 |
| `main()` | 전체 실행 순서 제어 |

## 11. 검증 방법

Python 문법을 확인합니다.

```bash
python3 -m py_compile algorithm/sbert_prototype.py
```

저장소 원본 데이터 개수와 Mapping 무결성을 확인합니다.

```bash
python3 scripts/validate_repo.py
```

프로그램을 실행해 새로운 Control 문장을 입력하고 다음 항목을 확인합니다.

1. Neo4j의 전체 Category가 조회되는지 확인합니다.
2. 추천 결과가 3개 출력되는지 확인합니다.
3. 유사도가 소수점 넷째 자리까지 출력되는지 확인합니다.
4. 결과가 유사도 내림차순으로 정렬되는지 확인합니다.
5. 결과 출력 후 메뉴에서 `1`을 선택해 다른 문장을 연속 검사할 수 있는지 확인합니다.
6. 메뉴 `2`를 선택해도 Neo4j 데이터가 변경되지 않는지 확인합니다.

## 12. 현재 구현 범위

현재 프로토타입은 다음 기능만 수행합니다.

```text
메뉴에서 `1` 선택
→ 새 Control 입력
→ SBERT 임베딩
→ 67개 Category와 Cosine Similarity 비교
→ Top-3 Category 추천
→ 메뉴로 복귀
```

다음 기능은 현재 단계에 포함하지 않습니다.

- Neo4j에 새로운 Control 저장 (`2` 메뉴는 표시만 제공)
- `BELONGS_TO` 자동 생성
- `RELATED_TO` 자동 생성
- 전체 Accuracy 평가
- 248개 Control 일괄 테스트
- 웹 UI
- 거리 기반 그래프 시각화

따라서 이 프로토타입은 기존 Security Knowledge Graph를 변경하지 않는 읽기 전용 추천 실험입니다.
