// 03. Framework 노드 구축

UNWIND [
  { id: 'CASP', name: 'CASP' },
  { id: 'ISMS-P', name: 'ISMS-P' },
  { id: 'ISO27001', name: 'ISO/IEC 27001:2022' }
] AS row
MERGE (f:Framework {id: row.id})
SET f.name = row.name;
