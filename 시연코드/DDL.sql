CREATE TABLE product(
    prdNo VARCHAR(10) NOT NULL,
    prdName VARCHAR2(30) NOT NULL,
    prdPrice NUMBER(8),
    prdCompany VARCHAR2(30),
    CONSTRAINT  PK_product_prdNo PRIMARY KEY(prdNo)
);

-- 기본 키는 특정 속성에 지정
-- 중복 불가/null 불가

-- 기본 키 지정
-- 1. CONSTRAINT key명 PRIMARY KEY(필드명)
-- 2. 속성 옆에 PRIMARY KEY 지정
-- 3. 구성 마지막에 PRIMARY KEY(필드명)

CREATE TABLE product1(
    prdNo VARCHAR(10) NOT NULL PRIMARY KEY,
    prdName VARCHAR2(30) NOT NULL,
    prdPrice NUMBER(8),
    prdCompany VARCHAR2(30)
);

CREATE TABLE product2(
    prdNo VARCHAR(10) NOT NULL,
    prdName VARCHAR2(30) NOT NULL,
    prdPrice NUMBER(8),
    prdCompany VARCHAR2(30),
    PRIMARY KEY(prdNo)
);

-- 비권장
CREATE TABLE product4(
    prdNo VARCHAR(10) NOT NULL CONSTRAINT  PK_product_prdNo4 PRIMARY KEY,
    prdName VARCHAR2(30) NOT NULL,
    prdPrice NUMBER(8),
    prdCompany VARCHAR2(30)
);

/*
    만국공통 긴 주석
    출판사 TABLE 생성(번호, 이름)
    제약 조건 
        - 기본 KEY pubNo NOT NULL
        - pubName NOT NULL
*/

-- 데이터 삽입 시 컬럼의 값은 비워질 수 있도록 구성
-- 반드시 값이 필요할 경우 NOT NULL
CREATE TABLE publisher (
    pubNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    pubName VARCHAR2(30) NOT NULL
);

/*
    한 개의 도서는 한 개의 출판사에서 발행
    도서 테이블
    - 기본 KEY 도서번호(bookNo)
    - 외래 KEY 출판사 테이블의 출판사 번호(pubNo)
    - 외래 키(참조 무결성) 제약조건 추가 : CONSTRAINT 제약조건 식별자 제약조건종류
    
    속성(필드)에는 기본 값 사용이 가능 DEFAULT, CHECK()
    제약조건 식별자 : 기본 키는 PK, 외래키는 FK(참조 무결성)
    CONSTRAINT FK_자식테이블_참조테이블_참조키 FOREIGN KEY (자식테이블의_컬럼) REFERENCES 참조테이블(참조테이블의_PK컬럼)
*/

CREATE TABLE book (
    bookNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    bookName VARCHAR2(30) NOT NULL,
    bookPrice NUMBER(8) DEFAULT 10000 CHECK(bookPrice > 1000),
    bookDate DATE,
    pubNo VARCHAR2(10) NOT NULL,
    CONSTRAINT FK_book_publisher_pubNo FOREIGN KEY(pubNo) REFERENCES publisher(pubNo)
    
);

-- book에서 publisher를 참조하기 때문에
-- 참조 관계가 있을 경우 참조 테이블이 선행 생성 되어있어야 함
-- 데이터 입력시에도 해당 테이블의 데이터가 먼저 입력되어 있어야 함
-- 참조하는 테이블의 데이터가 삽입될 때 참조조건을 확인해야 하므로 

-- 자식 테이블이 선행 삭제 되어야 함

-- 자식 테이블에서 참조하고 있을 경우, 해당 테이블 데이터를 수정/삭제 한 후의 부모(참조)테이블의 데이터를 삭제해야함


-- ALTER 문
/*
ALTER TABLE
    ADD : 열 추가
    DROP COLUMN : 열 삭제
    DROP : 여러 개의 열 삭제
    RENAME COLUMN : 열의 이름 변경
    MODIFY : 열의 데이터 형식 변경
    DROP PRIMARY KEY : 기본키 삭제
    DROP CONSTRAINT : 제약조건 삭제
    ADD CONSTRAINT : 제약조건 추가
*/

-- 열 추가
ALTER TABLE product ADD(
    prdUnitPrice NUMBER(8),
    prdStock NUMBER(12)
);

