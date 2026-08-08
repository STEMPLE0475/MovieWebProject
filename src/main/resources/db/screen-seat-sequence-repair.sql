-- 기존 T_SCREEN_SEAT 데이터의 최대 ID 다음 값으로 SCREEN_SEAT_SEQ를 맞춥니다.
-- ORA-00001 (SCREEN_SEAT_ID PK 중복) 발생 후 한 번 실행하세요.
DECLARE
    v_max_id NUMBER;
    v_next_id NUMBER;
    v_increment NUMBER;
BEGIN
    SELECT NVL(MAX(SCREEN_SEAT_ID), 0) INTO v_max_id FROM T_SCREEN_SEAT;
    SELECT SCREEN_SEAT_SEQ.NEXTVAL INTO v_next_id FROM DUAL;

    IF v_next_id <= v_max_id THEN
        v_increment := v_max_id - v_next_id + 1;
        EXECUTE IMMEDIATE 'ALTER SEQUENCE SCREEN_SEAT_SEQ INCREMENT BY ' || v_increment;
        SELECT SCREEN_SEAT_SEQ.NEXTVAL INTO v_next_id FROM DUAL;
        EXECUTE IMMEDIATE 'ALTER SEQUENCE SCREEN_SEAT_SEQ INCREMENT BY 1';
    END IF;
END;
/
