/*
    데이터 조작어(DML) : 데이터 입력/수정/삭제/검색
    INSERT/UPDATE/DELETE/SELECT
*/

-- INSERT
-- 기본형식 : INSERT INTO 테이블명(컬럼명 리스트) VALUES (값리스트);

DROP TABLE PUB;

-- 수업용 테이블
CREATE TABLE pub (
  pubNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    pubName VARCHAR(30) NOT NULL
 );
 
INSERT INTO pub (pubNo, pubName) VALUES('1', '서울 출판사');
INSERT INTO pub (pubNo, pubName) VALUES('2', '강남 출판사');
INSERT INTO pub (pubNo, pubName) VALUES('3', '종로 출판사');
 
SELECT * FROM PUB; 
 -- BOOK 테이블 외래키 추가
 ALTER TABLE book ADD CONSTRAINT FK_book_pub_pubNo FOREIGN KEY(pubNo) REFERENCES pub(pubNo);

-- BOOK 테이블에 데이터 입력
INSERT INTO book(bookNo,bookName,bookPrice,bookDate,pubNo)
    VALUES(
        '5','자바스크립트',23000,'2019-05-17','1'
    );
    
SELECT * FROM BOOK;     

-- 모든 컬럼 값 입력할 경우 열이름 생략 가능

INSERT INTO book
    VALUES(
        '6','C++프로그래밍',25000,'2024-02-02','2'
    );
SELECT * FROM BOOK;     

-- 여러개의 레코드를 한꺼번에 INSERT
--DBNS 마다 차이가 있음

/*
    INSERT ALL
        INTO 테이블명([컬럼명 나열]) VALUE(값 나열)
        INTO 테이블명([컬럼명 나열]) VALUE(값 나열)
        INTO 테이블명([컬럼명 나열]) VALUE(값 나열)..
    SELECT *
    FROM DUAL; --가짜(가상) 테이블
*/

INSERT ALL
    INTO book VALUES('7','알고리즘',25000,'2023-02-02','1')
    INTO book VALUES('8','웹프로그래밍',26000,'2025-11-11','2')
    SELECT *
    FROM DUAL;    
    
SELECT * FROM BOOK;      

-- 일부 컬럼값만 삽입하려면 컬럼명은 추가되어야 함
-- BOOKPRICE에 기본값을 넣었으므로 삽입하지 않아도 기본값으로
INSERT INTO book (bookNo,bookName,bookDate,pubNo)
VALUES('9', 'C 프로그래밍','2024-02-02','2');

INSERT INTO book
    VALUES(
        '10','C++프로그래밍',1000,'2024-02-02','2'
    );
    