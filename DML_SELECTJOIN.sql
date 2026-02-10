-- 테이블의 결합 : JOIN, SELECT의 확장 : SUBQUERY
/*
    JOIN : 테이블의 결합
    관계형 데이터베이스의 특징
        1. 중복되는 데이터를 최소화
        2. 현재 테이블에 없는 데이터는 다른 테이블과의 관계를 통해 확인
        ex. 도서번호 1001번 도서를 출판한 출판사의 출판사명 검색
        
    조인의 종류
        INNER JOIN(내부조인) : 가장 많이 사용
            공통되는 컬럼이 있을 때
            공통 속성의 값이 동일한 레코드만 반환
            두 테이블의 외래키와 기본키로 연결되어 있으면 공통컬럼 : 외래키, 기본키

        OUTER JOIN(외부조인)
            공통되는 컬럼이 없을 때도 사용가능
            공통된 속성을 매개로하는 정보가 없더라도 버리지 않고 연산의 결과를 릴레이션에 표시
*/

-- 두 테이블에 대한 곱하기 연산
SELECT * FROM book;
SELECT * FROM publisher;

SELECT *
FROM book, publisher
WHERE book.pubNo = publisher.pubNo -- 조인 조건
      AND bookNo = '1001';
      
SELECT bookNo, book.pubNo, pubName
FROM book, publisher
WHERE book.pubNo = publisher.pubNo -- 조인 조건
      AND bookNo = '1001';      
      
------------------------------------------------------------------
-- INNER JOIN
/*
    SELECT 컬럼 리스트
    FROM 테이블명1
        INNER JOIN 테이블명2
        ON 조인조건(기본키=외래키)
*/

-- BOOKSALE 테이블과 CLIENT 테이블의 INNER JOIN
-- 주문테이블에서 확인 가능한 고객의 정보
SELECT *
FROM bookSale
    INNER JOIN client
    ON bookSale.clientNo = client.clientNo;
    
-- 주문한 고객의 이름과 주소
-- 고객의 이름과 주소
SELECT clientName, clientAddress
FROM client;
    
-- 주문한 고객의 이름과 주소 : 여러 번 주문한 고객은 주문 수만큼 레코드가 생성됨    
SELECT client.clientNo,clientName, clientAddress
FROM client
    INNER JOIN bookSale
    ON client.clientNo = bookSale.clientNo;
    
-- 주문한 적 있는 고객 조회
SELECT DISTINCT client.clientNo, clientName, clientAddress
FROM client
    INNER JOIN bookSale
    ON client.clientNo = bookSale.clientNo;
    
-- 양쪽 테이블에 공통되는 열에 대해서는 테이블 명을 표기하여 모호성 없애야함
-- 테이블 명 없으면 오류 발생
-- ORA-00918 : 열의 정의가 애매합니다. clientNo가 두 테이블 모두에 컬럼명으로 있음(select, on, where 절 모두에 해당)

/*
SELECT DISTINCT clientNo,clientName, clientAddress
FROM client
    INNER JOIN bookSale
    ON client.clientNo = bookSale.clientNo;
*/

-- 공통되는 컬럼에만 테이블 명을 추가했음. 테이블명이 없는 컬럼은 검색할 시 효율이 떨어짐
-- 테이블명 추가가 컬럼의 정확한 위치를 알려주므로 성능이 향상
SELECT DISTINCT client.clientNo, client.clientName, client.clientAddress
FROM client
    INNER JOIN bookSale
    ON client.clientNo = bookSale.clientNo;
    
-- 테이블 별명 추가 FROM 절과 JOIN 절에서 가장 많이 사용
SELECT DISTINCT c.clientNo, c.clientName, c.clientAddress
FROM client C
    INNER JOIN bookSale B
    ON c.clientNo = b.clientNo;
    
-- JOIN으로만 명시 가능    
SELECT DISTINCT c.clientNo, c.clientName, c.clientAddress
FROM client C
    JOIN bookSale B
    ON c.clientNo = b.clientNo;
    
-- DISTINCT 대신 UNIQUE 사용 가능
SELECT UNIQUE c.clientNo, c.clientName, c.clientAddress
FROM client C
    INNER JOIN bookSale B
    ON c.clientNo = b.clientNo;    
    
-- BOOKSALE 테이블 - 한 명의 고객은 여러 권의 책을 주문할 수 있다/한 권의 책은 여러 고객에게 주문될 수 있다
-- 고객 - -> 주문 <- - 책
-- 기본키: BSNO
-- 외래키: CLIENTNO, BOOKNO

-- 메시가 주문한 도서의 도서명과 주문수량 고객명을 검색

-- 주문 테이블만으로 위 질의를 진행하려면 고객명과 도서명은 검색 불가능
-- 외래키인 CLIENTNO, BOOKNO
SELECT clientNo, bookNo
FROM bookSale
WHERE clientNo = '1';

-- 3개 테이블에 대한 JOIN
SELECT clientName, bookName
FROM bookSale BS
    INNER JOIN client C
    ON C.clientNo = BS.clientNo
    INNER JOIN book B
    ON B.bookNo = BS.bookNo
