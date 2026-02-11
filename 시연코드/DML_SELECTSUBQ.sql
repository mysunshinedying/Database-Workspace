-- 서브쿼리(SUBQUERY)
/*
    질의 결과를 활용해서 다시 질의를 하는 개념
    하나의 쿼리문 안에 다른 쿼리문이 중첩되는 형태로 나타남
    하위 질의 또는 부속 질의라고도 함
    질의를 1차 수행한 다음에 반환값을 다른 질의에 포함시켜 사용
    여러 개의 테이블에 정보가 분산되어 있는 경우
         다른 테이블에서 가져온 데이터로 현재 테이블에 있는 정보를 찾거나 가공할 때 사용
*/

/*
    조인JOIN VS 부속 질의SUBQUERY
    조인JOIN
    여러 테이블의 데이터를 모두 합쳐서 연산
    카티전곱(15 x 3 = 45 행 반환) 후 조건에 맞는 튜플 검색
    카티전곱 연산 + SELECT 연산
    
    서브 쿼리SUBQUERY
    필요한 데이터만 찾아서 제공
    경우에 따라 조인JOIN보다 성능이 더 좋을 수도 있지만
    대량의 데이터에서 서브 쿼리를 수행할 때 성능이 나쁠 수도 있음
*/

-- 구성
-- MAINQUERY(SUBQUERY)

-- 메시가 주문한 주문 수량의 합 검색
-- 주문테이블에는 고객 이름은 없음

SELECT SUM(BS.bsQty) AS "메시가 주문한 도서의 수"
FROM client C, bookSale BS
WHERE C.clientNo = BS.clientNo AND C.clientName = '메시';

--고객 명은 알지만 고객 번호를 모름, BOOKSALE 테이블에는 고객 번호만 있음
SELECT SUM(BS.bsQty) AS "메시가 주문한 도서의 수"
FROM bookSale BS
WHERE BS.clientNo = ( -- 서브 쿼리에서 반환된 메서의 고객번호가 이 위치로 들어옴 -> 상위 쿼리 WHERE에서 조건검사 진행
                      -- 이름이 메시인 고객이 한 명임
                      SELECT clientNo
                      FROM client
                      WHERE clientName = '메시'
                    );
                    
-- 위 쿼리의 서브 쿼리 결과는 단일행임(단일행 SUBQUERY)   
-- 단일행 서브 쿼리인 경우 비교연산자 사용 가능
-- 고객 호날두의 주문일, 주문 수량 검색
SELECT bsDate, bsQty
FROM bookSale
WHERE clientNo = ( SELECT clientNo
                   FROM client
                    WHERE clientName = '호날두'
                  );

-- 가장 비싼 도서의 도서명과 가격 출력
-- 도서 가격 중 가장 값이 큰 가격을 찾고
-- 해당 가격 도서의 도서 이름 검색

SELECT bookName, bookPrice
FROM book
WHERE bookPrice = ( SELECT MAX(bookPrice)
                    FROM book);
                    
-- 판매중인 도서의 평균 가격 보다 가격이 높은 도서의 도서명과 도서가격 검색
SELECT bookName, bookPrice
FROM book
WHERE bookPrice >= ( SELECT AVG(bookPrice)
                    FROM book);

-- 만약 메시가 동명이인이 있어 두명이면 clientNo가 두개 반환됨(다중행 SUBQUERY)
-- 다중행 서브쿼리는 비교 연산자 단독으로는 사용 불가능
-- IN, ANY, ALL, EXISTS, NOT EXISTS 연산자 사용

-- 한번이라도 주문한적이 있는 고객 정보(고객 번호, 고객 이름)
-- 한번이라도 주문한적이 있는 고객 번호
SELECT clientNo
FROM bookSale;

