/*
    * DDL (DATA DEFINITION LANGUAGE) : 데이터 정의 언어
    오라클에서 제공하는 객체(OBJECT)를 새로이 만들고(CREATE), 구조를 변경하고(ALTER), 삭제하는(DROP) 명령문
    즉, 구조 자체를 정의하는 언어로 DB 관리자, 설계자가 사용
    
    오라클에서 객체(DB를 이루는 구조들)
    테이블, 사용자(USER), 함수(FUNCTION), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX), 등등...
*/

/*
    <CREATE TABLE>
    테이블 : 행(ROW), 열(COLUMN)로 구성되는 가장 기본적인 데이터 베이스 객체 종류 중 하나
            모든 데이터는 테이블을 통해서 저장됨(데이터를 조작하고자 하려면 무조건 테이블을 만들어야 함)
            
    [표현법]
    CREATE TABLE 테이블 (
    칼럼명 자료형,
    칼럼명 자료형,
    칼럼명 자료형,
    칼럼명 자료형,
    ...
    )
    
    <자료형 종류>
    - 문자(CHAR(크기) / VARCHAR2(크기)) : 크기는 BYTE 수
                                        (숫자, 영문자, 특수문자 => 1글자당 1BYTE)
    - CHAR(바이트수) : 최대 2000BYTE까지 지정 가능
                      고정길이(아무리 적은 값이 들어와도 빈 공간은 공백으로 채우면서 처음 할당한 크기를 유지함)
                      주로 들어올 값의 글자 수가 정해져 있을 경우 사용
                      예) 성별 : 남/여, M/F
                          주민번호 : 6-7 -> 14BYTE
    - VARCHAR2(바이트수) : 최대길이 4000BYTE까지 가능
                          가변 길이(적은 값이 들어온 경우 그 담긴 값에 맞춰 크기가 줄어든다)
                          VAR는 가변 2는 2배를 의미함
                          주로 들어올 값의 글자 수가 정해져 있지 않은 경우 사용
                          매개 변수에 CHAR가 들어온 경우 BYTE 단위로 데이터 체크하지 않고 문자의 개수로 체크
                          VARCHAR2(CHAR 10)
    - NVARCHAR : 문자열의 바이트가 아닌 문자 개수 자체를 길이로 취급하여 유니코드를 지원하기 위한 자료형
    - 숫자(NUMBER) : 정수/실수 상관없이 NUMBER
    - 날짜(DATE) : 년/월/일/시/분/초 형식으로 지정
*/

-- 회원들의 정보를 담을 테이블 (MEMBER) -> (아이디, 비밀번호, 이름, 생년월일)
CREATE TABLE MEMBER ( -- 동일한 테이블명 중복 불가
    MEMBER_ID VARCHAR2(20), -- 대소문자 구분하지 않음. 따라서 낙타봉 표기법 의미없다. => 언더바로 구분
    MEMBER_PWD VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20),
    MEMBER_DATE DATE
);

SELECT * 
FROM MEMBER;

-- 테이블 확인 방법 : 데이터 딕셔너리 이용
-- 데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는 시스템 테이블
SELECT *
FROM USER_TABLES;
-- USER_TABLES : 현재 이 사용자 계정이 가지고 있는 테이블들의 전반적인 구조를 확인할 수 있는 데이터 딕셔너리

-- 칼럼들 확인법
SELECT *
FROM USER_TAB_COLUMNS;
-- USER_TAB_COLUMNS : 현재 이 사용자 계정이 가지고 있는 테이블들의 모든 칼럼의 정보를 조회할 수 있는 데이터 딕셔너리

/*
    칼럼에 주석 달기 (칼럼에 대한 설명)
    
    COMMENT ON COLUMN 테이블명.칼럼명 IS '주석 내용';
*/

COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS '회원 생년월일';

