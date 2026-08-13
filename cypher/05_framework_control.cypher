// 05. Framework -> Control 연결

MATCH (c:Control)
MATCH (f:Framework {id: c.framework})
MERGE (f)-[:HAS_CONTROL]->(c);
