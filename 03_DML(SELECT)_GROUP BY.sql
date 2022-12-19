/*
    <GROUP BY 절>
    
    그룹을 묶어줄 기준을 제시할 수 있는 구문 => 그룹 함수와 같이 쓰임
    해당 제시된 기준별로 그룹을 묶을 수 있다.
    여러 개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
    
    [표현법]
    GROUP BY 묶어줄 기준이 될 칼럼
*/

-- 각 부서별로 총 급여의 합계
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 부서별로 그룹을 짓겠다.

-- 각 부서별 사원수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE group by DEPT_CODE;

-- 각 부서별로 총 급여 합을 부서별 오름차순으로 정렬해서 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE ASC;

-- 각 부서별 총 급여 합을 급여별로 내림차순으로 정렬해서 조회
SELECT DEPT_CODE, SUM(SALARY) 총급여 -- 4. SELECT 절 실행
FROM EMPLOYEE -- 1. FROM 절 실행
WHERE 1=1 -- 2. WHERE 절 실행
GROUP BY DEPT_CODE -- 3. GROUP BY 절 실행
ORDER BY 총급여 DESC; -- 5. ORDER BY 절 실행

-- 각 직급별 직급 코드, 총 급여의 합, 사원수, 보너스를 받는 사원수, 평균 급여, 최고 급여, 최소 급여
SELECT JOB_CODE "직급 코드", 
       SUM(SALARY) "총 급여 합",
       COUNT(*) "사원 수", 
       COUNT(BONUS) "보너스를 받는 사원수", 
       ROUND(AVG(SALARY)) "평균 급여", 
       MAX(SALARY) "최고 급여", 
       MIN(SALARY) "최소 급여"
FROM EMPLOYEE 
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 성별 별 사원수
-- 성별 : SUBSTR(EMP_NO, 8, 1)
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별, COUNT(*) 사원수
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

-- 각 부서별로 평균 급여가 300만원 이상인 부서만 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
WHERE ROUND(AVG(SALARY)) >= 3000000 -- 오류. 문법상 그룹 함수를 WHERE 절에서 쓸 수 없음
GROUP BY DEPT_CODE;                 -- WHERE 실행 -> GROUP BY 실행 -> AVG 실행이라서 안됨

/*
    <HAVING 절>
    
    그룹에 대한 조건을 제시하고자 할 때 사용되는 구문
    (주로 그룹 함수를 가지고 제시) -> GROUP BY 절과 함께 쓰인다.
*/

-- 각 부서별로 평균 급여가 300만원 이상인 부서만 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING ROUND(AVG(SALARY)) >= 3000000;

-- 각 직급별로 총 급여 합이 1000만원 이상인 직급 코드, 급여 합을 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

-- 각 직급별 급여 평균이 300만원 이상인 직급 코드, 평균 급여, 사원수, 최고 급여, 최소 급여
SELECT JOB_CODE "직급 코드", ROUND(AVG(SALARY)) "평균 급여", COUNT(*) 사원수, MAX(SALARY) "최고 급여", MIN(SALARY) "최소 급여"
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING ROUND(AVG(SALARY)) >= 3000000;

-- 각 부서별 보너스를 받는 사원이 없는 부서만 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

-- 각 부서별 평균 급여가 350만원 이하인 부서만 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING ROUND(AVG(SALARY)) <= 3500000;

/*
    <SELECT 문 구조 및 실행 순서>
    5. SELECT 조회하고자 하는 칼럼명 나열 / * /리터럴 / 산술 연산식 / 함수 / 별칭 부여
    1. FROM 조회하고자 하는 테이블명 / 인라인쿼리 / 가상 테이블(DUAL)
    2. WHERE 조건식 (그룹 함수를 사용할 수 없음)
    3. GROUP BY 그룹 기준에 해당하는 칼럼명 / 함수식
    4. HAVING 그룹 함수식에 대한 조건식
    6. ORDER BY [정렬 기준에 해당하는 칼럼명 / 별칭 / 칼럼의 순번] [ASC / DESC] 생략 가능 [NULLS FIRST / NULLS LAST]
*/

/*
    <집합 연산자 SET OPERATOR>
    
    여러 개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
    
    - UNION(합집합) : 두 쿼리문을 수행한 결괏값을 더한 후 중복되는 부분은 한 번만 빼서 중복을 제거한 것 => OR
    - UNION ALL : 두 쿼리문을 수행한 결괏값을 더한 후 중복 제거를 하지 않은 것 => 합집합 + 교집합
    - INTERSECT(교집합) : 두 쿼리문을 수행한 결괏값의 중복된 부분 => AND
    - MINUS(차집합) : 선행 쿼리문 결괏값에서 후행 쿼리문 결괏값을 뺀 나머지 부분
                     => 선행 쿼리문 결괏값 - 교집합 1
    
    주희해야할 점 : 두 쿼리문의 결과를 합쳐서 한 개의 테이블로 보여줘야 하기 때문에 두 쿼리문의 SELECT 절 부분은 같아야 한다.
                  즉, 조회할 "칼럼"이 동일해야 한다.
*/

-- 1. UNION(합집합) : 두 쿼리문을 수행한 결괏값을 더하지만 중복은 제거

-- 부서 코드가 D5이거나 또는 급여가 300만원 초과인 사원들 조회(사번, 사원명, 부서 코드, 급여)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' -- 6명
UNION -- 12명(중복 제거)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8명

-- 직급 코드가 J6이거나 또는 부서 코드가 D1인 사원들을 조회(사번, 사원명, 부서 코드, 직급 코드) => UNION 사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 2. UNION ALL : 여러 개의 쿼리 결과를 더해서 보여주는 연산자(중복 제거 안 함)
-- 직급 코드가 J6이거나 부서 코드가 D1인 사원들을 조회(사번, 사원명, 부서 코드, 직급 코드)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 3. INTERSECT : 교집합, 여러 쿼리 결과의 중복된 결과만 조회 => AND
-- 직급 코드가 J6이거나 부서 코드가 D1인 사원들을 조회(사번, 사원명, 부서 코드, 직급 코드)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 4. MINUS : 차집합, 선행 쿼리 결과에서 후행 쿼리 결과를 뺀 나머지
-- 직급 코드가 J6이거나 부서 코드가 D1인 사원들을 조회(사번, 사원명, 부서 코드, 직급 코드)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6' -- 전형돈, 장쯔위, 하동운, 차태연, 전지연, 이태림
MINUS -- 전형돈, 장쯔위, 하동운, 이태림
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1'; -- 방명수, 차태연, 전지연