/*
    <JOIN>
    
    두 개 이상의 테이블에서 데이터를 같이 조회하고자 할 때 사용되는 구문 => SELECT 문 이용
    조회 결과는 하나의 결과물(RESULT SET)으로 나옴
    
    JOIN을 해야 하는 이유 ? 
    관계형 데이터 베이스에서는 최소한의 데이터로 각각의 테이블에 데이터를 보관하고 있음
    사원 정보는 사원 테이블, 직급 정보는 직급 테이블, ... => 중복을 최소화하기 위함
    => 즉, JOIN 구문을 이용해서 여러 개 테이블 간의 관계를 맺어서 같이 조회해야 함
    => 단, 무작정 JOIN을 하는 것이 아니라 테이블 간에 "연결고리(포린키)"에 해당하는 칼럼을 매칭 시켜서 조회해야 함
    
    문법상 분류 : JOIN은 크게 오라클 전용 구문과 ANSI 구문으로 나누어짐
    
    오라클 전용 구문           |     ANSI 구문(오라클 + 다른 DBMS에서 사용 가능)
    ===========================================================================
    등가 조인(EQUAL JOIN)     |     내부 조인(INNER JOIN) -> JOIN USING/ON
    ---------------------------------------------------------------------------
    포괄 조인                       외부 조인(OUTER JOIN) -> JOIN USING
    (LEFT OUTER JOIN)              왼쪽 외부 조인(LEFT OUTER JOIN)
    (RIGHT OUTER JOIN)             오른쪽 외부 조인(RIGHT OUTER JOIN)
                                   전체 외부 조인(FULL OUTER JOIN) : 오라클에서 사용
    ---------------------------------------------------------------------------
    카테시안곱                       교차 조인(CROSS JOIN)
    ---------------------------------------------------------------------------
    자체 조인(SELF JOIN)
    비등가 조인(NON EQUAL JOIN)
*/

-- JOIN 사용하지 않는 예
-- 전체 사원들의 사번, 사원명, 부서 코드, 부서명까지 알아내고자 한다면 ? 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

SELECT *
FROM DEPARTMENT;

SELECT *
FROM JOB;

--> 조인을 통해서 연결 고리에 해당되는 칼럼들만 제대로 매칭 시키면 마치 하나의 결과물로 조회 가능하다.
/*
    1. 등가 조인(EQUAL JOIN) / 내부 조인(INNER JOIN)
    연결시키고자 하는 칼럼 값들이 "일치하는 행들"만 조인해서 조회
    (== 일치하지 않는 값들은 결과에서 제외)
    => 동등 비교 연산자 = 일치한다는 조건을 제시
    [표현법]
    등가 조인(오라클 구문)
    SELECT 조회하고자 하는 칼럼명들
    FROM 조인하고자 하는 테이블명들
    WHERE 연결할 칼럼에 대한 조건을 제시(=)
    
    내부 조인(ANSI) : ON 구문
    SELECT 조회할 칼럼명들 나열
    FROM 기준으로 삼을 테이블 1개만 제시
    JOIN 조인할 테이블 1개 제시 ON(연결할 칼럼에 대한 조건을 제시(=))
    
    내부 조인(ANSI) : USINT => 연결할 칼럼명이 동일할 경우에만 씀
    SELECT 조회하고자 하는 칼럼명들
    FROM 기준으로 삼을 테이블명 1개만 제시
    JOIN 조인할 테이블명 1개만 제시 USING(연결할 칼럼명 1개만 제시)
    
    + 만약에 연결할 칼럼명이 동일하다면 USING 구문을 사용하고
                         일치하지 않다면, 명시적으로 어느 테이블로부터 온 칼럼인지 작성해 줘야 한다.
*/

-- 오라클 전용 구문
-- FROM 절에 내가 조회하고자 하는 테이블명들 나열 ,로 찍어서
-- WHERE 절에 매칭 시킬 칼럼명에 대한 조건을 제시

-- 사번, 사원명, 부서 코드, 부서명(DEPARTMENT)을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID; -- EMPLOYEE 테이블의 DEPT_CODE 값과 DEPARTMENT 테이블의 DEPT_ID 값이 일치하는 경우에만 조회
--> 일치하지 않는 값은 조회되지 않는다(부서 코드가 NULL인 사원)
--> 두 개 이상의 테이블을 조인할 때 일치하는 값이 없는 행은 결과에서 제외

