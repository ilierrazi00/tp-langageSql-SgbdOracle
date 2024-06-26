-- Fonction 1 : GET_NB_WORKERS
CREATE FUNCTION GET_NB_WORKERS(FACTOR NUMBER) RETURN NUMBER IS
worker_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO worker_count
    FROM WORKERS_FACTORY_1
    WHERE factory_id = FACTOR;
    RETURN worker_count;
END;

-- Fonction 2 : GET_NB_BIG_ROBOTS
CREATE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER IS
big_robots_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO big_robots_count
    FROM ROBOTS_HAS_SPARE_PARTS
    GROUP BY robot_id
    HAVING COUNT(spare_part_id) > 3;
    RETURN big_robots_count;
END;

-- Fonction 3 : GET_BEST_SUPPLIER
CREATE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2(100) IS
best_supplier_name VARCHAR2(100);
BEGIN
    SELECT name INTO best_supplier_name
    FROM BEST_SUPPLIERS
    WHERE ROWNUM = 1;
    RETURN best_supplier_name;
END;

-- Procedure 1 : SEED_DATA_WORKERS
CREATE PROCEDURE SEED_DATA_WORKERS(NB_WORKERS NUMBER, FACTORY_ID NUMBER) AS
BEGIN
    FOR i IN 1..NB_WORKERS LOOP
        INSERT INTO WORKERS_FACTORY_1 (first_name, last_name, first_day)
        VALUES ('worker_f_' || i, 'worker_l_' || i, (SELECT TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2065-01-01','J'), TO_CHAR(DATE '2070-01-01','J'))), 'J') FROM DUAL));
    END LOOP;
END;

-- Procedure 2 : ADD_NEW_ROBOT
CREATE PROCEDURE ADD_NEW_ROBOT(MODEL_NAME VARCHAR2(50)) AS
BEGIN
    INSERT INTO ROBOTS (model)
    VALUES (MODEL_NAME);
END;
