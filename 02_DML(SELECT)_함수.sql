/*
    <함수 FUNCTION>
    자바로 따지면 메서드와 같은 존재
    매개 변수로 전달된 값들을 읽어서 계산한 결과를 반환 -> 호출해서 쓴다.
    
    - 단일행 함수 : n개의 값을 읽어서 n개의 결과를 리턴(매 행마다 함수 실행 후 결과 반환)
    - 그룹 함수 : n개의 값을 읽어서 1개의 결과를 리턴(하나의 그룹별로 함수 실행 후 결과 반환)
    
    단일행 함수와 그룹 함수는 함께 사용할 수 없음 : 결과 행의 개수가 다르기 때문
*/

 ------- 단일행 함수 -------
 /*
    <문자열과 관련된 함수>
    LENGTH /  LENGTHB
    
    - LENGTH(문자열) : 해당 전달된 문자열의 글자 수 반환
    - LENGTHB(문자열) : 매개 변수로 전달된 문자열의 바이트 수 반환
    
    결괏값은 숫자로 반환한다 => NUMBER 데이터 타입
    문자열 : 문자열 형식의 리터럴 혹은 문자열에 해당하는 칼럼
    
    한글 -> '김' -> 'ㄱ', 'ㅣ', 'ㅁ' => 한글자당 3바이트 취급
    영문, 숫자, 특수문자 : 한글자당 1BYTE로 취급
 */
 
 SELECT LENGTH('오라클 쉽네'), LENGTHB('오라클 쉽네')
 FROM DUAL; -- 가상 테이블(DUMMY TABLE) : 산술 연산이나 가상 칼럼 값 등 한 번만 출력하고 싶을 때 사용하는 테이블
 
 SELECT '오라클', 1, 2, 3, 'AAAAAA', SYSDATE
 FROM DUAL;
 
 /*
    INSTR
    
    -INSTR(문자열, 특정 문자, 찾을 위치의 시작 값, 순번) : 문자열로부터 특정 문자의 위치 값 반환
    
    찾을 위치의 시작 값과 순번은 생략 가능
    결괏값은 NUMBER 타입으로 반환
    
    찾을 위치의 시작 값 (1 / -1)
    1 : 앞에서부터 찾겠다(생략 시 기본값)
    -1 : 뒤에서부터 찾겠다
 */
 
 SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL;
 -- 앞에서부터 B를 찾아서 첫 번째로 찾는 B의 위치를 반환해 줌
 
 SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL;
 -- 위와 동일
 
 SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;
 -- 뒤에서부터 첫 번째에 위치하는 B의 위치값을 앞에서부터 세서 알려준 것
 
 SELECT INSTR('AABAACAABBAA', 'B', -1, 2) FROM DUAL;
 
 SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL;
 
 SELECT INSTR('AABAACAABBAA', 'B', -1, 0) FROM DUAL;
 -- 범위를 벗어난 순번을 제시하면 오류 발생
 
 -- 인덱스처럼 글자의 위치를 찾은 것은 맞다.
 -- 자바처럼 0부터가 아니라 1부터 찾는다.
 
 -- EMPLOYEE 테이블에서 EMAIL 칼럼에서 @의 위치를 찾아보기
 SELECT EMP_NAME, EMAIL, INSTR(EMAIL, '@') AS "@의 위치"
 FROM EMPLOYEE;
 
 /*
    <SUBSTR>
    
    문자열로부터 특정 문자열을 추출하는 함수
    
    - SUBSTR(문자열, 처음 위치, 추출할 문자 개수)
    
    결괏값은 CHARACTER 타입으로 반환(문자열 형태)
    추출할 문자 개수 생략 가능(생략 시에는 문자열 끝까지 추출)
    처음 위치는 음수로 제시 가능 : 뒤에서부터 n번째 위치로부터 문자를 추출
 */
 
 SELECT SUBSTR('ORACLEDATABASE', 7) FROM DUAL;
 
 SELECT SUBSTR('ORACLEDATABASE', 7, 4) FROM DUAL;
 
 SELECT SUBSTR('ORACLEDATABASE', -8, 3) FROM DUAL;
 
 -- 주민등록번호에서 성별 부분을 추출해서 남자(1, 3) / 여자(2, 4)인지를 체크
 SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1)
 FROM EMPLOYEE;
 
 -- 이메일에서 ID부분만 추출해서 조회
 SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) AS ID
 FROM EMPLOYEE;
 
 -- 남자 사원들만 조회(모든 칼럼)
 SELECT *
 FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) = 1;
     --SUBSTR(EMP_NO, 8, 1) IN (1, 3); 같은 코드
 
 -- 여자 사원들만 조회(모든 칼럼)
 SELECT *
 FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) = 2;
 
 /*
    <LPAD / RPAD>
    
    - LPAD / RPAD(문자열, 최종적으로 반환할 문자의 길이(BYTE), 덧붙이고자 하는 문자)
    : 제시한 문자열에 덧붙이고자 하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 n 길이만큼의 문자열을 반환
    
    결괏값은 CHARACTER 타입으로 반환
    덧붙이고자 하는 문자 : 생략 가능
 */
 
 SELECT EMAIL, LPAD(EMAIL, 16,'*'), LENGTH(EMAIL) FROM EMPLOYEE;
 -- 덧붙이고자 하는 문자 생략 시 공백이 문자열 값의 왼쪽에 붙어서 반환
 
 SELECT EMAIL, RPAD(EMAIL, 20,'#') FROM EMPLOYEE;
 
 -- 주민등록번호 조회 : 123456-1234567 => 123456-1******;
 SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') AS "주민번호 앞자리"
 FROM EMPLOYEE;
 
 /*
    <LTRIM / RTRIM>
    
    - LTRIM / RTRIM(문자열, 제거시키고자 하는 문자)
    : 문자열의 왼쪽 또는 오른쪽에서 제거시키고자 하는 문자들을 찾아서 제거한 나머지 문자열을 반환
    
    결괏값은 CHARACTER 형태로 나옴
    제거시키고자 하는 문자 생략 가능 => ' '이 제거됨
 */
 
 SELECT LTRIM('    박  가 영   ')
 FROM DUAL;
 
 SELECT RTRIM('0001230456000', '0')
 FROM DUAL;
 
 SELECT LTRIM('131313KH123', '123') 
 FROM DUAL; 
 -- 제거시키고자 하는 문자열을 통으로 지워주는 게 아니라 문자 하나하나 검사를 하면서 현재 문자가 지우고자 하는 문자에 있다면 지워줌
 
 /*
    <TRIM>
    
    - TRIM(BOTH / LEADING / TRAILING '제거하고자 하는 문자' FROM '문자열')
    : 문자열에서 양쪽 / 앞쪽 / 뒤쪽에 있는 특정 문자를 제거한 나머지 문자열을 반환
    
    결괏값은 당연히 CHARACTER 타입으로 반환
    BOTH / LEADING / TRAILING은 생략 가능하며 기본값은 BOTH
 */
 
 SELECT TRIM('         K     H         ')
 FROM DUAL;
 
 SELECT TRIM('Z' FROM 'ZZZKHZZZ')
 FROM DUAL;
 
 SELECT TRIM(TRAILING 'Z' FROM 'ZZZKHZZZZ')
 FROM DUAL;
 
 /*
    <LOWER / UPPER / INITCAP>
    
    - LOWER(문자열)
    : 소문자로 변경
    - UPPER(문자열)
    : 문자열을 대문자로 변경
    - INITCAP(문자열)
    : 각 단어의 앞글자만 대문자로 변환
    
    결괏값은 동일한 CHARACTER 형태
 */
 
 SELECT LOWER('WELCOME TO C CLASS'), UPPER('welcome to c class'), INITCAP('welcome to c class')
 FROM DUAL;
 
 /*
    <CONCAT>
    
    - CONCAT(문자열1, 문자열2)
    : 전달 된 문자열 두 개를 하나의 문자열로 합쳐서 반환(매개 변수 딱 두 개만 가능함)
    
    결괏값은 CHARACTER
 */
 
 SELECT CONCAT('가나다', '라마바사') FROM DUAL;
 SELECT '가나다' || '라마바사' FROM DUAL;
 
 SELECT CONCAT(CONCAT('가나다', '라마바사'), '아') FROM DUAL;
 SELECT '가나다' || '라마바사' || '아' FROM DUAL;
 
 /*
    <REPLACE>
    
    - REPLACE(문자열, 찾을 문자, 바꿀 문자)
    : 문자열로부터 찾을 문자를 찾아서 바꿀 문자로 치환
 */
 
 SELECT REPLACE('서울시 강남구 역삼동 테헤란로 6번길 남도빌딩 3층', '3층', '2층 C클래스') 
 FROM DUAL;
 
 SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'kh.or.kr', 'iei.or.kr')
 FROM EMPLOYEE;
 
 /*
    <숫자와 관련된 함수>
    ABS
    
    - ABS(숫자) : 절대값을 구해주는 함수
    
    결괏값은 NUMBER
 */
 
 SELECT ABS(-10) FROM DUAL;
 
 SELECT ABS(-10.9) FROM DUAL;
 
 /*
    MOD -> 모듈러 연산 -> %
    
    - MOD(숫자, 나눌 값) : 두 수를 나눈 '나머지' 값을 반환해주는 함수
    
    결괏값은 NUMBER
 */
 
 SELECT MOD(10, 3) FROM DUAL;
 
 SELECT MOD(-10, 3) FROM DUAL;
 
 SELECT MOD(10.9, 3) FROM DUAL;
 
 /*
    ROUND
    
    - ROUND(반올림하고자 하는 수, 반올림할 위치) : 반올림해 주는 함수
    
    반올림할 위치 : 소수점 기준으로 아래 n번째 수에서 반올림하겠다.
                  생략 가능(기본값은 0, 소수점 첫 번째 자리에서 반올림을 하겠다 == 소수점이 0개다.)
 */
 
 SELECT ROUND(123.456) FROM DUAL;
 
 SELECT ROUND(123.456, 1) FROM DUAL;
 
 SELECT ROUND(123.456, -1) FROM DUAL; -- 음수도 제시 가능
 
 /*
    CEIL
    
    - CELI(올림 처리할 숫자) : 소수점 아래의 수를 무조건 올림 처리해 주는 함수
    
    반환형은 NUMBER 타입
    
    FLOOR
    
    - FLOOR(버림 처리하고자 하는 숫자) : 소수점 아래의 수를 무조건 버림 처리
 */
 
  SELECT CEIL(123.111111) FROM DUAL;
  
  SELECT FLOOR(207.9999999) FROM DUAL;
  
  -- 각 직원별로 근무 일수 구하기(오늘 날짜 - 고용일 => 소수점)
  SELECT EMP_NAME, HIRE_DATE, CONCAT(FLOOR(SYSDATE - HIRE_DATE), '일') AS 근무일수
  FROM EMPLOYEE;
  
  /*
    TRUNC
    
    - TRUNC(버림 처리할 숫자, 위치) : 위치가 지정 가능한 버림 처리를 해주는 함수
    결괏값 NUMBER
    위치 :  생략 가능. 생략 시 기본값은 0 == FLOOR 함수
  */
  
  SELECT TRUNC(123.789, 1) FROM DUAL;
  
  SELECT TRUNC(123.789, -1) FROM DUAL;
  
  /*
    <날짜 관련 함수>
    
    DATE 타입 : 연도, 월, 일, 시, 분, 초를 다 포함하고 있는 자료형
  */
  
  -- SYSDATE : 현재 시스템 날짜 반환
  SELECT SYSDATE FROM DUAL;
  
  -- 1. MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월 수를 반환(결괏값은 NUMBER)
  -- DATE2가 미래일 경우 음수가 나옴
  
  -- 각 직원별 근무일 수, 근무 개월 수
  SELECT EMP_NAME, 
         FLOOR(SYSDATE - HIRE_DATE) || '일' 근무일수, 
         FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월' 근무개월수
       --FLOOR(ABS(MONTHS_BETWEEN(HIRE_DATE, SYSDATE))) || '개월' 근무개월수
  FROM EMPLOYEE;
  
  -- 2. ADD_MONTHS(DATE, NUMBER) : 특정 날짜에 해당 숫자만큼 개월 수를 더한 날짜 반환(결괏값은 DATE)
  -- 오늘 날짜로부터 5개월 후
  SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;
  
  -- 전체 사원들의 1년 근속 일(== 입사일 기준 1주년)
  SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 12) FROM EMPLOYEE;
  
  -- 3. NEXT_DAY(DATE, 요일(문자/숫자)) : 특정 날짜에서 가장 가까운 요일을 찾아 그 날짜를 반환(과거X미래O)
  SELECT NEXT_DAY(SYSDATE, 3) FROM DUAL;
  -- 1 : 일요일, 2 : 월요일, 3 : 화요일, ... 7 : 토요일
  SELECT NEXT_DAY(SYSDATE, '토') FROM DUAL;
  -- '토'요일 이나 '토요일'은 가능한데 SATURDAY는 오류 => 현재 컴퓨터 세팅이 KOREAN이기 때문에. 숫자로 표현해 주는 게 좋음
  
  -- 언어를 변경
  -- DDL(데이터 정의 언어) : CREATE, ALTER, DROP
  ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
  
  SELECT NEXT_DAY(SYSDATE, 'MON') FROM DUAL;
  
  -- 한국어로 다시 변경
   ALTER SESSION SET NLS_LANGUAGE = KOREAN;
   
   -- 4. LAST_DAY(DATE) : 해당 특정 날짜 달의 마지막 날짜를 구해서 반환
   SELECT LAST_DAY(SYSDATE) FROM DUAL;
   
   -- 이름, 입사일, 입사한 날의 마지막 날 날짜 조회
   SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
   FROM EMPLOYEE;
   
   -- 5. EXTRACT : 연도, 월, 일 정보를 추출해서 반환(결괏값 NUMBER)
   
   /*
    - EXTRACT(YEAR FROM 날짜) : 특정 날짜로부터 연도만 추출
    - EXTRACT(MONTH FROM 날짜) : 특정 날짜로부터 월만 추출
    - EXTRACT(DAY FROM 날짜) : 특정 날짜로부터 일만 추출
   */   
   
