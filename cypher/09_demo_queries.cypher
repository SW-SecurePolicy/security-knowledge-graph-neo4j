// 09. 발표/시연용 핵심 Graph Query

// 1) 공통 분류체계
MATCH p=
(s:Security)-[:HAS_DOMAIN]->(d:Domain)-[:HAS_CATEGORY]->(cat:Category)
RETURN p;

// 2) 세 Framework가 IAM-03에 연결되는 모습
MATCH p1=
(f:Framework)-[:HAS_CONTROL]->
(c:Control)-[:BELONGS_TO]->
(cat:Category {id:'IAM-03'})
MATCH p2=
(d:Domain)-[:HAS_CATEGORY]->
(cat)
RETURN p1, p2;

// 3) CASP-033의 Primary + Secondary Mapping
MATCH p1=
(f:Framework)-[:HAS_CONTROL]->
(c:Control {id:'CASP-033'})-[:BELONGS_TO]->
(primary:Category)
OPTIONAL MATCH p2=
(c)-[:RELATED_TO]->
(related:Category)
RETURN p1, p2;

// 4) 전체 그래프
MATCH p=()-[]->()
RETURN p;
