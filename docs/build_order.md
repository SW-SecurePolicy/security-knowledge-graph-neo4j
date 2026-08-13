# Build Order

처음부터 재구축할 때 다음 순서를 사용합니다.

1. Constraints 생성
2. Security / Domain / Category 구축
3. Framework 구축
4. Control 248개 구축
5. Framework와 Control 연결
6. Primary Mapping (`BELONGS_TO`) 248개 생성
7. Secondary Mapping (`RELATED_TO`) 58개 생성
8. 무결성 및 개수 검증

가장 간단한 방법은 `cypher/00_build_all.cypher`를 실행한 뒤 `cypher/08_validation.cypher`로 검증하는 것입니다.

## Expected Result

```text
Node
- Security: 1
- Framework: 3
- Domain: 16
- Category: 67
- Control: 248
- Total: 335

Relationship
- HAS_DOMAIN: 16
- HAS_CATEGORY: 67
- HAS_CONTROL: 248
- BELONGS_TO: 248
- RELATED_TO: 58
- Total: 637
```