SELECT EXTRACT(YEAR FROM SYSDATE),
       EXTRACT(MONTH FROM SYSDATE),
       EXTRACT(DAY FROM SYSDATE)
FROM DUAL;

/*
    <형변환 함수>
    
    NUMBER / DATE => CHARACTER
    
    - TO_CHAR(NUMBER/DATE, 포맷)
    : 숫자형 또는 날짜형 데이터를 문자형 타입으로 반환(포맷 맞춰서)
*/

SELECT TO_CHAR(123456) FROM DUAL;

SELECT TO_CHAR(123, '00000') FROM DUAL;
-- 빈칸을 0으로 채움

SELECT TO_CHAR(1234, '99999') FROM DUAL;
-- 1234에 빈칸을 ' '(공백)으로 채움

SELECT TO_CHAR(1234, 'L00000') FROM DUAL;
-- L : LOCAL => 현재 설정된 나라의 화폐 단위
-- 1234 => ￦01234

SELECT TO_CHAR(1234, 'L99,999') FROM DUAL;
-- 1234 => ￦1234

-- 급여 정보를 3자리 마다 ,를 추가
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999') AS 급여
FROM EMPLOYEE;

-- 날짜를 문자열로
SELECT TO_CHAR(SYSDATE) 
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') -- HH24 : 24시간 형식
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'MON DAY, YYYY') -- MON : 몇 '월' 형식
FROM DUAL;                               -- DY : 요일 EX) 금요일 -> 금

