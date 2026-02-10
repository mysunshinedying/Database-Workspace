-- 테이블 제약조건 확인 쿼리
-- 일반 계정에서 접근(확인) 가능함
-- USER CONSTRAINTS : 해당 USER의 소유 테이블의 모든 제약조건 확인
-- 제약조건 타입
-- C :CHECK ON A TABLE;
-- P : PRIMARY KEY;
-- R : FORIEGN KEY;

SELECT * FROM USER_CONSTRAINTS;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'BOOK'; --BOOK TABLE의 제약조건 확인

/*
    DUAL 테이블:
    시스템이 제공하는 기능(함수) 사용하기 위해 오라클이 제공하는 테이블
    1개의 행과 1개의 열만 있는 DUMMY 테이블
    SYS 소유지만 모든 사용자가 접근 가능
    
    용도: 
        간단하게 함수를 이용하여 계산 결과값 확인
        함수 결과 확인을 위해서는 SELECT 절을 이용해야함
        SELECT ~ FROM이 기본 구조 : 함수는 독립적 모듈이므로 연결된 객체 or 테이블이 없음
        SELECT 함수식 FROM 테이블(DUAL) 제공
        ex. SELECT 시퀀스.NEXTVAL FROM DUAL
        
*/

-- 날씨 관련 오라클 함수(기능) : SYSDATE/CURRENT_DATE;
SELECT SYSDATE FROM DUAL;

SELECT 3 FROM DUAL;
SELECT CURRENT_DATE FROM DUAL;

SELECT 3 + 5 FROM DUAL;