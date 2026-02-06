-- 테이블 제약조건 확인 쿼리
-- 일반 계정에서 접근(확인) 가능함
-- USER CONSTRAINTS : 해당 USER의 소유 테이블의 모든 제약조건 확인
-- 제약조건 타입
-- C :CHECK ON A TABLE;
-- P : PRIMARY KEY;
-- R : FORIEGN KEY;

SELECT * FROM USER_CONSTRAINTS;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'BOOK'; --BOOK TABLE의 제약조건 확인