-- INSERT 문 (데이터를 테이블에 추가할 수 있는 구문) => DML 문
-- 한행으로 추가(행 기준으로 데이터 추가함), 추가할 값을 기술(값의 순서 중요★)
-- INSERT INTO 테이블명 VALUES (첫 번째 칼럼 값, 두번재 칼럼 값)

INSERT INTO MEMBER VALUES('user01' , 'pass01', '박가영', '1995-10-25');
--INSERT INTO MEMBER VALUES(null, null, null, null); -- 아이디, 비번, 이름에 null 값이 존재해도 될까요?

-- 위의 null 값이나 중복된 아이디 값은 유요하지 않은 값 들이다
-- 유요한 데이터값을 유지하기 위해서 제약조건을 추가해야 한다.
-- 무결성 보장을 위해선 제약조건을 추가해야 함

/*
    <제약 조건 CONSTRAINTS>
    
    - 원하는 데이터 값만 유지하기 위해서 특정 칼럼마다 설정하는 제약
    - 제약 조건이 부여된 칼럼에 들어올 데이터에 문제가 있는지 없는지 자동으로 검사할 목적
    
    - 종류 : NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY
    - 칼럼에 제약 조건을 부여하는 방식 : 칼럼 레벨, 테이블 레벨
*/

/*
    1. NOT NULL 제약 조건
    해당 칼럼에 반드시 값이 존재해야만 할 경우 사용
    => 즉, NULL 값이 절대 들어와서는 안되는 칼럼에 부여하는 제약 조건
       삽입/수정 시 NULL 값을 허용하지 않도록 하는 제한하는 제약 조건
       
       주의사항 : 칼럼 레벨 방식밖에 안됨
*/

-- NOT NULL 제약 조건을 가진 테이블 설정
-- 칼럼 레벨 방식 : 칼럼명 자료형 제약 조건 -> 제약 조건을 부여하고자 하는 칼럼 뒤에 곧바로 기술
CREATE TABLE MEMBER_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);

INSERT INTO MEM_NOTNULL VALUES(2, 'user01', 'pass01', null, null, null, null);
--> NOT NULL 제약 조건에 위배되어 오류가 발생함
--> NOT NULL 제약 조건 추가하지 않은 칼럼에 대해서는 NULL 값을 추가해도 무방함

/*
    2. UNIQUE 제약 조건
    칼럼에 중복 값을 제한하는 제약 조건
    삽입/수정 시 기존에 해당 칼럼 값에 중복된 값이 있을 경우 추가 또는 수정이 되지 않게 제약
    
    칼럼 레벨 방식/테이블 레벨 방식 둘 다 가능
*/

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- 제약 조건 부여 방식 : 칼럼 레벨
    MUM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL
);

DROP TABLE MEM_UNIQUE;

-- 테이블 레벨 방식 :  모든 칼럼을 다 기술하고 그 이후에 제약 조건을 나열
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MUM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    UNIQUE(MEM_ID) -- 테이블 레벨 방식
);

INSERT INTO MEM_UNIQUE VALUES (1, 'user01', 'pass01', '박가영');
INSERT INTO MEM_UNIQUE VALUES (1, 'user02', 'pass02', '박가영2');
INSERT INTO MEM_UNIQUE VALUES (1, 'user01', 'pass03', '박가영3');
-- UNIQUE 제약 조건에 위배됨
-- 제약 조건 부여 시 직접 제약 조건의 이름을 지정해주지 않으면 시스템에서 알아서 임의의 제약 조건명을 부여함
-- SYS_C~~~(고유한, 중복되지 않은 이름으로 지정)
/*
    제약 조건 부여 시 제약 조건명도 지정하는 방법
    > 칼럼 레벨 방식
    CREATE TABLE 테이블명 (
        칼럼명 자료형 제약 조건1 제약 조건2,
        칼럼명 자료형 CONSTRAINT 제약 조건명
    );
    > 테이블 레벨 방식
    CREATE TABLE 테이블명 (
        칼럼명 자료형,
        칼럼명 자료형,
        ...
        CONSTRAINT 제약 조건명 제약 조건(칼럼명)
    );
*/
DROP TABLE MEM_UNIQUE;

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MUM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEM_NAME_NN NOT NULL,
    CONSTRAINT MEM_ID_UQ UNIQUE(MEM_ID) -- 테이블 레벨 방식
);
INSERT INTO MEM_UNIQUE VALUES (1, 'user01', 'pass01', '박가영');
INSERT INTO MEM_UNIQUE VALUES (2, 'user02', 'pass02', '박가영2');
INSERT INTO MEM_UNIQUE VALUES (3, 'user01', 'pass03', '박가영3');