SELECT TO_CHAR(HIRE_DATE, 'YYYY'),
       TO_CHAR(HIRE_DATE, 'RRRR'),
       TO_CHAR(HIRE_DATE, 'YY'),
       TO_CHAR(HIRE_DATE, 'RR'),
       TO_CHAR(HIRE_DATE, 'YEAR')
FROM EMPLOYEE;
-- YY와 RR의 차이점
-- R이 뜻하는 단어 : ROUND(반올림)
-- YY : 앞자리에 무조건 20이 붙음 => (20)21
-- RR : 50년 기준 작으면 20이 붙음, 크면 19가 붙음 => 19(89)

-- 월로 사용할 수 있는 포맷
SELECT TO_CHAR(HIRE_DATE, 'MM'),
       TO_CHAR(HIRE_DATE, 'MON'),
       TO_CHAR(HIRE_DATE, 'MONTH'),
       TO_CHAR(HIRE_DATE, 'RM')
FROM EMPLOYEE;

-- 일로 사용할 수 있는 포맷
SELECT TO_CHAR(HIRE_DATE, 'D'),
       TO_CHAR(HIRE_DATE, 'DD'),
       TO_CHAR(HIRE_DATE, 'DDD')
FROM EMPLOYEE;
-- D : 1주일 기준으로 일요일부터 며칠째인지 알려주는 포맷
-- DD : 1달 기준으로 1일부터 며칠째인지 알려주는 포맷
-- DDD : 1년 기준으로 1월 1일부터 며칠째인지 알려주는 포맷

