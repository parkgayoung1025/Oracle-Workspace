/*
    DDL(ALTER, DROP)
    
    객체들을 새롭게 생성(CREATE), 수정(ALTER), 삭제(DROP)하는 구문
    
    1. ALTER
    객체 구조를 수정하는 구문
    
    <테이블 수정>
    [표현법]
    ALTER TABLE 테이블명 수정할 내용;
    
    - 수정할 내용
    1) 칼럼 추가 / 수정 / 삭제
    2) 제약 조건 추가 / 삭제 -> 수정은 불가(수정하고자 한다면 삭제 후 새롭게 추가)
    3) 테이블명 / 칼럼명 / 제약 조건명 수정
*/

--1) 칼럼추가 / 수정 / 삭제
-- 1-1) 칼럼 추가(ADD) : ADD 추가할 칼럼명 자료형 DEFAULT 기본 값. 단, DEFAULT 기본 값은 생략 가능
SELECT * FROM DEPE_COPY;

-- CNAME 칼럼 추가
ALTER TABLE DEPE_COPY ADD CNAME VARCHAR2(20);
-- 새로운 칼럼이 만들어지고, 기본 값으로 NULL 값이 추가됨

-- DEFAULT 지정해서 LNAME 칼럼 추가 DEFAULT 
ALTER TABLE DEPE_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';
-- 새로운 칼럼이 만들어지고 NULL 값이 아닌 DEFAULT 값으로 채워짐

-- 1-2) 칼럼 수정(MODIFY)
--      칼럼의 자료형 수정 : MODIFY 수정할 칼럼명 바꾸고자 하는 자료형
--      DEFAULT 값 수정 : MODIFY 수정할 칼럼명 DEFAULT 바꾸고자 하는 기본 값

-- DEPE_COPY 테이블로 DEPE_ID 칼럼의 자료형을 CHAR(3)으로 변경
ALTER TABLE DEPE_COPY MODIFY DEPT_ID CHAR(3);

ALTER TABLE DEPE_COPY MODIFY DEPT_ID NUMBER;
-- 현재 변경하고자 하는 칼럼에 이미 문자열로 담겨있는 값을 완전히 다른 타입으로 변경이 불가능함

ALTER TABLE DEPE_COPY MODIFY DEPT_ID CHAR(1);
-- 현재 변경하고자 하는 칼럼에 담겨있는 값보다 "작게"는 변경이 불가능함

-- 한번에 여러개의 칼럼 변경 가능
-- DEPT_TITLE 칼럼의 데이터 타입을 VARCHAR2(40)
-- LOCATION_ID 칼럼의 데이터 타입을 VARCHAR2(2)
-- LNAME 칼럼의 기본 값을 '미국'
ALTER TABLE DEPE_COPY
MODIFY DEPT_TITLE VARCHAR2(40)
MODIFY LOCATION_ID VARCHAR2(2)
MODIFY LNAME DEFAULT '미국';

-- 1-3) 칼럼 삭제(DROP COLUMN) : DROP COLUMN 삭제하고자 하는 칼럼명
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPE_COPY;

SELECT * FROM DEPT_COPY2;

-- DEPT_ID 칼럼 지우기
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;

ROLLBACK;
-- DML문만 롤백 가능 : DDL문은 롤백이 안됨

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
-- 테이블에 최소 1개의 칼럼은 존재해야 함

-- 2) 제약 조건 추가 / 삭제
/*
    2-2) 제약 조건 추가
    
    - PRIMARY KEY : ADD PRIMARY KEY(칼럼명);
    - FOREIGN KEY : ADD FOREIGN KEY(칼럼명) REFERENCES 참조할 테이블[(참조할 칼럼)]
    
    - UNIQUE : ADD UNIQUE(칼럼);
    - CHECK : ADD CHECK(칼럼에 대한 조건);
    - NOT NULL : MODIFY 칼럼명 NOT LULL;
    
    나만의 제약 조건명 부여하고자 할 때 : CONSTRAINT 제약 조건명을 제약 조건 앞에다가 추가
    -> CONSTRAINT 제약 조건명은 생략 가능(임의의 이름이 붙음)
    -> 주의 사항 : 현재 계정 내에 고유한 이름으로 부여해야 함
*/