/*
    3. PRIMARY KEY(기본키) 제약 조건
    테이블에서 각 행들의 정보를 유일하게 식별할 수 있는 칼럼에 부여하는 제약 조건
    => 각 행들을 구분할 수 있는 식별자의 역할
       EX) 사번, 부서 아이디, 직급 코드, 회원 번호, ...
    => 식별자의 조건 : 중복X, 값이 없어도 안됨(NOT NULL + UNIQUE)
    
    주의사항 : 한 테이블당 한개의 칼럼 값만 지정 가능
*/

CREATE TABLE MEM_PRIMARYKEY1(
    MEM_NO NUMBER CONSTRAINT MEM_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);

/*
    4. CHECK 제약 조건
    칼럼에 기록될 수 있는 값에 대한 조건을 설정할 수 있음
    예) 성별 'F', 'M' 값만 들어오게 하고 싶다.
    [표현법]
    CHECK(조건식)
*/

CREATE TABLE MEM_CHECK (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(1) CHECK (GENDER IN('F', 'M')) NOT NULL,
    PHONE VARCHAR2(15),
    EMIAL VARCHAR2(30),
    MEM_DATE DATE NOT NULL
);

-- 회원 가입
INSERT INTO MEM_CHECK
VALUES(1, 'user01', 'pass01', '박가영', 'Z', '010-0000-1111', null, SYSDATE);
-- CHECK 제약 조건 위배

INSERT INTO MEM_CHECK
VALUES(3, 'user03', 'pass01', '박가영3', NULL, '010-0000-1111', null, SYSDATE);
-- CHECK 제약 조건에 NULL 값도 추가 가능함
-- NULL 값을 추가적으로 못 들어오게 하고 싶다면 NOT NULL 제약 조건을 걸어줘야 한다.

/*
    DEFAULT 설정
    특정 칼럼에 들어올 값에 대한 기본 설정(제약 조건은 아님)
    
    예) 회원 가입일 칼럼에 회원 정보가 삽입된 순간의 시간을 기록하고 싶다
        => DEFAULT 값으로 SYSDATE를 설정해 주면 됨
*/
DROP TABLE MEM_CHECK;

CREATE TABLE MEM_CHECK (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(1) CHECK (GENDER IN('F', 'M')) NOT NULL,
    PHONE VARCHAR2(15),
    EMIAL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL -- DEFAULT 설정을 먼저 하고 나서 제약 조건을 추가해야 함
);

INSERT INTO MEM_CHECK
VALUES(1, 'user01', 'pass01', '박가영', 'F', NULL, NULL);

/*
    INSERT INTO MEM_CHECK
    VALUES(값들 나열); -- 모든 칼럼의 값을 직접 제시해 줘야 함
    
    INSERT INTO MEM_CHECK(추가할 칼럼명들 나열)
    VALUES(추가할 칼럼에 맞춰서 값들 나열);
*/

