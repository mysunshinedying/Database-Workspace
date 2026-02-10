-- DML SELECT - GROUP BY 등
/*
    GROUP BY에서 사용 가능한 GROUP 함수
    SUM() : 합계
    AVG() : 평균
    COUNT() : 선택된 열의 행 수(널 값은 제외)
    COUNT(*) : 전체 행의 수
    MAX() : 최대
    MIN() : 최소
    
    GROUP BY <속성>
    그룹 질의를 기술할 때 사용
    특정 열로 그룹화한 후 각 그룹에 대해 한 행씩 질의 결과 생성    
    주의!!
    SELECT 절에는 GROUP BY에서 사용한 컬럼과 집계함수만 나올 수 있음
*/

-- 클라이언트 번호별 주문수량의 합계를 검색
SELECT SUM(bsQty) AS "총 주문수량", clientNo
FROM bookSale
WHERE clientNo = '2'
GROUP BY clientNo; -- 기준이 clientNo이므로 해당 컬럼은 select절에 사용 가능

-- GROUP BY
-- 도서 판매 테이블에서 도서번호별로 주문수량 합계 검색
SELECT bookNo, SUM(bsQty) AS 주문량합계
FROM bookSale
GROUP BY bookNo;

-- 도서 판매 테이블에서 도서번호별로 주문수량 합계 검색, 도서번호별 정렬
SELECT bookNo, SUM(bsQty) AS 주문량합계
FROM bookSale
GROUP BY bookNo
ORDER BY 1; -- 반환되는 테이블의 첫번째 컬럼 기준으로 정렬

SELECT bookNo, SUM(bsQty) AS 주문량합계
FROM bookSale
GROUP BY bookNo
ORDER BY bookNo;

-- 주문량 합계 기준 내림차순 정렬
SELECT bookNo, SUM(bsQty) AS 주문량합계
FROM bookSale
GROUP BY bookNo
ORDER BY "주문량합계" DESC;

SELECT bookNo, SUM(bsQty) AS 주문량합계
FROM bookSale
GROUP BY bookNo
ORDER BY 2 DESC;

------------------------------------------------------------------
-- 도서 테이블에서 출판사별 도서 중 도서 가격이 25000원 이상인 도서의 수량의 합계를 검색, 단 반환되는 결과는 도서가 2권 이상일 경우 반환한다.
-- 도서 가격이 25000 이상인 도서 : WHERE
-- 단, 반환되는 결과는 도서가 2권 이상 : 집계함수 결과로 확인해야함 => HAVING절 사용

SELECT pubNo, COUNT(*) AS "도서 수 합계"
FROM book
WHERE bookPrice >= 25000 -- GROUP BY 진행 전에 조건 절이 먼저 진행됨
GROUP BY pubNo;

/*
    HAVING <검색 조건>
    GROUP BY 절에 의해 구성된 그룹들에 대해 적용할 조건 기술
    SUM, AVG, MAX, MIN, COUNT 등의 함수와 함께 사용
    주의 !!
        1. 반드시 GROUP BY 절과 같이 사용
        2. GROUP BY 절보다 뒤에 표현
        3. <검색 조건>에는 집계함수가 와야 한다
*/

SELECT pubNo, COUNT(*) AS "도서 수 합계"
FROM book
WHERE bookPrice >= 25000 -- GROUP BY 진행 전에 조건 절이 먼저 진행됨
GROUP BY pubNo
HAVING COUNT(*) >= 2;

-- 도서 테이블에서 출판사별 도서의 총 재고수량을 검색하고 재고 20권 이상인 출판사만 출력
SELECT pubNo, SUM(bookStock) AS 총재고수량
FROM book
GROUP BY pubNo
HAVING SUM(bookStock) >= 20;

-- 테이블 복사 : SELECT된 결과를 테이블로 구성하는 기능
-- SELECT 반환 객체 -> 테이블 -> 복사해서 새로운 테이블로 영구저장 가능
/*
    CREATE TABLE 새테이블명 AS
    SELECT 절 FROM WHERE
    
    단, 제약조건은 복사되지 않음
    제약조건은 복사 후 설정해줘야함
*/

-- BOOK 테이블의 도서 정보 중 2019년 이후에 출판된 도서의 정보를 새로운 테이블 NEWBOOK으로 생성하시오
DROP TABLE newBook;

CREATE TABLE newBook AS
SELECT *
FROM book
WHERE bookDate >= '2019-01-01'; --date 타입은 비교연산자 사용 가능

SELECT * FROM newBook;

-- 제약 조건 추가
ALTER TABLE newBook
    ADD CONSTRAINT PK_newbook_bookNo
    PRIMARY KEY(bookNo);
    
-- 구조만 필요한 경우
DELETE FROM newBook; --조건 절 없음으로 모든 데이터가 삭제

-- 테이블 생성
-- BOOK 테이블의 BOOKNO, BOOKNAME 두 속성을 활용해서 새로운 테이블 구성

CREATE TABLE newBook2 AS
SELECT bookNo, bookName FROM book;

SELECT * FROM newBook2;

SELECT * FROM newBook;

-- INSERT를 SELECT된 결과로 실행
INSERT INTO newBook(bookNo, bookName)
SELECT bookNo, bookName
FROM newBook2;

SELECT * FROM newBook;