-- 한번이라도 주문한적이 있는 고객 정보(고객 번호, 고객 이름)
-- client 테이블의 clientNo 각각을 반환된 clientNo와 비교해서 같은 값이 확인되면 해당 레코드를 반환
SELECT clientNo, clientName
FROM client
WHERE clientNo IN (SELECT clientNo
                   FROM bookSale); -- 다중 행 리턴 IN 연산자 연결하면 RETURN 값 중 하나와 매치되는지 모든 행을 확인

-- 한번도 주문한적이 없는 고객 정보(고객번호, 고객 이름)                   
SELECT clientNo, clientName
FROM client
WHERE clientNo NOT IN (SELECT clientNo
                   FROM bookSale);
                   
-- 중첩 서브쿼리 : 서브쿼리 내에 서브쿼리가 포함되는 경우

-- 도서명이 '안드로이드 프로그래밍'인 도서를 구매한 고객의 고객명을 검색
-- '안드로이드 프로그래밍'의 도서번호 추출 : 단일 행으로 추정 -> 다중행일 가능성도 있음
-- 도서를 구매한 고객 : 추출된 도서번호로 구매 테이블에서 고객번호를 추출
-- 추출된 고객번호로 고객 이름을 추출

SELECT clientName
FROM client
WHERE clientNo IN (SELECT clientNo 
                  FROM bookSale
                  WHERE bookNo IN ( SELECT bookNo
                                    FROM book
                                    WHERE bookName = '안드로이드 프로그래밍')                                                          
                  );

SELECT clientNo, clientName
FROM client
WHERE clientNo IN (SELECT clientNo -- 다중 행으로 반환
                  FROM bookSale
                  WHERE bookNo = ( SELECT bookNo -- 현재 DATA에서는 단일행이므로 비교 연산 가능. 단, 데이터가 많아지면 동일한 이름의 책이 있을 수 있음
                                    FROM book
                                    WHERE bookName = '안드로이드 프로그래밍')                                                          
                  );
                  
-- 서브 쿼리 결과 정렬 : ORDER BY 마지막에 표현           
SELECT clientNo, clientName
FROM client
WHERE clientNo IN (SELECT clientNo 
                  FROM bookSale
                  WHERE bookNo IN ( SELECT bookNo
                                    FROM book
                                    WHERE bookName = '안드로이드 프로그래밍') -- WHERE 절 종료                                                         
                  )
ORDER BY clientName;        
-- 서브 쿼리는 독립적 객체 반환이므로 JOIN 연산도 진행 가능 GROUP BY 등 모든 연산 진행가능

------------------------------------------------------------------
-- EXITS : 서브쿼리의 결과가 행을 반환하면 참이되는 연산자
-- 메인쿼리와 서브쿼리의 매칭 조건 검사를 서브쿼리에서 진행

-- WHERE 조건에서 사용 시 조건 기준이 되는 컬럼이 쿼리 WHERE절에 표현되지 않는다.
-- SUBQUERY에서 표현됨

-- 메인 쿼리의 테이블과 SUBQUERY의 테이블의 모든 레코드를 순회
-- IN연산자를 사용하는 것과 유사함
-- IN : 서브쿼리에서 검색한 결과로 메인쿼리에서 다시 조건 검색을 실행
-- EXISTS : 두 테이블을 비교 검사함

-- 도서를 구매한 적 있는 고객
-- BOOKSALE 테이블에서 CLIENTNO 검색 후 반환되는 값을 활용해서 CLIENT 테이블 검색(IN)
-- 1. BOOKSALE에서 조건에 해당되는 행이 존재하면 WHERE가 참이됨
-- 2. 참이 되는 레코드들에서 SELECT를 진행

-- IN을 사용했을 때와 동일한 결과
    SELECT clientNo, clientName
    FROM client
    WHERE EXISTS (SELECT clientNo
                  FROM bookSale
                  WHERE client.clientNo = bookSale.clientNo);
                  -- 메인/서브쿼리의 두 테이블을 접근해서 메인 테이블(client)의 clientNo가 서브테이블(bookSale)의 clientNo에 포함되는지 확인

