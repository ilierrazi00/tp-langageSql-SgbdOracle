-- Trigger pour ALL_WORKERS_ELAPSED
CREATE TRIGGER TRG_INSERT_WORKERS
BEFORE INSERT ON ALL_WORKERS_ELAPSED
FOR EACH ROW
BEGIN
    INSERT INTO WORKERS_FACTORY_1 (first_name, last_name, age, first_day)
    VALUES (:NEW.firstname, :NEW.lastname, :NEW.age, :NEW.start_date);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insert not allowed here.');
END;


-- Trigger pour l'audit des robots
CREATE TRIGGER TRG_ROBOT_AUDIT
AFTER INSERT ON ROBOTS
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_ROBOT (robot_id, created_at)
    VALUES (:NEW.id, SYSDATE);
END;


-- Trigger pour la cohérence des usines
CREATE TRIGGER TRG_CHECK_FACTORY_DATA
BEFORE UPDATE OR DELETE ON ROBOTS_FACTORIES
DECLARE
    factory_count NUMBER;
    worker_factory_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO factory_count FROM FACTORIES;
    SELECT COUNT(*) INTO worker_factory_count FROM WORKERS_FACTORY_1;

    IF factory_count != worker_factory_count THEN
        RAISE_APPLICATION_ERROR(-20002, 'Mismatch in factory and worker data.');
    END IF;
END;
