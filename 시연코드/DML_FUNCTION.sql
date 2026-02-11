-- 오라클 내장 함수 정리
-- 문자열 함수, DATE 함수, 데이터 정리 함수, 수학함수(ROUND)

-- ROUND 함수
/*
    ROUND(값, 자리수)
    자리수 아래서 반올림하여 자리수까지 출력
    양수 값 : 소수점 오른쪽 자릿수
    음수 값 : 소수점 왼쪽 자릿수
*/

-- 고객별 평균 주문액을 검색
SELECT clientNo,
       ROUND(AVG(bsQty * bookPrice)) "평균 주문액", --자릿수 생략(1자리까지 기본 출력 - 기본 설정값)
       ROUND(AVG(bsQty * bookPrice),0) "1자리까지 출력",
       ROUND(AVG(bsQty * bookPrice),-1) "10자리까지 출력",
       ROUND(AVG(bsQty * bookPrice),-2) "100자리까지 출력",
       ROUND(AVG(bsQty * bookPrice),-3) "1000자리까지 출력"
FROM book, bookSale
WHERE book.bookNo = bookSale.bookNo
GROUP BY bookSale.clientNo;

------------------------------------------------------------------

/* 문자함수
    REPLACE() : 문자열을 치환하는 함수
    LENGTH()
    글자의 수를 반환하는 함수
    LENGTHB()
    바이트 수 반환
    SUBSTR()
    지정한 길이만큼의 문자열을 반환하는 함수
*/

-- 서점에서 판매중인 도서 정보를 출력하시오. 단, 안드로이드 관련 제목에 한글 안드로이드인 도서는 영문인 Android로 변환하여 출력

SELECT bookNo, REPLACE(bookName, '안드로이드', 'Android'), bookAuthor, bookPrice
FROM book;

SELECT bookNo, REPLACE(bookName, '안드로이드', 'Android'), bookAuthor, bookPrice
FROM book
WHERE bookName LIKE '%안드로이드%';

-- LENGTH() : 글자의 수를 반환하는 함수
-- LENGTHB() : 바이트 수 반환

-- 서울 출판사에서 출판한 도서의 도서명과 글자수 바이트 수 출판사 명을 출력
SELECT B.bookName, LENGTH(B.bookName), LENGTHB(B.bookName), P.pubName
FROM book B, publisher P
WHERE B.pubNo = P.pubNo;

-- SUBSTR(문자열, 시작 위치, 길이) : 지정한 길이만큼의 문자열을 반환하는 함수
SELECT SUBSTR(bookAuthor,1,1) 성, SUBSTR(bookAuthor,2,2) 이름
FROM book;

-- 문자열 연결 : CONCAT() 함수, || 연결 연산자
SELECT CONCAT('문자열', '연결방법1'), '문자열' || ' ' || '연결방법2'
FROM DUAL;

-- 여러 컬럼을 한 개의 컬럼으로 구성(문자열 결합)
SELECT bookAuthor|| ' : ' || bookName || ' : ' || bookPrice AS 도서정보
FROM book;

-- LOWER() / UPPER() / INITCAP()
SELECT LOWER('Java Programming'), UPPER('Java Programming'), INITCAP('java Programming')
FROM DUAL;

-- INSTR : 문자열에서 지정된 문자열 검색해서 위치 반환, 첫 번째 출현하는 위치를 반환
SELECT INSTR('초등학생, 고등학생, 대학생','학생',1,2) -- 반환 값은 학생글자가 시작되는 위치
FROM DUAL;

-- 문자열 처리할 때 주의할 사항 : 공백을 제대로 처리해야함
-- 문자열 처리 시 앞뒤 공백은 제거 후 사용
-- TRIM() 문자열 공백 처리
SELECT TRIM('      대한민국      ')
FROM DUAL;

-- 공백이 아닌 다른 문자 제거
SELECT TRIM(BOTH '*' FROM '****대한민국****')
FROM DUAL;

SELECT TRIM(LEADING '*' FROM '****대한민국****') -- 앞쪽 제거
FROM DUAL;

SELECT TRIM(TRAILING '*' FROM '****대한민국****') -- 뒤쪽 제거
FROM DUAL;

------------------------------------------------------------------
-- 현재 날짜 출력 : SYSDATE, CURRENT_DATE

SELECT SYSDATE FROM DUAL;
SELECT CURRENT_DATE FROM DUAL; -- 현재 일자

SELECT SYSDATE + 1 FROM DUAL;
SELECT SYSDATE - 1 FROM DUAL;

SELECT SYSDATE - 1 어제, SYSDATE + 1 내일, SYSDATE + 2 모레
FROM DUAL;

SELECT SYSDATE + 7 일주일후 FROM DUAL;

-- 경과 단위를 MONTH로 처리 : ADD_MONTHS(날짜,경과일)
SELECT ADD_MONTHS(SYSDATE,1) -- 1달 후
FROM DUAL;

SELECT ADD_MONTHS(SYSDATE,-1) -- 1달 전
FROM DUAL;

SELECT ADD_MONTHS(SYSDATE,12) -- 1년 후
FROM DUAL;

SELECT ADD_MONTHS(SYSDATE,-12) -- 1년 전
FROM DUAL;

-- 날짜 데이터에서 년,월,일 추출
-- EXTRACT(옵션 날짜)

SELECT EXTRACT(YEAR FROM SYSDATE) 년,EXTRACT(MONTH FROM SYSDATE) 월,EXTRACT(DAY FROM SYSDATE) 일
FROM DUAL;

