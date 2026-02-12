-- DCL : 데이터 관리 질의어

-- 권한에 따라 사용 가능 여부가 달라짐

-- RESOURCE 권한과 CONNECT 권한이 있는 사용자가 가능한 DCL
-- COMMIT / ROLLBACK

-- 진행중인 질의어(쿼리)의 실행 : 트랜잭션

-- COMMIT
    -- 트랜잭션 처리를 정상적으로 종료시켜 변경된 내용을 데이터베이스에 영구 반영시키는 연산
    -- 처리 결과가 오류여도 취소되지 않음
    
-- ROLLBACK
    -- 트랜잭션 처리가 비정상적으로 종료되어
    -- 데이터베이스의 일관성이 깨졌을 때 트랜잭션이 행한 모든 변경 작업을 취소하고 이전 상태로 되돌리는 연산
    -- 라벨을 사용하지 않으면 되돌리는 시점은 이전 COMMIT된 부분까지 되돌려짐
    -- 데이터베이스의 일관성이 깨졌을 때 : 동시접속
        -- 은행 ATM기와 자동납부 : 한 개의 계좌에 100000의 잔액이 있음
        -- 1. 길동이 본인이 50000을 인출
        -- 2. 길동이 관리비 70000을 자동 납부
        -- 순차적으로 진행되면 관리비 자동 납부는 진행되지 않음(잔액부족)
        -- 동시접속으로 1,2번 작업이 진행된다고 가정하면
            -- 잔액 100000 확인하고 인출진행
            -- 1,2번 모두 진행
            -- 동시에 자원에 접근 불가하도록 구성
            -- 1번 요청에 의해 잔액 -- 인출금 연산 후 처리 완료하는 시간 동안
            -- 2번 요청이 잔액을 확인하면 1번 종료 전에는 잔액이 10만원임
            -- DB 일관성에 문제가 생김 - ROLLBACK을 진행
            
            -- 이런 문제가 생기지 않도록 데드락 활용
            -- 1번 작업이 시작되면 계좌(리소스)를 잠가서 못쓰게 함(1번에 점유권을 줌)
            -- 작업 종료 후 데드락 풀어줌
            -- 2번 작업이 진행 - 잔액부족
            
-- 간단한 COMMIT/ROLLBACK
-- DDL : 바로 반영(COMMIT/ROLLBACK 상관없음)
-- DML : DB 테이블에 변경을 가하는 작업

insert into book values('12345678','booktest', 'test', 33000,'2020-01-01',5,'1');
SELECT *
FROM book
ORDER BY bookNo DESC;

ROLLBACK;
SELECT *
FROM book
ORDER BY bookNo DESC;

insert into book values('12345678','booktest', 'test', 33000,'2020-01-01',5,'1');
SELECT *
FROM book
ORDER BY bookNo DESC;
COMMIT; --커밋 시점

insert into book values('123456789','booktest', 'test', 33000,'2020-01-01',5,'1');
insert into book values('1234567890','booktest', 'test', 33000,'2020-01-01',5,'1');
SELECT *
FROM book
ORDER BY bookNo DESC;

ROLLBACK;  -- 취소된 작업은 위 두 INSERT 구문임
SELECT *
FROM book
ORDER BY bookNo DESC;

DELETE FROM book WHERE bookNo = '12345678';
SELECT *
FROM book
ORDER BY bookNo DESC;

ROLLBACK; 
SELECT *
FROM book
ORDER BY bookNo DESC;

DELETE FROM book WHERE bookNo = '12345678';
COMMIT;
SELECT *
FROM book
ORDER BY bookNo DESC;
ROLLBACK; --어떤 취소도 일어나지 않음

-- COMMIT은 세션종료(접속해제) 되면 자동 커밋 일어남