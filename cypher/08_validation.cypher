// 08. 검증 Query
// 각 Query를 하나씩 실행한다.

// 1) Node 종류와 개수
MATCH (n)
RETURN labels(n)[0] AS node_type, count(n) AS count
ORDER BY node_type;

// 기대값:
// Category 67 / Control 248 / Domain 16 / Framework 3 / Security 1

// 2) Relationship 종류와 개수
MATCH ()-[r]->()
RETURN type(r) AS relationship_type, count(r) AS count
ORDER BY relationship_type;

// 기대값:
// BELONGS_TO 248 / HAS_CATEGORY 67 / HAS_CONTROL 248 / HAS_DOMAIN 16 / RELATED_TO 58

// 3) Framework별 Control 수
MATCH (f:Framework)-[:HAS_CONTROL]->(c:Control)
RETURN f.id AS framework, count(c) AS control_count
ORDER BY framework;

// 기대값:
// CASP 54 / ISMS-P 101 / ISO27001 93

// 4) 모든 Control이 Primary Mapping 1개를 가지는지 확인
MATCH (c:Control)
OPTIONAL MATCH (c)-[r:BELONGS_TO]->(:Category)
WITH c, count(r) AS primary_count
WHERE primary_count <> 1
RETURN c.framework, c.id, c.title, primary_count;

// 기대값: No records

// 5) Category가 Domain에 정확히 하나씩 연결됐는지 확인
MATCH (cat:Category)
OPTIONAL MATCH (d:Domain)-[r:HAS_CATEGORY]->(cat)
WITH cat, count(r) AS domain_count
WHERE domain_count <> 1
RETURN cat.id, cat.name, domain_count;

// 기대값: No records

// 6) Domain이 Security에 정확히 하나씩 연결됐는지 확인
MATCH (d:Domain)
OPTIONAL MATCH (s:Security)-[r:HAS_DOMAIN]->(d)
WITH d, count(r) AS security_count
WHERE security_count <> 1
RETURN d.id, d.name, security_count;

// 기대값: No records

// 7) 최종 총계
MATCH (n)
WITH count(n) AS total_nodes
MATCH ()-[r]->()
WITH total_nodes, count(r) AS total_relationships
MATCH (c:Control)
RETURN total_nodes, total_relationships, count(c) AS total_controls;

// 기대값: 335 / 637 / 248
