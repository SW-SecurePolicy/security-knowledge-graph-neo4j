// 02. Security / Domain / Category 구축

MERGE (s:Security {id: 'SECURITY'})
SET s.name = 'Security';

UNWIND [
  { id: 'GOV', name: '거버넌스·준수' },
  { id: 'RSK', name: '위험관리' },
  { id: 'AST', name: '자산·정보관리' },
  { id: 'HUM', name: '인적보안' },
  { id: 'SUP', name: '공급망·외부자' },
  { id: 'PHY', name: '물리·환경보안' },
  { id: 'IAM', name: '계정·접근통제' },
  { id: 'CRY', name: '암호화·키관리' },
  { id: 'OPS', name: '시스템·운영보안' },
  { id: 'NET', name: '네트워크·통신보안' },
  { id: 'LOG', name: '로그·모니터링' },
  { id: 'DEV', name: '개발·변경보안' },
  { id: 'INC', name: '사고대응' },
  { id: 'BCP', name: '백업·연속성·재해복구' },
  { id: 'DAT', name: '데이터보호·개인정보' },
  { id: 'CLD', name: '클라우드·가상화' }
] AS row
MERGE (d:Domain {id: row.id})
SET d.name = row.name
WITH d
MATCH (s:Security {id: 'SECURITY'})
MERGE (s)-[:HAS_DOMAIN]->(d);

