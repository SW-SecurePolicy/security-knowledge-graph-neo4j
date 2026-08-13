// 01. Constraints
// Neo4j 5+/Cypher 25 기준

CREATE CONSTRAINT security_id_unique IF NOT EXISTS
FOR (n:Security) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT framework_id_unique IF NOT EXISTS
FOR (n:Framework) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT domain_id_unique IF NOT EXISTS
FOR (n:Domain) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT category_id_unique IF NOT EXISTS
FOR (n:Category) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT control_id_unique IF NOT EXISTS
FOR (n:Control) REQUIRE n.id IS UNIQUE;
