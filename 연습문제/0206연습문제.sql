-- 0206 연습문제
/*
학생(student)과 학과(department) 테이블 생성하고 데이터 입력 (각 3개씩)
제약조건
기본키 설정
학생은 학과에 소속
학생 이름과 학과 이름은 NULL 허용하지 않음
학년은 4를 기본값으로, 범위를 1 ~ 4로 설정
논리연산자 : AND,OR
관계연산자 : < > >= <= 등 사용가능

수업 종료 시에 제출
*/


CREATE TABLE department (
    depNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    depName VARCHAR(30) NOT NULL,
    depNumber VARCHAR(30)
);

CREATE TABLE student (
    stdNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    stdName VARCHAR2(30) NOT NULL,
    stdYear NUMBER(8) DEFAULT 4 CHECK(1 <= stdYear AND stdYear <= 4),
    stdAddress VARCHAR2(50),
    stdBirth DATE,
    depNo VARCHAR2(10) NOT NULL,
    CONSTRAINT FK_student_department_depNo FOREIGN KEY(depNo) REFERENCES department(depNo)
);

/*
    1.product 테이블에 숫자 값을 갖는 prdStock과 제조일을 나타내는 prdDate 열 추가
    2.product 테이블의 prdCompany 열 기본 추가해서 NULL을 NOT NULL로 변경
    3.publisher 테이블에 pubPhone, pubAddress 열 추가
    4.publisher 테이블에서 pubPhone 열 삭제
*/

ALTER TABLE product ADD(
    prdStock NUMBER(12),
    prdDate DATE
);

ALTER TABLE product MODIFY prdCompany VARCHAR2(30) NOT NULL;

ALTER TABLE publisher ADD(
    pubPhone VARCHAR2(30),
    pubAddress VARCHAR2(30)
);

ALTER TABLE publisher DROP COLUMN pubPhone;

/*
    INSERT 문을 사용하여 STUDENT 테이블에 다음과 같이 행 삽입하고　
    SELECT 문으로 조회
*/

INSERT INTO student(stdNo,stdName,stdYear,stdAddress,stdBirth,depNo)
    VALUES(
        '2016001','홍길동',4,'','1997-07-01','1'
    );
    
INSERT INTO student
    VALUES(
        '2015002','성춘향',3,'','1996-12-10','3'
    );    
    
INSERT ALL
    INTO student VALUES('2014004','이몽룡',2,'','1996-03-03','2')
    INTO student VALUES('2016002','변학도',4,'','1995-05-07','1')
    INTO student VALUES('2015003','손흥민',3,'','1997-11-11','2')
    SELECT *
    FROM DUAL;    
    
SELECT * FROM student;    
    