-- 전체 사원들의 사번, 사원명, 직급 코드, 직급명을 알아내고자 한다면 ? 
-- 연결할 칼럼명이 일치(EMPLOYEE - JOB_CODE / JOB - JOB_CODE)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE; -- 에러 발생 : column ambiguously defined : 칼럼명이 애매모호 하다
                                      -- -> 확실히 어디 테이블의 칼럼인지를 제시 해줘야 함

-- 방법 1) 테이블명을 이용하는 방법 => 테이블명.칼럼명
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 방법 2) 테이블에 별칭을 붙여서 사용하는 방법(각 테이블마다 별칭 부여 가능) => 별칭.칼럼명
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

--> ANSI 구문
-- FROM 절에 기준 테이블을 "하나만" 기술함
-- 그 뒤에 JOIN 절에서 같이 조회하고자 하는 테이블 기술. 또한, 매칭 시킬 칼럼에 대한 조건도 같이 기술
-- USING / ON 구문

-- 전체 사원들의 사번, 사원명, 부서 코드, 부서명을 알아내고자 할 때
-- 1) 연결할 칼럼명이 다른 경우(EMPLOYEE - DEPT_CODE / DEPARTMENT - DEPT_ID)
--    => 무조건 ON 구문만 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
/*INNER*/JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID; -- INNER 생략 가능

-- 전체 사원들의 사번, 사원명, 직급 코드, 직급명을 알아내고자 할 때
-- 2) 연결할 칼럼명이 동일한 경우(EMPLOYEE - JOB_CODE / JOB - JOB_CODE)
--    => ON, USING 구문 둘 다 사용 가능
-- 2-1) ON 구문 : ambiguously가 발생할 수 있기 때문에 칼럼명을 명확하게 기술해 줘야 함.
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 2-2) USING 구문 : 칼럼명이 동일한 경우에만 사용 가능
--                  동일한 칼럼명 하나만 써주면 알아서 매칭 시켜줌
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);

-- [참고] 자연 조인(NATURAL JOIN) : 등가 조인 방법 중 하나
--       => 동일한 타입과 이름을 가진 칼럼을 조인 조건으로 이용하는 방법
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;
-- 운 좋게도 두 개의 테이블에 일치하는 칼럼명이 "딱 한 개"만 존재(JOB_CODE) ->  자연조건으로 사용 시 알아서 JOB_CODE가 매칭됨

-- 조인 시 추가적인 조건 제시 방법
-- 직급이 대리인 사원들의 정보를 조회(사번, 사원명, 월급, 직급(직급 코드가 아닌 직급명))

--> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND JOB_NAME = '대리';

--> ANSI 구문
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM EMPLOYEE E 
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE JOB_NAME = '대리';

------------------ 실습문제 ------------------
-- 1. 부서가 '인사관리부'인 사원들의 사번, 사원명, 보너스를 조회
-- 오라클 전용 구문 
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE = DEPT_ID 
  AND DEPT_TITLE = '인사관리부'; 

-- ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';

-- 2. 부서가 '총무부'가 아닌 사원들의 사원명, 급여, 입사일 조회
-- 오라클 전용 구문 
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID 
  AND DEPT_TITLE <> '총무부';

-- ANSI 구문
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE <> '총무부';

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
-- 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID 
  AND BONUS IS NOT NULL;

--ANSI 구문 
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE BONUS IS NOT NULL;

-- 4. 아래의 두 테이블을 참고해서 부서 코드, 부서명, 지역 코드, 지역명 조회
-- 오라클 전용 구문
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

--ANSI 구문
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
--------------------------------------------------------------------
-- "전체" 사원들의 사원명, 급여, 부서명
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- DEPT_CODE가 NULL인 사원 두명은 조회되지 않음. 즉, "모든" 사원들의 정보가 출력 되는 게 아님

/*
    2. 포괄 조인, 외부 조인(OUTER JOIN)
    테이블 간의 JOIN 시에 "일치하지 않는 행"도 포함 시켜서 조회 가능
    단, 반드시 LEFT / RIGHT를 지정해야 함 -> 기준이 되는 테이블을 지정해야 한다.
    
    일치하는 행 + 기준이 되는 테이블을 기준으로 일치하지 않는 행도 포함시켜서 조회
*/