UNWIND [
  { id: 'GOV-01', name: '정책·지침', domain_id: 'GOV', description: '정책, 조직, 책임, 경영진, 감사 및 준수' },
  { id: 'GOV-02', name: '조직·역할·경영진', domain_id: 'GOV', description: '정책, 조직, 책임, 경영진, 감사 및 준수' },
  { id: 'GOV-03', name: '감사·검토·개선', domain_id: 'GOV', description: '정책, 조직, 책임, 경영진, 감사 및 준수' },
  { id: 'GOV-04', name: '준수·문서·프로젝트', domain_id: 'GOV', description: '정책, 조직, 책임, 경영진, 감사 및 준수' },
  { id: 'RSK-01', name: '위험 식별·평가', domain_id: 'RSK', description: '위험의 식별·평가·처리 및 위협 정보' },
  { id: 'RSK-02', name: '위험 처리·위협정보', domain_id: 'RSK', description: '위험의 식별·평가·처리 및 위협 정보' },
  { id: 'AST-01', name: '자산 식별·목록', domain_id: 'AST', description: '자산과 정보의 식별, 분류, 사용 및 매체 관리' },
  { id: 'AST-02', name: '자산 분류·중요도', domain_id: 'AST', description: '자산과 정보의 식별, 분류, 사용 및 매체 관리' },
  { id: 'AST-03', name: '자산 사용·반납·매체', domain_id: 'AST', description: '자산과 정보의 식별, 분류, 사용 및 매체 관리' },
  { id: 'AST-04', name: '정보 분류·전송·기록보호', domain_id: 'AST', description: '자산과 정보의 식별, 분류, 사용 및 매체 관리' },
  { id: 'HUM-01', name: '채용·신원·서약', domain_id: 'HUM', description: '임직원 채용부터 퇴직까지의 인적 보안' },
  { id: 'HUM-02', name: '교육·인식', domain_id: 'HUM', description: '임직원 채용부터 퇴직까지의 인적 보안' },
  { id: 'HUM-03', name: '직무분리·주요직무', domain_id: 'HUM', description: '임직원 채용부터 퇴직까지의 인적 보안' },
  { id: 'HUM-04', name: '퇴직·직무변경·징계', domain_id: 'HUM', description: '임직원 채용부터 퇴직까지의 인적 보안' },
  { id: 'SUP-01', name: '업체 선정·계약', domain_id: 'SUP', description: '외부자, 위탁, 공급자 및 공급망 보안' },
  { id: 'SUP-02', name: '공급망·위탁', domain_id: 'SUP', description: '외부자, 위탁, 공급자 및 공급망 보안' },
  { id: 'SUP-03', name: '점검·서비스관리·종료', domain_id: 'SUP', description: '외부자, 위탁, 공급자 및 공급망 보안' },
  { id: 'PHY-01', name: '보호구역·출입통제', domain_id: 'PHY', description: '시설, 출입, 장비, 환경 및 물리적 보호' },
  { id: 'PHY-02', name: '시설·환경·전원', domain_id: 'PHY', description: '시설, 출입, 장비, 환경 및 물리적 보호' },
  { id: 'PHY-03', name: '물리 모니터링', domain_id: 'PHY', description: '시설, 출입, 장비, 환경 및 물리적 보호' },
  { id: 'PHY-04', name: '장비·외부자산·유지보수', domain_id: 'PHY', description: '시설, 출입, 장비, 환경 및 물리적 보호' },
  { id: 'IAM-01', name: '계정·식별관리', domain_id: 'IAM', description: '사용자 식별, 인증, 계정, 권한 및 접근 통제' },
  { id: 'IAM-02', name: '인증·비밀번호·MFA', domain_id: 'IAM', description: '사용자 식별, 인증, 계정, 권한 및 접근 통제' },
  { id: 'IAM-03', name: '권한·최소권한', domain_id: 'IAM', description: '사용자 식별, 인증, 계정, 권한 및 접근 통제' },
  { id: 'IAM-04', name: '특권·특수권한', domain_id: 'IAM', description: '사용자 식별, 인증, 계정, 권한 및 접근 통제' },
  { id: 'IAM-05', name: '정보·시스템 접근통제', domain_id: 'IAM', description: '사용자 식별, 인증, 계정, 권한 및 접근 통제' },
  { id: 'IAM-06', name: '원격접근·세션·소스코드', domain_id: 'IAM', description: '사용자 식별, 인증, 계정, 권한 및 접근 통제' },
  { id: 'CRY-01', name: '암호정책·저장암호화', domain_id: 'CRY', description: '암호화 적용과 암호키 관리' },
  { id: 'CRY-02', name: '전송 데이터 보호', domain_id: 'CRY', description: '암호화 적용과 암호키 관리' },
  { id: 'CRY-03', name: '암호키 관리', domain_id: 'CRY', description: '암호화 적용과 암호키 관리' },
  { id: 'OPS-01', name: '형상·패치·취약점', domain_id: 'OPS', description: '시스템 운영, 형상, 패치, 취약점 및 엔드포인트' },
  { id: 'OPS-02', name: '악성코드·엔드포인트', domain_id: 'OPS', description: '시스템 운영, 형상, 패치, 취약점 및 엔드포인트' },
  { id: 'OPS-03', name: '용량·성능', domain_id: 'OPS', description: '시스템 운영, 형상, 패치, 취약점 및 엔드포인트' },
  { id: 'OPS-04', name: '운영 소프트웨어·유틸리티', domain_id: 'OPS', description: '시스템 운영, 형상, 패치, 취약점 및 엔드포인트' },
  { id: 'OPS-05', name: '서버·DB·서비스 보안', domain_id: 'OPS', description: '시스템 운영, 형상, 패치, 취약점 및 엔드포인트' },
  { id: 'NET-01', name: '네트워크 접근통제', domain_id: 'NET', description: '네트워크 접근, 분리, 서비스 및 웹/통신 보안' },
  { id: 'NET-02', name: '네트워크·서비스 보안', domain_id: 'NET', description: '네트워크 접근, 분리, 서비스 및 웹/통신 보안' },
  { id: 'NET-03', name: '네트워크 분리·무선', domain_id: 'NET', description: '네트워크 접근, 분리, 서비스 및 웹/통신 보안' },
  { id: 'NET-04', name: '웹·인터넷 보안', domain_id: 'NET', description: '네트워크 접근, 분리, 서비스 및 웹/통신 보안' },
  { id: 'LOG-01', name: '로그 수집·보관·무결성', domain_id: 'LOG', description: '로그 수집·보관, 무결성, 모니터링 및 관제' },
  { id: 'LOG-02', name: '모니터링·이상징후·관제', domain_id: 'LOG', description: '로그 수집·보관, 무결성, 모니터링 및 관제' },
  { id: 'LOG-03', name: '시각 동기화', domain_id: 'LOG', description: '로그 수집·보관, 무결성, 모니터링 및 관제' },
  { id: 'DEV-01', name: '보안 요구사항·SDLC', domain_id: 'DEV', description: '개발 생명주기, 코딩, 테스트, 변경 및 개발환경' },
  { id: 'DEV-02', name: '보안 아키텍처', domain_id: 'DEV', description: '개발 생명주기, 코딩, 테스트, 변경 및 개발환경' },
  { id: 'DEV-03', name: '보안 코딩·테스트', domain_id: 'DEV', description: '개발 생명주기, 코딩, 테스트, 변경 및 개발환경' },
  { id: 'DEV-04', name: '개발·테스트·운영 분리', domain_id: 'DEV', description: '개발 생명주기, 코딩, 테스트, 변경 및 개발환경' },
  { id: 'DEV-05', name: '변경관리', domain_id: 'DEV', description: '개발 생명주기, 코딩, 테스트, 변경 및 개발환경' },
  { id: 'DEV-06', name: '위탁개발·테스트정보', domain_id: 'DEV', description: '개발 생명주기, 코딩, 테스트, 변경 및 개발환경' },
  { id: 'INC-01', name: '사고 대응체계·준비', domain_id: 'INC', description: '침해사고 준비, 평가, 대응, 보고 및 사후 개선' },
  { id: 'INC-02', name: '이벤트 평가·보고', domain_id: 'INC', description: '침해사고 준비, 평가, 대응, 보고 및 사후 개선' },
  { id: 'INC-03', name: '사고대응·증거수집', domain_id: 'INC', description: '침해사고 준비, 평가, 대응, 보고 및 사후 개선' },
  { id: 'INC-04', name: '사후개선·모의훈련', domain_id: 'INC', description: '침해사고 준비, 평가, 대응, 보고 및 사후 개선' },
  { id: 'BCP-01', name: '백업·복구', domain_id: 'BCP', description: '백업, 이중화, 업무연속성 및 재해복구' },
  { id: 'BCP-02', name: '이중화·복제', domain_id: 'BCP', description: '백업, 이중화, 업무연속성 및 재해복구' },
  { id: 'BCP-03', name: 'BIA·DRP·RTO/RPO', domain_id: 'BCP', description: '백업, 이중화, 업무연속성 및 재해복구' },
  { id: 'BCP-04', name: '업무연속성·재해복구훈련', domain_id: 'BCP', description: '백업, 이중화, 업무연속성 및 재해복구' },
  { id: 'DAT-01', name: '개인정보 수집·이용', domain_id: 'DAT', description: '개인정보와 중요 데이터의 수집, 이용, 제공, 보관, 파기 및 보호' },
  { id: 'DAT-02', name: '제3자 제공·위탁·국외이전', domain_id: 'DAT', description: '개인정보와 중요 데이터의 수집, 이용, 제공, 보관, 파기 및 보호' },
  { id: 'DAT-03', name: '보유·파기', domain_id: 'DAT', description: '개인정보와 중요 데이터의 수집, 이용, 제공, 보관, 파기 및 보호' },
  { id: 'DAT-04', name: '정보주체 권리보장', domain_id: 'DAT', description: '개인정보와 중요 데이터의 수집, 이용, 제공, 보관, 파기 및 보호' },
  { id: 'DAT-05', name: '데이터 마스킹·비식별화', domain_id: 'DAT', description: '개인정보와 중요 데이터의 수집, 이용, 제공, 보관, 파기 및 보호' },
  { id: 'DAT-06', name: '데이터 유출방지', domain_id: 'DAT', description: '개인정보와 중요 데이터의 수집, 이용, 제공, 보관, 파기 및 보호' },
  { id: 'DAT-07', name: '중요정보 처리·보호', domain_id: 'DAT', description: '개인정보와 중요 데이터의 수집, 이용, 제공, 보관, 파기 및 보호' },
  { id: 'CLD-01', name: '클라우드 거버넌스·책임', domain_id: 'CLD', description: '클라우드 서비스, 가상화, 테넌트 및 클라우드 자원 보호' },
  { id: 'CLD-02', name: '가상화·하이퍼바이저 보안', domain_id: 'CLD', description: '클라우드 서비스, 가상화, 테넌트 및 클라우드 자원 보호' },
  { id: 'CLD-03', name: '테넌트·자원 격리', domain_id: 'CLD', description: '클라우드 서비스, 가상화, 테넌트 및 클라우드 자원 보호' },
  { id: 'CLD-04', name: '클라우드 특화 보호조치', domain_id: 'CLD', description: '클라우드 서비스, 가상화, 테넌트 및 클라우드 자원 보호' }
] AS row
MERGE (c:Category {id: row.id})
SET c.name = row.name,
    c.description = row.description
WITH c, row
MATCH (d:Domain {id: row.domain_id})
MERGE (d)-[:HAS_CATEGORY]->(c);