-- 요일로써 사용할 수 있는 포맷
SELECT TO_CHAR(SYSDATE, 'DY'),
       TO_CHAR(SYSDATE, 'DAY')
FROM DUAL;

-- 2022년 11월 14일 (금) 포맷으로 적용하기
SELECT TO_CHAR(SYSDATE, 'YYYY') || '년 ' ||
       TO_CHAR(SYSDATE, 'MM') || '월 ' ||
       TO_CHAR(SYSDATE, 'DD') || '일 ' ||
       TO_CHAR(SYSDATE, '(DY)')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" (DY)')
FROM DUAL;

-- 2010년 이후에 입사한 사원들의 사원명, 입사일 포맷은 위의 형식대로
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" (DY)')
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2010; 
    --HIRE_DATE >= '10/01/01'; 자동 형변환으로 비교
    
/*
    NUMBER / CHARACTER => DATE
    
    - TO_DATE(NUMBER/CHARACTER, 포맷) :  숫자형, 문자형 데이터를 날짜로 변환
*/

SELECT TO_DATE('20221104') -- 기본포맷 YY/MM/DD로 변환
FROM DUAL;

SELECT TO_DATE(000101) -- 정수 값 중에 0으로 시작하는 숫자는 없기 때문에 에러 발생
FROM DUAL;