WHERE C.clientNo = '1';

-- 메시가 주문한 도서의 도서명, 주문수량, 고객명 검색
SELECT C.clientName, B.bookName, BS.bsQty
FROM bookSale BS
    INNER JOIN client C
    ON C.clientNo = BS.clientNo
    INNER JOIN book B
    ON B.bookNo = BS.bookNo
WHERE C.clientName = '메시';

-- 도서를 주문한 고객의 고객명, 주문정보, 도서명 검색하되 주문 번호를 기준으로 오름차순 정렬
SELECT C.clientName, B.bookName, BS.bsNo, BS.bsDate, BS.bsQty
FROM bookSale BS
    INNER JOIN client C
    ON C.clientNo = BS.clientNo
    INNER JOIN book B
    ON B.bookNo = BS.bookNo
ORDER BY BS.bsNo; -- 정렬 기준 컬럼은 SELECT 되지 않아도 됨    

-- 고객별로 총 주문수량 계산하여
-- 고객명과 총 주문수량 검색하고
-- 주문수량 기준 내림차순 정렬 후 반환
-- GROUP BY 된 경우 집계 함수가 아닌 일반 컬럼 GROUP BY 조건이어야함
SELECT C.clientNo, C.clientName, SUM(bsQty) AS "총 주문 수량"
FROM bookSale BS
    INNER JOIN client C
    ON C.clientNo = BS.clientNo
GROUP BY C.clientNo, C.clientName -- 그룹 내에 또 다른 그룹을 구성하라는 조건
ORDER BY "총 주문 수량" DESC;

-- WHERE 절 추가
-- 2019년부터 ~ 현재까지 판매 된 도서의 주문일 고객명, 도서명, 도서가격, 주문수량, 주문액(주문수량 * 도서가격) 계산하여 출력
-- 주문, 고객, 도서
SELECT BS.bsDate AS 주문일, C.clientName AS 고객명, B.bookName AS 도서명, BS.bsQty AS 주문수량, BS.bsQty * B.bookPrice AS 주문액
FROM bookSale BS
    INNER JOIN client C
    ON C.clientNo = BS.clientNo
    INNER JOIN book B
    ON B.bookNo = BS.bookNo
WHERE BS.bsDate >= '2019-01-01'
ORDER BY Bs.bsDate DESC;

------------------------------------------------------------------
/*
    외부 조인(OUTER JOIN)
    공통 속성을 매개로 하는 정보가 없더라도 버리지 않고 표시
    값이 없는 대응 속성은 NULL 값을 채워 반환    
*/

-- 모든 고객은 0번 이상 주문할 수 있다
-- 한번도 주문하지 않은 고객도 존재함
-- INNER JOIN이 주문한 고객정보만 결합 - 주문하지 않은 고객은 반영하지 않음
-- 주문하지 않은 고객 정보까지 표현 : OUTER JOIN
-- 주문하지 않은 고객: 고객 정보는 저장된 정보표현, 주문정보는 NULL로 표현

-- 주문하지 않은 고객 정보가 Client 테이블에 표현될 수 있음
SELECT *
FROM client C
    LEFT OUTER JOIN bookSale BS
    ON C.clientNo = BS. clientNo
ORDER BY C.clientNo;

-- BOOKSALE에는 주문하지 않은 고객의 번호가 나타나지 않음
-- INNER JOIN과 같은 결과
SELECT *
FROM bookSale BS
    LEFT OUTER JOIN client C
    ON C.clientNo = BS. clientNo
ORDER BY C.clientNo;

-- LEFT OUTER JOIN
SELECT *
FROM client C
    LEFT OUTER JOIN bookSale BS
    ON C.clientNo = BS. clientNo
ORDER BY C.clientNo;

-- RIGHT OUTER JOIN : 기준 테이블 BOOKSALE
-- 주문은 했지만 고객 정보에 없는 주문을 포함한 결과 출력 : 고객 결과가 없는 주문은 잘못된 주문(삭제해야할 내용)
-- 비회원에 대한 의미는 아님
SELECT *
FROM client C
    RIGHT OUTER JOIN bookSale BS
    ON C.clientNo = BS. clientNo
ORDER BY C.clientNo;

-- INNER JOIN 방법
SELECT *
FROM client C, bookSale BS --JOIN할 테이블 나열
WHERE c.clientNo = BS.clientNo; -- JOIN 조건 일반조건은 AND 연결 후 표현

-- OUTER JOIN 방법 - 조건절에서 (+) 기호로 표현
-- 확장되어야할 테이블에 (+) 기호를 표현
-- CLIENT 테이블 데이터는 모두 표현해야 하고 BOOKSALE에는 없는 경우 확장하여 NULL값 표현

SELECT *
FROM client C, bookSale BS
WHERE C.clientNo = BS.clientNo (+);

SELECT *
FROM client C, bookSale BS
WHERE C.clientNo (+) = BS.clientNo;