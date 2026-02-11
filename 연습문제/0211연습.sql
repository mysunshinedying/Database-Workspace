-- 0211 연습문제.SQL

-- 서브 쿼리 활용해서 질의 완성하세요(JOIN 등 다른 기능도 사용해볼것)

-- 호날두(고객명)가 주문한 도서의 총 구매량 출력

-- SUBQUERY 정답
SELECT SUM(BsQty)
FROM bookSale
WHERE clientNo IN (SELECT clientNo
                   FROM client
                   WHERE clientName = '호날두');

-- INNER JOIN 정답                    
SELECT SUM(BS.BsQty)
FROM bookSale BS
     INNER JOIN client C
     ON BS.clientNo = C.clientNo
WHERE C.clientName = '호날두';     
                    

-- ‘정보출판사’에서 출간한 도서를 구매한 적이 있는 고객명 출력
-- 고객명 중복 제거

-- SUBQUERY 정답
SELECT DISTINCT clientName
FROM client
WHERE clientNo IN ( SELECT clientNo
                   FROM bookSale
                   WHERE bookNo IN ( SELECT bookNo
                                    FROM book
                                    WHERE pubNo IN ( SELECT pubNo
                                                    FROM publisher
                                                    WHERE pubName = '정보출판사')
                                    )                        
                    );

-- INNER JOIN 정답    
SELECT DISTINCT C.clientName
FROM client C
     INNER JOIN bookSale BS
     ON BS.clientNo = C.clientNo
     INNER JOIN book B
     ON BS.bookNo = B.bookNo
     INNER JOIN publisher P
     ON P.pubNo = B.pubNo
WHERE P.pubName = '정보출판사';     

-- 베컴이 주문한 도서의 최고 주문수량 보다 더 많은 도서를 구매한 고객명 출력
-- 고객명 중복 제거

-- 1번 풀이
SELECT DISTINCT clientName
FROM client C
      INNER JOIN bookSale BS
      ON C.clientNo = BS.clientNo
WHERE BS.bsQty > (SELECT MAX(bsQTY)
                FROM bookSale
                WHERE clientNo IN ( SELECT clientNo
                                    FROM client
                                    WHERE clientName = '베컴')
                    );

-- 2번 풀이
SELECT DISTINCT C.clientName
FROM client C
    INNER JOIN bookSale BS
    ON C.clientNo = BS.clientNo
    INNER JOIN (SELECT MAX(bsQty) AS "베컴주문수량"
                FROM bookSale
                WHERE clientNo IN (SELECT clientNo
                                   FROM client
                                   WHERE clientName = '베컴')) BM
     ON BS.bsQty > BM."베컴주문수량";

-- 천안에 거주하는 고객에게 판매한 도서의 총 판매량 출력

-- 1번 풀이 (SUBQUERY & JOIN)
SELECT SUM(bookSale.bsQty) AS "총 판매량"
FROM (SELECT clientNo
      FROM client
      WHERE clientAddress = '천안') client, bookSale
WHERE client.clientNo = bookSale.clientNo;

-- 2번 풀이 (JOIN만 사용)
SELECT SUM(BS.bsQty) AS "총 판매량"
FROM bookSale BS
     INNER JOIN client C
     ON BS.clientNo = C.clientNo
WHERE C.clientAddress = '천안';


-- 함수 사용 연습 문제

-- 저자 중 성(姓)이 '손'인 모든 저자 출력
SELECT SUBSTR(bookAuthor,1,1) 성, bookAuthor
FROM book
WHERE SUBSTR(bookAuthor,1,1) = '손';

-- 저자 중에서 같은 성(姓)을 가진 사람이 몇 명이나 되는지 알아보기 위해 성(姓)별로 그룹 지어 인원수 출력
SELECT SUBSTR(bookAuthor, 1, 1) AS 성, COUNT(*) AS 인원수
FROM book
GROUP BY SUBSTR(bookAuthor,1,1);

-- 아래와같은 테이블을 생성하고 CUBE, ROLLUP, GROUPING SETS를 적용시켜 결과를 설명하시오
CREATE TABLE sales(
    prdName VARCHAR2(20),
    salesDate VARCHAR2(10),
    prdCompany VARCHAR2(10),
    salesAmount NUMBER(8)
);

INSERT INTO sales VALUES('노트북' ,'2021.01', '삼성', 10000);
INSERT INTO sales VALUES('노트북' ,'2021.03', '삼성', 20000);
INSERT INTO sales VALUES('냉장고' ,'2021.01', 'LG', 12000);
INSERT INTO sales VALUES('냉장고' ,'2021.03', 'LG', 20000);
INSERT INTO sales VALUES('프린터' ,'2021.01', 'HP', 3000);
INSERT INTO sales VALUES('프린터' ,'2021.03', 'HP', 1000);


SELECT prdName, salesDate, prdCompany, SUM(salesAmount) AS "금액합계"
FROM sales
GROUP BY CUBE(prdName, salesDate, prdCompany)
ORDER BY prdName, salesDate, prdCompany;


SELECT prdName, salesDate, prdCompany, SUM(salesAmount) AS "금액합계"
FROM sales
GROUP BY ROLLUP(prdName, salesDate, prdCompany)
ORDER BY prdName, salesDate, prdCompany;

SELECT prdName, salesDate, prdCompany, SUM(salesAmount) AS "금액합계"
FROM sales
GROUP BY GROUPING SETS(prdName, salesDate, prdCompany);

-- 자세한 결과 설명 필요
/*
    -- CUBE의 경우
    모든 그룹의 소계 조합이 나타난다.
    prdName, salesDate, prdCompany 이므로 각각에 대한 소계, 둘의 조합에 대한 소계, 그리고 전체 소계가 나타난다.
    
    -- ROLLUP의 경우
    왼쪽부터 순차적으로 계층을 만든다. 먼저 나오는 컬럼이 기준이 된다.
    현재는 prdName을 왼쪽에 사용했기 때문에
    (1) prdName, salesDate, prdCompany의 조합 소계
    (2) prdName, salesDate의 조합 소계
    (3) prdName의 소계
    (4) 전체 소계
    형태로 나타난다. 이에 따라 salesDate를 맨앞에 할 경우 salesDate를 기준으로
    (1) salesDate, prdName, prdCompany의 조합 소계
    (2) salesDate, prdName 조합 소계
    (3) salesDate 소계
    (4) 전체 소계
    로 나타날 것이다.
    
    -- GROUPING SETS의 경우 소계만을 산출한다.
    prdName에 대한 소계, salesDate에 대한 소계, prdCompany에 대한 소계를 산출한다.
*/


-- 주문 테이블에서 주문일에 7일을 더한 날을 배송일로 계산하여 출력
SELECT bsDate AS "주문일", bsDate + 7 AS "배송일"
FROM bookSale;

-- 도서 테이블에서 도서명과 출판연도 출력
SELECT bookName, EXTRACT(YEAR FROM bookDate) AS "출판년도"
FROM book;
