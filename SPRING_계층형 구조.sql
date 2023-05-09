SELECT *
FROM REPLY R
LEFT JOIN MEMBER M ON R.REPLY_WRITER = M.USER_NO
WHERE REF_BNO = 44 AND R.STATUS = 'Y'
START WITH PARENT_REPLY_NO IS NULL
CONNECT BY PRIOR REPLY_NO = PARENT_REPLY_NO
ORDER SIBLINGS BY REPLY_NO;
/*
    계층형 쿼리(START WITH, CONNECT BY, ORDER SIBLINGS BY)
    - 상위 타입과 하위 타입 간의 관계를 계층식으로 표현할 수 있게 하는 SELECT문법
    
    - START WITH : 상위 타입(최상위 부모)으로 사용할 행을 지정(서브쿼리로도 작성 가능)
    
    - CONNECT BY => 상위 타입과 하위 타입의 관계를 규정
                 => PRIOR(이전) 연산자와 같이 사용하여 현재 행 이전에 상위 타입 또는 하위 타입이 있을지 규정
                 
                 1) 부모 -> 자식 계층 구조
                    CONNECT BY PRIOR 자식 칼럼 = 부모 칼럼
                    
                    자식 -> 부모 계층 구조
                 2) CONNECT BY PRIOR 부모 컬럼 = 자식 컬럼
                 
    - ORDER SIBLINGS BY : 계층 구조를 정렬 시켜주는 구문
    
    ** 계층형 쿼리가 적용된 SELECT문 해석 순서 **
    
    5 : SELECT
    1 : FROM(+JOIN)
    4 : WHERE
    2 : START WITH
    3 : CONNECT BY
    6 : ORDER SIBLINGS BY
    
    - WHERE절이 계층형 쿼리보다 해석 순서가 늦기 때문에 먼저 조건을 반영하고 싶은 경우 FROM절에 서브 쿼리를 이용할 것
*/