INSERT INTO MEM_CHECK(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(1, 'user01', 'pass01', '박가영', 'F');

/*
    5. FOREIGN KEY(외래키)
    해당 칼럼에 다른 테이블에 존재하는 값만 들어와야 하는 칼럼에 부여하는 제약 조건
    칼럼에 부여하는 제약 조건
    => 다른 테이블을 참조한다 라고 표현
       즉, 참조된 다른 테이블이 제공하고 있는 값만 해당 칼럼에 들어갈 수 있다.
       EX) KH 계정에서
           EMPLOYEE 테이블의 DEPT_CODE와 DEPARTMENT 테이블의 DEPT_ID 값
           => DPT_CODE에는 DEPATRMENT 테이블의 DEPT_ID에 존재하는 값만 들어올 수 있다(NULL 값도 가능)
       
    => FOREIGN KEY 제약 조건으로 다른 테이블과 관계를 형성할 수 있다(JOIN)
    [표현법]
    > 칼럼 레벨 방식
    칼럼명 자료형 CONSTRAINT 제약 조건명 REFERENCES 참조할 테이블명(참조할 칼럼명)
       
    > 테이블 레벨 방식
    CONSTRAINT 제약 조건명 FOREIGN KEY(칼럼명) REFERENCES 참조할 테이블명(참조할 칼럼명)
       
    참조할 테이블 == 부모 테이블
    생략 가능한 것 : CONSTRAINT 제약 조건명, 참조할 칼럼명
    => 생략 시 자동으로 참조할 테이블의 PRIMARY KEY에 해당되는 칼럼이 참조할 칼럼으로 사용됨
    주의 사항 : 참조할 칼럼의 타입과 외래키로 지정할 칼럼 타입이 같아야 함.
*/

-- 부모 테이블 추가
-- 회원의 등급을 보관하는 테이블
CREATE TABLE MEM_GRADE(
    GRADE_CODE CHAR(2) PRIMARY KEY, -- 등급 코드/문자열('G1', 'G2', 'G3', ...) + 제약 조건
    GRADE_NAME VARCHAR2(20) NOT NULL -- 등급 명/문자열('일반회원', '우수회원', '운영자', ...) + 제약 조건
);

INSERT INTO MEM_GRADE
VALUES('G1', '일반회원');

INSERT INTO MEM_GRADE
VALUES('G2', '우수회원');

INSERT INTO MEM_GRADE
VALUES('G3', '운영자');

-- 자식 테이블
-- 회원 정보를 보관하는 테이블
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2) REFERENCES MEM_GRADE(GRADE_CODE), -- 칼럼 레벨 방식 외래키 지정
    GENDER CHAR(1) CHECK (GENDER IN('F', 'M')) NOT NULL,
    PHONE VARCHAR2(15),
    EMIAL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL
--  ,FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE)
);

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(1, 'user01', 'pass01', '가영', 'G1', 'M');

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(2, 'user02', 'pass01', '가영', 'G2', 'M');

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(3, 'user03', 'pass01', '가영', 'G3', 'M');

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(4, 'user04', 'pass01', '가영', NULL, 'M');
-- 외래키 제약 조건에는 NULL 값이 들어갈 수 있다.

-- 부모 테이블에서 데이터 값이 삭제 된다면 ?

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G1';
-- 자식 테이블(MEM)에서 GRADE_ID 값이 G1인 녀석이 이미 존재하고 있기 때문에 함부로 삭제할 수 없다.

-- 외래키 제약 조건 부여 시 삭제에 대한 옵션을 추가해 주면 됨
-- => 기본적으로 삭제 제한 옵션이 있음

/*
    자식 테이블 생성 시(== 외래키 제약 조건을 부여했다면)
    부모 테이블의 데이터가 삭제되었을 때 자식 테이블에는 어떻게 처리할지를 옵션으로 정해둘 수 있다.
    
    FOREIGN KEY 삭제 옵션
    - ON DELETE SET NULL : 부모 데이터를 삭제할 때 해당 데이터 값을 사용하는 자식 데이터를 NULL로 바꾸겠다.
    - ON DELETE CASCADE : 부모 데이터를 삭제할 때 해당 데이터 값을 사용하는 자식 데이터를 함께 삭제 하겠다.
    - ON DELETE RESTRICTED : 삭제를 제한함(기본 옵션)
*/ 

DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2), --REFERENCES MEM_GRADE(GRADE_CODE),
    GENDER CHAR(1) CHECK (GENDER IN('F', 'M')) NOT NULL,
    PHONE VARCHAR2(15),
    EMIAL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL,
    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL
);

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(1, 'user01', 'pass01', '가영', 'G1', 'M');

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(2, 'user02', 'pass01', '가영', 'G2', 'M');

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(3, 'user03', 'pass01', '가영', 'G3', 'M');

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(4, 'user04', 'pass01', '가영', NULL, 'M');

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G1';

SELECT *
FROM MEM;

DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2), --REFERENCES MEM_GRADE(GRADE_CODE),
    GENDER CHAR(1) CHECK (GENDER IN('F', 'M')) NOT NULL,
    PHONE VARCHAR2(15),
    EMIAL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL,
    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE CASCADE
);

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(1, 'user01', 'pass01', '가영', 'G1', 'M');

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(2, 'user02', 'pass01', '가영', 'G2', 'M');

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(3, 'user03', 'pass01', '가영', 'G3', 'M');

INSERT INTO MEM(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_ID, GENDER)
VALUES(4, 'user04', 'pass01', '가영', NULL, 'M');

SELECT *
FROM MEM;

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G3';
-- 문제없이 삭제가 됨
-- 자식 테이블에서 GRADE_ID 값이 G3인 행들이 모두 삭제되어버림

-- 조인
-- 전체 회원의 회원 번호, 아이디, 비밀번호, 이름, 등급명 조회
SELECT MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_NAME
FROM MEM
LEFT JOIN MEM_GRADE ON (GRADE_ID = GRADE_CODE);

/*
    굳이 외래키 제약 조건이 걸려있지 않더라고 JOIN이 가능함
    다만, 두 칼럼에 동일한 의미의 데이터가 담겨있어야 함(자료형이 같아야 되고, 담긴 값의 종류, 의미도 비슷해야 함)
*/
----------------------------------------------------------------------------------------------------------
/*
    ------- 접속 계정 KH로 변경하기 -------
    * SUBQUERY를 이용한 테이블 생성(테이블 복사)
    메인 SQL 문을 보조하는 역할의 쿼리문 => 서브쿼리
    
    [표현법]
    CRATE TABLE 테이블명
    AS 서브쿼리;
*/

-- EMPLOYEE 테이블 조회
SELECT *
FROM EMPLOYEE;

-- EMPLOYEE 테이블을 복제한 새로운 테이블 생성(EMPLOYEE_COPY)
CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;
-- 칼럼들, 조회 결과의 데이터 값 제대로 복사됨
-- NOT NULL 제약 조건 제대로 복사됨
-- PRIMARY KEY 제약 조건 제대로 복사가 안됨
-- --> 서브쿼리를 통해 테이블을 생성한 경우 제약 조건은 NOT NULL만 복사됨

SELECT * FROM EMPLOYEE_COPY;

-- EMPLOYEE 테이블에 있는 칼럼의 구조만 복사하고 싶을 때 사용하는 방법
SELECT * FROM EMPLOYEE
WHERE 1 = 0; -- 의도적으로 조건의 결과를 모든 행에 FALSE로 줌

CREATE TABLE EMPLOYEE_COPY2
AS SELECT * FROM EMPLOYEE
    WHERE 1 = 0;

-- 전체 사원들 중 급여가 300만원 이상인 사원들의 사번, 이름, 부서 코드, 급여 칼럼을 복제(내용물 포함)
CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE
    WHERE SALARY >= 3000000;
    
-- 전체 사원의 사번, 사원명, 급여, 연봉을 조회한 결과를 복제한 테이블 생성
CREATE TABLE EMPLOYEE_COPY4
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 FROM EMPLOYEE;
-- must name this expression with a column alias

CREATE TABLE EMPLOYEE_COPY4
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 연봉 FROM EMPLOYEE;
-- 서브쿼리의 select 절에 산술 연산, 함수식이 기술된 경우 반드시 별칭을 부여해야 한다.

SELECT * FROM EMPLOYEE_COPY4;