-- 도서를 구매한 적 없는 고객
-- NOT IN을 사용했을 때 동일한 결과
    SELECT clientNo, clientName
    FROM client
    WHERE NOT EXISTS (SELECT clientNo
                  FROM bookSale
                  WHERE client.clientNo = bookSale.clientNo);
                  
------------------------------------------------------------------
-- IN과 EXISTS의 차이 : 데이터가 NULL인 경우

-- clientHobby에 NULL이 세개 포함
SELECT clientHobby FROM client;

-- EXISTS : 서브쿼리에서 NULL인 레코드도 TRUE로 반환되어서 모든 CLIENTNO이 검색
SELECT clientNo
FROM client
WHERE EXISTS (SELECT clientHobby
              FROM client); -- 조건 절 없으므로 client의 모든 레코드에 true가 반환
              
-- IN : 메인의 WHERE절에서 세부조건 검사를 진행하므로 NULL값은 확인하지 않음
-- 취미가 NULL인 고객번호는 검색되지 않음
SELECT clientNo
FROM client
WHERE clientHobby IN (SELECT clientHobby
                      FROM client);

------------------------------------------------------------------
-- ALL / ANY
-- 관계 연산자 뒤에 위치, EX >= ALL, >=ANY

/*
    ALL
    n검색 조건이 서브 쿼리의 결과의 모든 값에 만족하면 참이 되는 연산자
    조건 > ALL (서브 쿼리 결과)
    ANY, SOME
    검색 조건이 서브 쿼리의 결과 중에서 하나 이상에 만족하면 참이 되는 연산자
    조건 > ANY (서브 쿼리 결과)
*/

-- ALL : 
-- 2번 고객이 주문한 도서의 최고 주문수량보다 더 많이 주문한 고객의 고객번호, 주문번호, 주문수량 검색
-- 1. 2번 고객이 주문한 모든 주문수량을 검색
-- 2. 검색된 모든 값보다 더 큰 주문값보다 더 큰 주문값을 갖는 레코드 검색

SELECT bsQty FROM bookSale WHERE clientNo = '2';

    SELECT clientNo, bsNo, bsQty
    FROM bookSale
    WHERE bsQty > ALL(SELECT bsQty FROM bookSale WHERE clientNo = '2');
    -- 서브쿼리에서 검색된 값의 리스트가 (5,2,2)이므로 메인 쿼리의 레코드는 bsQty가 2보다 크고 5보다도 크면 true
    -- 반환된 서브쿼리 결과값에서 max인 값보다 더 큰 레코드를 선택


-- ANY : 
-- 2번 고객이 주문한 도서의 최고 주문수량보다 더 많이 주문한 고객의 고객번호, 주문번호, 주문수량 검색
-- 1. 2번 고객이 주문한 모든 주문수량을 검색
-- 2. 검색된 모든 값보다 더 큰 주문값보다 더 큰 주문값을 갖는 레코드 검색

SELECT bsQty FROM bookSale WHERE clientNo = '2';

    SELECT clientNo, bsNo, bsQty
    FROM bookSale
    WHERE bsQty > ANY (SELECT bsQty FROM bookSale WHERE clientNo = '2');
    -- 서브쿼리에서 검색된 값의 리스트가 (5,2,2)이므로 메인 쿼리의 레코드는 bsQty가 2보다 크거나 5보다도 크면 true
    -- 반환된 서브쿼리 결과값에서 min인 값보다 더 큰 레코드를 선택
    -- 2번 고객이 주문한 주문번호 3번도 포함(2번 고객 주문과 관련된 내용을 제외하고자하면 2번 고객 제외 쿼리를 넣어야함)
    SELECT clientNo, bsNo, bsQty
    FROM bookSale
    WHERE bsQty > ANY (SELECT bsQty FROM bookSale WHERE clientNo = '2')
        AND clientNo != '2';    

-- 모든 서브쿼리의 조건은 서브쿼리에서 종료 메인 쿼리에는 영향을 미치지 않음