SELECT TO_DATE('000101') -- 0으로 시작하는 연도를 다룰 때는 반드시 홀따옴표''를 붙여서 문자열처럼 다뤄줘야 함
FROM DUAL;

SELECT TO_DATE('20221104', 'YYYYMMDD')
FROM DUAL;

SELECT TO_DATE('091129 143050', 'YYMMDD HH24:MI:SS')
FROM DUAL;

SELECT TO_DATE('220806', 'YYMMDD')
FROM DUAL; -- 2022년도 22-08-06

SELECT TO_DATE('980806', 'YYMMDD')
FROM DUAL; -- 2098년도
-- TO_DATE() 함수를 이용해서 DATE 형식으로 변환 시 두 자리 연도에 대해 YY 형식을 적용시키면 무조건 현재 세기(20)를 붙여줌

SELECT TO_DATE('220218', 'RRMMDD')
FROM DUAL; -- 2022년도

SELECT TO_DATE('980806', 'RRMMDD')
FROM DUAL; -- 1998년도
-- 두 자리 연도에 대해 RR 포맷을 적용시켰을 경우 => 50 이상이면 이전 세기, 50 미만이면 현재 세기(반올림)

/*
    CHARACTER -> NUMBER
    TO_NUMBER(CHARACTER, 포맷) : 문자형 데이터를 숫자형으로 변환
*/

-- 자동 형변환의 예시(문자열 -> 숫자)
SELECT '123' + '123'
FROM DUAL; -- 246 : 자동 형변환 후 산술 연산이 진행됨

SELECT '10,000,000' + '550,000'
FROM DUAL; -- , 문자를 포함하고 있어서 자동 형변환이 안된다.

SELECT TO_NUMBER('10,000,000', '99,999,999') + TO_NUMBER('550,000', '999,999')
FROM DUAL;

SELECT TO_NUMBER('0123')
FROM DUAL;

-- 문자열, 숫자, 날짜 형변환 끝 --

-- NULL : 값이 존재하지 않음을 의미
-- NULL 처리 함수들 : NVL, NVL2, NULLIF

/*
    <NULL> 처리 함수
    NVL(칼럼명, 해당 칼럼 값이 NULL일 경우 반환할 반환 값)
    -- 해당 칼럼 값이 존재할 경우(NULL이 아닐 경우) 기존의 칼럼 값을 반환
    -- 해당 칼럼 값이 존재하지 않을 경우(NULL일 경우) 내가 제시한 특정 값을 반환
*/