--속성(열) 데이터 형식 변경
ALTER TABLE product MODIFY prdUnitPrice NUMBER(4);

--열의 제약 조건 변경(prdName NOT NULL -> NULL)
ALTER TABLE product MODIFY prdName VARCHAR2(30) NULL;

--컬럼명 변경
ALTER TABLE product RENAME COLUMN prdUnitPrice TO PrdUPrice;

--컬럼 삭제
ALTER TABLE product DROP COLUMN prdStock;

--여러 열 삭제 : DROP(컬럼명1, 컬럼명2,...)
ALTER TABLE product DROP (prdUPrice, prdCompany);

--제약조건 삭제(기본 키 DROP PRIMARY KEY)
-- SQL 문법 상 기본 키 제약조건 없어도 오류는 없음
ALTER TABLE product DROP PRIMARY KEY;

--참조 무결성(외래키 제약조건)으로 참조되어 있는 경우에는 기본키 제약조건 삭제 불가
--publisher는 book이 참조중
ALTER TABLE publisher DROP PRIMARY KEY;
/*
ALTER TABLE publisher DROP PRIMARY KEY
오류 보고 -
ORA-02273: 고유/기본 키가 외부 키에 의해 참조되었습니다*/

--참조하고 있어도 무조건 기본 키 삭제 (비권장)
-- 참조되고 있는 테이블의 기본 key가 삭제되면 논리적으로 위배되기 때문에 참조하는(자식) 테이블의 외래키 제약조건도 삭제
ALTER TABLE publisher DROP PRIMARY KEY CASCADE;

-- 제약 조건 추가: 기본키 추가
ALTER TABLE publisher ADD CONSTRAINT PK_publisher_pubNo PRIMARY KEY(pubNo);

--외래 키 추가
ALTER TABLE book ADD CONSTRAINT FK_book_publisher_pubNo FOREIGN KEY(pubNo) REFERENCES publisher(pubNo);

/*----------------------------------------------------------
    테이블 삭제 : 테이블의 구조와 데이터를 삭제한다
    데이터만 삭제 : DML 문의 DELETE 문
    삭제 쿼리 : DROP TABLE 테이블명 [PURGE | CASCADE CONSTRAINTS]
    PURGE : 복구 가능한 임시 테이블 생성하지 않고 영구히 삭제
    CASCADE CONSTRANTS : 다른 쪽에서 참조하고 있어도 삭제(비권장)
--------------------------------------------------------*/

DROP TABLE publisher;
DROP TABLE publisher CASCADE CONSTRAINTS;

--참조되지 않는 테이블
DROP TABLE product;


-----------------------------------------------------------------------------
/*
    시퀀스
    데이터베이스 객체로 유일한 값으로 일련번호 생성
    지정된 수치로 증가하거나 감소
    기본키 값을 일련번호로 자동 생성할 때 사용
    최대 15개까지 생성 가능
    테이블과 독립적으로 저장되고 생성
    하나의 시퀀스를 여러 테이블에서 사용 가능
    
    CREATE SEQUENCE 시퀀스명
    START WITH 시작값
    INCREMENT BY 증가값
    MAXVALUE 최대값
    MINVALUE 최소값
    CYCLE/NOCYCLE;

*/

CREATE SEQUENCE NO_SEQ
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 10000
    NOCYCLE;

/* 현재 시퀀스 값 검색 : 현재까지 사용한 시퀀스 값 반환
    SELECT NO_SEQ.CURRVAL
    FROM dual;
    사용해야함
*/

SELECT NO_SEQ.CURRVAL FROM dual;
    
-- 시퀀스 수정: 구조 수정(객체 수정이므로 ALTER)
ALTER SEQUENCE NO_SEQ
    MAXVALUE 1000;
    
-- 시퀀스 구조 속성 검색(ALTER로 수정한 구조 속성 확인)
-- USER_SEQUENCES : SYSTEM TABLE 활용(일반 사용자 검색 권한 있음)

SELECT * FROM USER_SEQUENCES;

-- 시퀀스 삭제
DROP SEQUENCE NO_SEQ;

-- 시퀀스 삭제 결과 확인
SELECT SEQUENCE_NAME FROM USER_SEQUENCES;

-- SELECT는 반환되는 레코드가 없어도 빈객체를 반환함