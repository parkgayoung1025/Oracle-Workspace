/*
    SUBQUERY(서브쿼리)
    하나의 주된 SQL(SELECT, CREATE, UPDATE, INSERT) 안에 포함된 또 하나의 SELECT 문
    
    메인 SQL 문을 위해서 보조 역할을 하는 SELECT 문
    -> 주로 조건절 안에서 쓰임
*/

-- 간단 서브쿼리 예시 1
-- 노옹철 사원과 같은 부서인 사원들 조회
-- 1) 먼저 노옹철 사원의 부서 코드를 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- 2) 부서 코드가 D9인 사원들 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 위의 두 단계를 서브쿼리를 이용해서 하나로 합치기
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '노옹철');
            
-- 두 번째 예시
-- 전체 사원의 평균 급여보다 더 많은 급여를 받고 있는 사원들의 사번, 이름, 직급 코드를 조회
-- 1) 전체 사원의 평균 급여 구하기
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

-- 2) 평균 급여(3047663)보다 많은 급여를 받고 있는 사원 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY > = 3047663;

-- 위의 두 단계를 서브쿼리를 이용해서 하나로 합치기
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >= (SELECT ROUND(AVG(SALARY))
                 FROM EMPLOYEE);
                  
/*
    서브쿼리 구분
    서브쿼리를 수행한 결괏값이 몇행 몇열이냐에 따라서 분류가 됨
    - 단일행(단일열) 서브쿼리 : 서브쿼리를 수행한 결괏값이 오직 1개일 때(한 칸의 칼럼 값으로 나올 때)
    - 다중행(단일열) 서브쿼리 : 서브쿼리를 수행한 결괏값이 여러 행일 때
    - (단일행) 다중열 서브쿼리 : 서브쿼리를 수행한 결괏값이 여러 열일 때
    - 다중행 다중열 서브쿼리 : 서브쿼리를 수행한 결괏값이 여러 행 여러 열일 때
    
    => 서브쿼리를 수행한 결과가 몇행 몇열이냐에 따라 사용 가능한 연산자가 달라진다.
*/
/*
    1. 단일행(단일열) 서브쿼리(SINGLE ROW SUBQUERY)
    서브쿼리의 조회 결괏값이 오직 1개일 때
    
    일반 연산자 사용 가능(= , !=, > , < , >= , <= , ...)
*/

-- 전 직원의 평균 급여보다 더 적게 받는 사원들의 사원명, 직급 코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT ROUND(AVG(SALARY))
                FROM EMPLOYEE); -- 결괏값이 1행 1열일 때, 오로지 1개의 값

-- 최저 급여를 받는 사원의 사번, 사원명, 직급 코드, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);
                
-- 노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');
                
-- 사번, 이름, 부서명, 급여
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');
                
-- 부서별 급여 합이 가장 큰 부서 하나만을 조회, 부서 코드, 부서명, 급여 합
-- 1) 각 부서별 급여 합 구하기 
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 가장 큰 합을 찾기
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 3) 서브쿼리를 이용해서 하나로 합치기
SELECT DEPT_CODE, DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);

/*
    2. 다중행 서브쿼리(MULTI ROW SUBQUERY)
    
    서브쿼리의 조회 결괏값이 여러 행일 경우
    
    - IN (10, 20, 30, ...) 서브쿼리 : 여러 개의 결괏값 중에서 하나라도 일치하는 것이 있다면 IN / 일치하는 것이 없다면 NOT IN
    - > ANY(10, 20, 30, ...) : 여러 개의 결괏값 중에서 "하나라도" 클 경우 즉, 여러 개의 결괏값 중에서 가장 작은 값 보다 클 경우
    - < ANY(10, 20, 30, ...) : 여러 개의 결괏값 중에서 "하나라도" 작을 경우 즉, 여러 개의 결괏값 중에서 가장 큰 값 보다 작을 경우
    
    - > ALL : 여러 개의 결괏값의 모든 값보다 클 경우
              즉, 여러 개의 결괏값 중에서 가장 큰 값보다 클 경우
    - < ALL : 여러 개의 결괏값의 모든 값보다 작을 경우
              즉, 여러 개의 결괏값 중에서 가장 작은 값보다 작을 경우
*/

-- 각 부서별 최고 급여를 받는 사원의 이름, 직급 코드, 급여 조회
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 위의 급여를 받는 사원을 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                 FROM EMPLOYEE
                 GROUP BY DEPT_CODE);

-- 선동일 또는 유재식과 같은 부서인 사원들을 조회(사원명, 부서 코드, 급여)
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME IN ('선동일', '유재식'));
                    
-- 이오리 또는 하동운 사원과 같은 직급인 사원들을 조회(사원명, 직급 코드, 부서 코드, 급여)
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN ('이오리', '하동운'));
                
-- 사원 < 대리 < 과장 < 차장 < 부장
-- 대리 직급인데도 불구하고 과장 직급의 급여보다 많이 받는 사원들 조회

-- 1) 과장 직급의 급여들 조회 -> 다중행 단일열
SELECT SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
  AND JOB_NAME = '과장';
  
-- 2) 위의 급여들보다 하나라도 더 높은 급여를 받는 직원들 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND JOB_NAME = '대리'
  AND SALARY >= ANY(SELECT SALARY
                    FROM EMPLOYEE E, JOB J
                    WHERE E.JOB_CODE = J.JOB_CODE
                    AND JOB_NAME = '과장');
                    
-- 과장 직급임에도 불구하고 "모든" 차장 직급의 급여보다도 더 많이 받는 직원 조회(사번, 이름, 직급명, 급여)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY > ALL(SELECT SALARY
                   FROM EMPLOYEE E, JOB J
                   WHERE E.JOB_CODE = J.JOB_CODE
                   AND JOB_NAME = '차장')
  AND JOB_NAME = '과장';

/*
    3.(단일행) 다중열 서브쿼리
    
    서브쿼리 조회 결과가 값은 한행이지만 나열된 칼럼의 개수가 여러 개인 경우
*/

-- 하이유 사원과 같은 부서 코드, 같은 직급 코드에 해당되는 사원들 조회(사원명, 부서 코드, 직급 코드, 고용일)
-- 1) 하이유 사원의 부서 코드와 직급 코드 먼저 조회 => 단일행 다중열(DEPT_CODE, JOB_CODE)
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유';

-- 2) 부서 코드가 D5이면서 직급 코드가 J5인 사원들 조회
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND JOB_CODE = 'J5';

-- 3) 위의 내용들을 하나의 쿼리문으로 합치기
-- 다중열 서브쿼리(비교할 값의 순서를 맞추는게 중요하다)
-- (비교 대상 칼럼1, 비교 대상 칼럼2) = (비교할 값1, 비교할값2) -> 서브쿼리로 제시
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                               FROM EMPLOYEE
                               WHERE EMP_NAME = '하이유');
                               
-- 박나라 사원과 같은 직급 코드, 같은 사수 사번을 가진 사원들의 사번, 이름, 직급 코드, 사수 사번 조회
-- 다중열 서브쿼리 작성
SELECT JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '박나라';

SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE JOB_CODE = 'J7' AND MANAGER_ID = '207';

SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '박나라');
                                
/*
    4. 다중행 다중열 서브쿼리
    
    서브쿼리 조회 결과가 여러 행, 여러 칼럼일 경우
*/