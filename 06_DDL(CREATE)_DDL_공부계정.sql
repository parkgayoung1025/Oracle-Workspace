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