-- 사원명, 보너스, 보너스가 없는 경우 0을 출력
SELECT EMP_NAME, BONUS, NVL(BONUS, 0)
FROM EMPLOYEE;

-- 보너스 포함 연봉 조회(SALARY + SALARY*BONUS) * 12
SELECT EMP_NAME, (SALARY + (SALARY * NVL(BONUS , 0))) * 12 AS "보너스가 포함된 연봉"
FROM EMPLOYEE;

-- 사원명, 부서 코드(부서 코드가 없는 경우 '없음') 조회
SELECT EMP_NAME, NVL(DEPT_CODE, '없음')
FROM EMPLOYEE;

-- NVL2(칼럼명, 결괏값1, 결괏값2)
-- 해당 칼럼에 값이 존재할 경우 결괏값 1 반환
-- 해당 칼럼에 값이 NULL일 경우 결괏값 2 반환

-- 보너스가 있는 사원은 '보너스 있음', 보너스가 없는 사원은 '보너스 없음'
SELECT EMP_NAME, BONUS, NVL2(BONUS, '보너스 있음', '보너스 없음')
FROM EMPLOYEE;

-- NULLIF(비교 대상1, 비교 대상2) : 동등 비교
-- 두 값이 동일할 경우 NULL 반환
-- 두 값이 동일하지 않을 경우 비교 대상1을 반환
SELECT NULLIF('123', '123456')
FROM DUAL;

-- 선택 함수 : DECODE => SWITCH문
-- 선택 함수 친구 : CASE WHEN THEN 구문 => IF 문
/*
    <선택 함수>
    - DECODE(비교 대상, 조건값1, 결괏값1, 조건값2, 결괏값2, 조건값3, 결괏값3,... 결괏값)
    
    - 자바에서 SWITCH 문과 유사
    SWITCH(비교 대상) {
    CASE 조건값1 : 결괏값1; BREAK;
    CASE 조건값2 : 결괏값2; BREAK;
    CASE 조건값3 : 결괏값3; BREAK;
    ...
    DEFAULT : 결괏값
    }
    비교 대상에는 칼럼명, 산술 연산, 함수가 들어갈 수 있음
*/

-- 사번, 사원명, 주민번호, 주민번호로부터 성별을 추출하여 1이면 남, 2면 여
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), 1 , '남', 2, '여') 성별
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), 1 , '남', 2, '여', NULL) 성별
FROM EMPLOYEE;
-- DEFAULT 값으로 NULL 들어가 있음

-- 각 직원들의 급여를 인상 시켜서 조회
-- 직급 코드가 'J7'인 사원은 급여를 20% 인상해서 조회
-- 직급 코드가 'J6'인 사원은 급여를 15% 인상해서 조회
-- 직급 코드가 'J5'인 사원은 급여를 50% 인상해서 조회
-- 그 외 직급은 급여를 10%만 인상해서 조회
-- 사원명, 직급 코드, 변경 전 급여, 변경 후 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY AS "변경 전 급여", DECODE(JOB_CODE, 'J7', SALARY * 1.2, 'J6', SALARY * 1.15, 'J5', SALARY *1.5, SALARY * 1.1) AS "변경 후 급여"
FROM EMPLOYEE;

/*
    CASE WHEN THEN 구문
    - DECODE 선택 함수와 비교하면 DECODE는 해당 조건 검사 시 동등 비교만을 수행 => SWITCH 문과 유사
    CASE WHEN THEN 구문은 특정 조건을 내 마음대로 제시 가능
    
    [표현법]
    CASE WHEN 조건식1 THEN 결괏값1
         WHEN 조건식2 THEN 결괏값2
         ...
         ELSE 결괏값
    END;
    
    - 자바에서 IF ~ ELSE IF 문과 같은 느낌
*/

-- 사번, 사원명, 주민번호, 주민번호로부터 성별을 추출하여 1이면 남, 2면 여
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), 1 , '남', 2, '여') 성별
FROM EMPLOYEE; -- DECODE 함수 이용

-- CASE WHEN THEN 구문 이용
-- = : 대입 연산자 X 동등 비교 연산자
SELECT EMP_ID 사번, EMP_NAME 사원명, EMP_NO 주민번호,
       CASE WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '남자'
            ELSE '여자'
            END 성별
FROM EMPLOYEE;

-- 사원명, 급여, 급여 등급(SAL_LEVEL 사용X)
-- 급여 등급 SALARY 값이 500만원 초과일 경우 '고급'
--                     500만원 이하 350만원 초과 '중급'
--                     350이하 '초급'
-- CASE WHEN THEN 구문으로 작성
SELECT EMP_NAME 사원명, SALARY 급여,
       CASE WHEN SALARY > 5000000 THEN '고급'
            WHEN SALARY > 3500000 THEN '중급'
            ELSE '초급'
            END "급여 등급"
FROM EMPLOYEE;

-- 그룹 함수 : 데이터들의 합, 데이터들의 평균 구함. SUM, AVG
/*
    N개의 값을 읽어서 1개의 결과를 반환(하나의 그룹별로 함수를 실행하고 결괏값 반환)
*/

-- 1. SUM(숫자 타입의 칼럼) : 해당 칼럼 값들의 총 합계를 반환
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 부서 코드가 'D5'인 사원들의 총 합계
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 2. AVG(숫자 타입 칼럼) : 해당 칼럼 값들의 평균을 구해서 반환
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

-- 3. MIN(ANY 타입) : 해당 칼럼 값들 중 가장 작은 값 반환
SELECT MIN(SALARY), MIN(EMP_NAME), MIN(EMAIL), MIN(HIRE_DATE)
FROM EMPLOYEE;

-- 4. MAX(ANY 타입) : 해당 칼럼 값들 중 가장 큰 값 반환
SELECT MAX(SALARY), MAX(EMP_NAME), MAX(EMAIL), MAX(HIRE_DATE)
FROM EMPLOYEE;
-- MAX 함수의 경우 내림 차순으로 정렬 시 가장 위쪽의 값을 보여준다.

-- 5. COUNT(*/칼럼 이름/DISTINCT 칼럼 이름) : 조회된 행의 개수를 세서 반환
-- COUNT(*) : 조회 결과에 해당하는 모든 행의 개수를 다 세서 반환
-- COUNT(칼럼 이름) : 제시한 해당 칼럼 값이 NULL이 아닌 것만 행의 개수를 세서 반환
-- COUN(DISTINCT 칼럼 이름) : 제시한 해당 칼럼 값이 중복 값이 있을 경우 하나로만 세서 반환, NULL이 포함되지 않음

-- 전체 사원수에 대해 조회
SELECT COUNT(*)
FROM EMPLOYEE;

-- 여자인 사원의 수만 조회
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2';

-- 부서 배치가 완료된 사원수만 조회
-- 부서 배치가 완료되었다 == 부서 코드 값이 NULL이 아니다.
SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- 부서 배치가 완료된 여자 사원수
--SELECT COUNT(*)
--FROM EMPLOYEE
--WHERE DEPT_CODE IS NOT NULL AND SUBSTR(EMP_NO, 8, 1) = '2';
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2';

-- 사수가 있는 사원수
--SELECT COUNT(*)
--FROM EMPLOYEE
--WHERE MANAGER_ID IS NOT NULL;
SELECT COUNT(MANAGER_ID)
FROM EMPLOYEE;

-- 유효한 직급의 개수
-- == 사원들 직급의 종류 개수 == 회사에 존재하는 직급의 수

SELECT COUNT(DISTINCT JOB_CODE)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 부서 코드, 생년월일, 나이(만) 조회
-- (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며
-- 나이는 주민번호에서 추출해서 날짜 데이터로 변환한 다음 계산)
-- 나이는 현재 연도 - 태어난 연도
SELECT EMP_NAME 직원명, 
       DEPT_CODE 부서코드, -- SUBSTR(EMP_NO, 1, 6) -> 문자열
       TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6)), 'YY"년" MM"월" DD"일"') 생년월일, -- XX년 XX월 XX일 
       --TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6)), 'FMYY"년" MM"월" DD"일"') XX년X월X일
    -- SUBSTR(EMP_NO, 1, 2) || '년' || SUBSTR(EMP_NO, 3, 2) || '월' || SUBSTR(EMP_NO, 5, 2) || '일'
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 6))) 나이
                                 -- EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RRRR')) 
FROM EMPLOYEE;
