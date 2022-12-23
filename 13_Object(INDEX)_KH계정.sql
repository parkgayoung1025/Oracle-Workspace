/*
    <INDEX>
    전체적인 DBMS 성능 향상을 위한 설정
    
    책에서 '목차' 같은 존재
    
    만약에 목차가 없다면 내가 원하는 챕터, 페이지가 어디에 있는지 책을 하나하나 훑어 봐야 함
    
    마찬가지로 테이블에서 JOIN 혹은 서브쿼리로 데이터를 조회할 때
    인덱스가 없다면 테이블의 모든 데이터(FULL-SCAN)를 하나하나 뒤져서 내가 원하는 데이터를 가져올 것
    
    따라서 인덱스 설정을 해두면 모든 테이블의 행들을 뒤지지 않고 내가 원하는 조건만 빠르게 가져올 수 있다
    
    인덱스의 특징
    1) 인덱스로 설정한 칼럼의 데이터들을 별도로 "오름차순으로 정렬" 하여 특정 메모리 공간에 물리적 주소와 함께 저장시킨다
*/

-- 현재 계정에 생성된 인덱스들 확인
SELECT * FROM USER_INDEXES; -- PK 설정 시 자동으로 인덱스 생성됨
-- 현재 계정에서 인덱스와 인덱스가 적용 된 칼럼을 확인
SELECT * FROM USER_IND_COLUMNS;

-- 실행 계획 : DBMS 특정 쿼리문을 실행하는데 있어서 실행할 계획
SELECT *
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID-- CARINALITY 10 /25
WHERE EMP_NAME = '선동일';
-- 우리가 인덱스를 생성했다고 해서 그 인덱스를 활용할지 말지는 옵티마이저가 판단을 하게 됨

CREATE INDEX IND_EMPLOYEE ON EMPLOYEE(EMP_NAME);

CREATE INDEX IND_EMPLOYEE_DEPT ON EMPLOYEE(EMP_NAME, DEPT_CODE);

ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;

DROP INDEX IND_EMPLOYEE;
DROP INDEX IND_EMPLOYEE_DEPT;

SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '박나라' AND DEPT_CODE = 'D5';

/*
    인덱스를 효율적으로 쓰기 위한 방법
    데이터의 분포도가 높고 조건절에 자주 호출되며 중복값이 적은 칼럼 => PK 칼럼
    
    1) 조건절에 자주 등장하는 칼럼
    2) 항상 = 로 비교되는 칼럼
    3) 중복되는 데이터가 최소한인 칼럼(== 분포도가 높은)
    4) ORDER BY절에 자주 사용되는 칼럼
    5) JOIN 조건으로 자주 사용되는 칼럼
    
    인덱스의 장점
    
    1) WHERE절에 인덱스의 칼럼을 사용하게 되면 훨씬 빠르게 연산할 수 있음
    2) ORDER BY 연산을 사용할 필요가 없다(이미 정렬되어 있음)
    3) MIN, MAX 등의 집계 함수로 값을 찾을 때 연산 속도가 매우 빠름
    
    인덱스의 단점
    
    1) DML에 취약함
       INSERT, UPDATE, DELETE 등 데이터가 새롭게 추가, 삭제가 되면 인덱스 테이블 안에 있는 값들도 다시 정렬하고
       ROWID(물리적 주소)값도 수정해 줘야 함
    2) INDEX를 이용한 INDEX-SCAN보다 단순한 FULL-SCAN이 더 유리할 때가 있다
       일반적으로 테이블의 전체 데이터 중 10~15%의 데이터를 처리해야 하는 경우에만 인덱스가 효율적임
    3) 인덱스가 많을수록 저장 공간을 잡아먹음
       인덱스를 만들면 만들수록 저장 공간이 부족해지게 되므로 적절한 수준을 유지해야 한다
*/