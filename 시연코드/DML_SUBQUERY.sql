-- 서브쿼리 유형 예시

-- 서브 쿼리 종류 : 스칼라 서브 쿼리(Scholar Subquery)

/*
    SELECT 절에서 사용
    결과 값을 단일 열의 스칼라 값으로 반환
    스칼라 값이 들어갈 수 있는 모든 곳에서 사용 가능
    일반적으로 SELECT 문과 UPDATE SET 문에서 사용
*/

-- 고객별로 총 주문수량 검색 : 고객번호, 고객이름, 고객별 총 주문수량
-- SUBQUERY 활용해서 고객이름 SELECT
SELECT clientNo,
    (
        SELECT clientName
        FROM client
        WHERE client.clientNo = bookSale.clientNo
    ) AS "CLIENT NAME",
    SUM(bsQty) AS 총주문수량
FROM bookSale
GROUP BY clientNo
ORDER BY 총주문수량 DESC;

-- 인라인뷰(INLINE VIEW) 서브쿼리
/*
    FROM절에서 사용
    가상의 뷰 형태로 제공
    즉, 테이블명 대신 인라인 뷰 부속 질의 결과(가상 테이블) 사용
    부속 질의 결과로 반환되는 데이터는 다중 행, 다중 열이어도 상관 없음
    개발 중에 뷰가 필요한 모든 경우에 뷰를 생성하면 관리할 양이 너무 많아 트랜잭션 관리나 성능 상의 문제가 발생할 수 있는 경우에 인라인 뷰 사용
*/

-- 도서 가격이 25000원 이상인 도서 중 판매된 도서에 대해 도서별로 도서명, 가격, 총판매수량, 총판매액 검색
-- 인라인뷰 서브쿼리 사용

SELECT * FROM book;

-- 도서 테이블에서 질의에 필요한 컬럼과 레코드만 추출(VIEW로 사용할 예정)
SELECT bookNo, bookName, bookPrice
FROM book
WHERE  bookPrice >= 25000;

-- 도서 가격이 25000원 이상인 도서 중 판매된 도서에 대해 도서별로 도서명, 가격, 총판매수량, 총판매액 검색, 총 판매액 기준 내림차순 정렬
-- 인라인뷰 서브쿼리와 일반 테이블간의 JOIN
SELECT book.bookName, book.bookPrice, SUM(bookSale.bsQty) AS "총 판매수량", SUM(book.bookPrice * bookSale.bsQty) AS "총 판매액"
FROM (SELECT bookNo, bookName, bookPrice
      FROM book
      WHERE bookPrice >= 25000) book, bookSale -- FROM 절에서 뷰와 테이블 명을 나열하면 INNER JOIN이 진행됨
WHERE book.bookNo = bookSale.bookNo -- JOIN 조건
GROUP BY book.bookNo, book.bookName, book.bookPrice
ORDER BY "총 판매액" DESC;