-- "전체" 사원들의 사원명, 급여, 부서명
-- 1) LEFT OUTER JOIN : 두 테이블 중 왼쪽에 있는 테이블을 기준 테이블로 삼음
--                      즉, 뭐가 되었든 왼편에 기술된 테이블의 데이터는 무조건 조회 되게끔 한다.
--                      (조인하는 테이블과 일치하는 값이 없더라도)
--> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
LEFT /*OUTER*/ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- EMPLOYEE 테이블을 기준으로 조회했기 때문에 EMPLOYEE에 존재하는 데이터는 뭐가 되었든 다 조회 가능하게끔 해줌

--> 오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);
--> 내가 기준으로 삼을 테이블의 반대 칼럼명에 (+)를 붙여준다.

-- 2) RIGHT OUTER JOIN : 두 테이블 중 오른 편에 기술된 테이블을 기준으로 JOIN
--                       즉, 뭐가 되었든 간에 오른 편에 기술된 테이블의 데이터는 무조건 조회되게 한다.
--                       (일치하는 것을 찾지 못하더라도 조회하겠다.)
--> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--> 오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-- [참고] 3) FULL OUTER JOIN : 두 테이블이 가진 모든 행을 조회
-- 일치하는 행들 + LEFT OUTER JOIN 기준 새롭게 추가된 행들 + RIGHT OUTER JOIN
--> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--> 오라클 전용 구문(사용 불가)
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

/*
    3. 카테시안 곱 / 교차 조인(CROSS JOIN)
    
    모든 테이블의 각 행들이 서로서로 매핑된 데이터가 조회됨(곱집합)
    두 테이블의 행들이 모두 "곱해진" 행들의 조합 출력됨
    
    각각 N개, M개의 행을 가진 테이블이 있다면 출력 결과가 되는 행의 개수는 N * M행
    모든 경우의 수를 다 따져서 조회하겠다.
    방대한 데이터를 출력(과부하 위험이 있음)
*/

-- 사원명, 부서명
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT -- 23 인원 * 9개의 부서 -> 207개 행 조회
ORDER BY EMP_NAME ASC;

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT
ORDER BY EMP_NAME ASC;

-- 카테시안의 곱의 경우 : WHERE 조건절에 기술하는 조인문이 잘못되었거나 아예 없을 때 발생

/*
    4. 비등가 조인(NON EQUAL JOIN)
    '=' 를 사용하지 않는 조인문 => 다른 비교 연산자를 써서 조인(> , < , >= , <= , BETWEEN A AND B)
    ==> 지정한 칼럼 값들이 일치하는 경우가 아니라 "범위"에 포함되는 경우 매칭해서 조회하겠다.
    
    등가 조인 => '='으로 '일치'하는 경우만 조회
    비등가 조인 => '='가 아닌 다른 비교 연산자로 "범위"에 포함되는 경우를 조회
*/

-- 사원명, 급여, 급여 등급(SAL_LEVEL)
-- 오라클 구문
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
-- WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- ANSI 구문
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON SALARY BETWEEN MIN_SAL AND MAX_SAL;
-- USING은 등가 조인일 경우, 칼럼명이 같을 경우만 사용 가능

/*
    5. 자체 조인(SELF JOIN)
    
    같은 테이블끼리 조인하는 경우
    즉, 자기 자신의 테이블과 다시 조인을 맺겠다.
    => 자체 조인의 경우 테이블에 반드시 별칭을 붙여줘야 한다.(별칭을 붙이면 서로 다른 테이블인 것처럼 사용 가능)
*/

-- 사원의 사번(EMP_ID), 사원명(EMP_NAME), 사수의 사번(MANAGER_ID), 사수명(EMP_NAME)
SELECT E.EMP_ID, E.EMP_NAME, E.MANAGER_ID, M.EMP_NAME
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID(+);

-- ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, E.MANAGER_ID, M.EMP_NAME
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

/*
    <다중 JOIN>
    
    3개 이상의 테이블을 조인해서 조회하겠다.
    => 조인 순서가 중요하다.
*/

-- 사번(EMPLOYEE - EMP_ID), 사원명(EMPLOYEE - EMP_NAME), 부서명(DEPARTMENT -  DEPT_TITLE), 직급명(JOB - JOB_NAME)
-- 오라클 전용 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
  AND E.JOB_CODE = J.JOB_CODE; 
  
-- ANSI 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
LEFT JOIN JOB J ON E.JOB_CODE = J.JOB_CODE;

SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE
  AND E.DEPT_CODE = D.DEPT_ID(+); 
  
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
LEFT JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE;