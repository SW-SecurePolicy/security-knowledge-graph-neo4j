# Repository Contents

- `README.md`: 프로젝트 개요 및 실행 방법
- `NOTICE.md`: Mapping/저작권 주의사항
- `cypher/00_build_all.cypher`: 전체 구축용
- `cypher/01~07_*.cypher`: 단계별 구축
- `cypher/08_validation.cypher`: 검증 Query
- `cypher/09_demo_queries.cypher`: 발표/시연 Query
- `cypher/99_DANGER_reset_database.cypher`: 전체 삭제 Query
- `data/*.csv`: 재현용 데이터
- `docs/schema.md`: 그래프 스키마
- `docs/build_order.md`: 구축 순서
- `docs/sbert_prototype.md`: SBERT 추천 프로토타입 상세 실행 및 동작 방식
- `algorithm/sbert_prototype.py`: SBERT 기반 Category Top-3 추천 프로그램
- `algorithm/README.md`: SBERT 추천 프로토타입 빠른 실행 안내
- `algorithm/requirements.txt`: SBERT 프로토타입 Python 의존성
- `algorithm/.env.example`: Neo4j 연결 환경설정 예시
- `scripts/validate_repo.py`: CSV 데이터 무결성 검증