SELECT EXTRACT(YEAR FROM SYSDATE)-1 작년,EXTRACT(YEAR FROM SYSDATE) 올해,EXTRACT(YEAR FROM SYSDATE)+1 내년
FROM DUAL;

-- 현재 시간 검색
SELECT CURRENT_TIMESTAMP FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'HH:MI:SS') FROM DUAL; --12시간 단위

SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL; --24시간 단위

SELECT TO_CHAR(SYSDATE, 'HH24') 시, TO_CHAR(SYSDATE,'MI') 분, TO_CHAR(SYSDATE,'SS') 초
FROM DUAL;

-- 현재 날짜 검색
SELECT TO_CHAR(SYSDATE, 'YYYY') 년
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'MM') 월
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'DD') 일
FROM DUAL;

------------------------------------------------------------------
-- 데이터 정리 함수

-- 순위 검색 함수

-- RANK() / DENSE RANK() / ROW_NUMBER()

-- RANK() : 값의 순위 반환(동일 값이 있으면 다음 순위는 동일값 만큼의 수가 증가)
-- DENSE RANK() : 값의 순위 반환(동일 값이 있어도 다음 순위는 1 증가)
-- ROW_NUMBER() : 행번호(위치한 행의 번호)

SELECT bookPrice,
    RANK() OVER (ORDER BY bookPrice DESC) "RANK",
    DENSE_RANK() OVER (ORDER BY bookPrice DESC) "DENSE_RANK",
    ROW_NUMBER() OVER (ORDER BY bookPrice DESC) "ROW_NUMBER"
FROM book;

-- TOP N 출력 : ROWNUM 컬럼 사용
-- 위에 표현되어지는 레코드
SELECT ROWNUM, bookPrice
FROM BOOK
WHERE ROWNUM BETWEEN 1 AND 5;

------------------------------------------------------------------
-- 데이터의 특정 컬럼값을 기준으로 그룹을 구성하고 그룹에 대한 요약을 반환하는 함수
-- ROLLUP() / CUBE() / GROUPINT SETS()

/*
    ROLLUP()
    그룹의 소계와 총계 산출
    순서가 중요. 맨 앞에 놓인 것에 대해서 소계 산출

    CUBE()
    각 그룹의 모든 경우의 수에 대한 소계와 총계 산출
    항목들간 다차원적인 소계를 계산

    GROUPING SETS()
    특정 항목에 대한 소계 산출
*/

CREATE TABLE CUBETBL(
    PRDNAME VARCHAR2(10),
    COLOR VARCHAR2(6),
    AMOUNT NUMBER(2)
    );

INSERT INTO CUBETBL VALUES('컴퓨터','검정',11);
INSERT INTO CUBETBL VALUES('컴퓨터','파랑',22);
INSERT INTO CUBETBL VALUES('모니터','검정',33);
INSERT INTO CUBETBL VALUES('모니터','파랑',44);
INSERT INTO CUBETBL VALUES('마우스','검정',55);
INSERT INTO CUBETBL VALUES('마우스','파랑',66);

SELECT * FROM CUBETBL;

SELECT prdName, color, SUM(amount) AS "금액합계"
FROM cubeTBL
GROUP BY CUBE(color, prdName) -- CUBE()의 인수 컬럼의 순서는 상관없음
ORDER BY prdName, color;

/*
    CUBE()
    각 그룹의 모든 경우의 수에 대한 소계와 총계 산출
    항목들간 다차원적인 소계를 계산
*/

SELECT prdName, color, SUM(amount) AS "금액합계"
FROM cubeTBL
GROUP BY CUBE(prdName, color)
ORDER BY prdName, color;


------------------------------------------------------------------
-- ROLLUP() 먼저 표현되는 기준 컬럼에 대한 소계와 총계를 포함시켜줌

SELECT prdName, color, SUM(amount) AS "금액합계"
FROM cubeTBL
GROUP BY ROLLUP(prdName, color) -- 기준 컬럼 : prdName
ORDER BY prdName, color;

SELECT prdName, color, SUM(amount) AS "금액합계"
FROM cubeTBL
GROUP BY ROLLUP(color, prdName) -- 기준 컬럼 : color
ORDER BY prdName, color;

-- GROUPING SETS() : 항목별 소계만 출력

SELECT prdName, color, SUM(amount) AS "금액합계"
FROM cubeTBL
GROUP BY GROUPING SETS(color, prdName);
-- 총계 없음, GROUPING SETS(color, prdName) 컬럼에 나타나는 데이터 항목별 소계만 반환

------------------------------------------------------------------
-- PIVOT() : ROW 단위를 COLUMN 단위로 변경
-- 특정 열의 값을 기준으로 데이터를 재배치하고자 할 때 사용

create table pivotTest(
    singer varchar2(10),
    season varchar2(10),
    amount number(3)
);
insert into pivotTest values('김범수','겨울',10);
insert into pivotTest values('윤종신','여름',15);
insert into pivotTest values('김범수','가을',25);
insert into pivotTest values('김범수','봄',3);
insert into pivotTest values('김범수','봄',37);
insert into pivotTest values('윤종신','가을',40);
insert into pivotTest values('김범수','여름',14);
insert into pivotTest values('김범수','겨울',22);
insert into pivotTest values('윤종신','여름',64);

SELECT * FROM pivotTest;
-- 시즌 별 음반 판매량
SELECT * FROM pivotTest
    PIVOT (SUM(amount)
          FOR season
          IN('봄', '여름', '가을', '겨울'));