-- DEPE_COPY 테이블로부터 
-- DEPT_ID 칼럼에 PRIMARY KEY 제약 조건 추가
-- DEPT_TITLE 칼럼에 UNIQUE 제약 조건 추가
-- LNAME 칼럼에 NOT NULL 제약 조건 추가
ALTER TABLE DEPE_COPY
ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;

/*
    2-2) 제약 조건 삭제
    
    PRIMARY KEY, FOREING KEY, UNIQUE, CHECK : DROP CONSTRAINT 제약 조건명
    NOT NULL : MODIFY 칼럼명 NULL;
*/

-- DEPE_COPY 테이블에 DCOPY_PK 제약 조건 지우기
ALTER TABLE DEPE_COPY DROP CONSTRAINT DCOPY_PK;

-- DEPE_COPY 테이블에 DCOPY_UQ, DCOPY_NN 제약 조건 지우기
ALTER TABLE DEPE_COPY
DROP CONSTRAINT DCOPY_UQ
MODIFY LNAME NULL;

-- 3) 칼럼명, 제약 조건명, 테이블명 변경(RENAME)

-- 3-1) 칼럼명 변경 : RENAME COLUMN 기존 칼럼명 TO 바꿀 칼럼명
-- DEPE_COPY 테이블에서 DEPT_TITLE 칼럼을 DEPT_NAME으로 바꾸기
ALTER TABLE DEPE_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 3-2) 제약 조건명 변경 : RENAME CONSTRAINT 기존 제약명 TO 바꿀 제약명
ALTER TABLE DEPE_COPY RENAME CONSTRAINT SYS_C0011221 TO DCOPY_DID_NN;

-- 3-3) 테이블명 변경 : RENAME 기존 테이블명 TO 바꿀 테이블명 -> RENAME TO 바꿀 테이블명
-- 기존 테이블명이 제시되어 있기 때문에 생략 가능
-- DEPE_COPY 테이블 이름을 DEPT_TEST로 변경
ALTER TABLE DEPE_COPY RENAME TO DEPT_TEST;

SELECT * FROM DEPT_TEST;

/*
    2. DROP
    객체를 삭제하는 구문
    [표현법]
    DROP 객체[TABLE, USER, VIEW 등등] 삭제하고자 하는 객체 이름
*/

-- DEPT_COPY2 테이블 삭제
DROP TABLE DEPT_COPY2;

-- 부모 테이블을 만들고 부모 테이블 삭제해보기
ALTER TABLE DEPT_TEST
ADD PRIMARY KEY(DEPT_ID); -- PK 제약 조건 추가

-- EMPLOYEE_COPY3 테이블에 외래키 제약 조건 추가
-- 이때 부모 테이블은 DEPT_TEST 테이블의 DEPT_ID를 참조
ALTER TABLE EMPLOYEE_COPY3
ADD CONSTRAINT ECOPY_FK FOREIGN KEY(DEPT_CODE) REFERENCES DEPT_TEST(DEPT_ID);

-- 부모 테이블 삭제
DROP TABLE DEPT_TEST;
-- 오류 : 자식 테이블에서 참조되고 있어서 삭제할 수 없음

-- 단, 어딘가에서 참조되고 있는 부모 테이블은 삭제되지 않음
-- 부모 테이블 삭제하고 싶다면
-- 방법1) 자식 테이블을 먼저 삭제하고 그 후에 부모 테이블을 삭제
DROP TABLE EMPLOYEE_COPY3;
DROP TABLE DEPT_TEST;

-- 방법2) 부모 테이블만 삭제하되 맞물려있는 외래키 제약 조건도 함께 삭제해 준다.
DROP TABLE DEPT_TEST CASCADE CONSTRAINT;
