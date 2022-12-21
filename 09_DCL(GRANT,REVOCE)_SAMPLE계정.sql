-- 2-1) CREATE TABLE 권한 부여받기 전
CREATE TABLE TEST(
    TEST_ID NUMBER
); -- 권한 불충분 에러 발생

-- 2-2) CREATE TABLE 권한 부여받은 후
CREATE TABLE TEST2(
    TEST_ID NUMBER
);

-- 테이블 생성 권한 부여받은 후 TABLE 스페이스를 할당 받으면 계정이 소유하고 있는 테이블들을 조작하는 것도 가능해짐(DML)
INSERT INTO TEST2 VALUES(1);

-- 4. 뷰 만들어보기
CREATE VIEW V_TEST
AS SELECT * FROM TEST2;

-- 5. 
-- SAMPLE2 계정에서 KH 계정의 테이블에 접근해서 조회해보기
SELECT * FROM KH.EMPLOYEE;

INSERT INTO KH.DEPARTMENT VALUES('D0', '회계부', 'L2');

CREATE TABLE TEST3(
    TEST_ID NUMBER
);