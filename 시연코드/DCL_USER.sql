-- 일반 사용자 소유 객체에 대한 권한

-- 1. 일반 사용자 NEWUSER2가 C##SQL_USER 소유의 테이블에 접근하기 위해 아래 쿼리를 실행
SELECT * FROM book; --테이블명만 쓰면 현재 접속 사용자의 소유라는 의미임
SELECT * FROM C##SQL_USER.book; -- book 테이블의 소유주를 표현해서 어디서 찾아올 것인지 명시
-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다 오류 : 생성했는데 테이블 명 오타가 있을 경우, 접근 권한이 없는 경우
-- NEWUSER2가 book 테이블을 사용하려면 소유주에게 접근 권한을 받아야함

-- 2. book 테이블 소유자인 C##SQL_USER가 book 테이블에 대한 권한을 NEWUSER2에게 줘야함
-- system은 book테이블의 소유주가 아니므로 접근 권한을 줄 수 없음
-- 계정 C##SQL_USER 접속
-- 테이블에 대한 권한 : INSERT / UPDATE / DELETE / SELECT(조회) ALTER/DROP
GRANT SELECT ON book TO newUser2;

-- 3. NEWUSER2 계정에서 사용
SELECT * FROM C##SQL_USER.book;

UPDATE C##SQL_USER.book SET pubNo = '2' WHERE bookNo = '1001'; -- 권한이 불충분합니다.

-- 4. BOOK 테이블 소유주가 UPDATE 권한 부여
-- 계정 C##SQL_USER 접속 변경
GRANT UPDATE ON book TO newUser2;

-- 5. NEWUSER2 계정에서 UPDATE 진행
SELECT * FROM C##SQL_USER.book;
UPDATE C##SQL_USER.book SET pubNo = '2' WHERE bookNo = '1001';
SELECT * FROM C##SQL_USER.book;

-- 모든 객체의 권한은 소유주가 설정한다
-- 6. NEWUSER2 계정에 부여했던 권한 회수(소유주가 진행)
-- C##SQL_USER 접속에서 진행
REVOKE SELECT ON book FROM newUser2; -- 권한의 회수는 즉시 적용됨