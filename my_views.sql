-- Vue 1: ALL_WORKERS
CREATE VIEW ALL_WORKERS AS
SELECT 
    last_name AS lastname, 
    first_name AS firstname, 
    age, 
    COALESCE(start_date, first_day) AS start_date
FROM 
    WORKERS_FACTORY_1
WHERE 
    last_day IS NULL
UNION
SELECT 
    last_name AS lastname, 
    first_name AS firstname, 
    NULL AS age, 
    start_date
FROM 
    WORKERS_FACTORY_2
WHERE 
    end_date IS NULL
ORDER BY 
    start_date DESC;

-- Vue 2: ALL_WORKERS_ELAPSED
CREATE VIEW ALL_WORKERS_ELAPSED AS
SELECT 
    firstname, 
    lastname, 
    TRUNC(SYSDATE - start_date) AS days_elapsed
FROM 
    ALL_WORKERS;


-- Vue 3: BEST_SUPPLIERS
CREATE VIEW BEST_SUPPLIERS AS
SELECT 
    s.name, 
    SUM(sb.quantity) AS total_pieces
FROM 
    SUPPLIERS s
JOIN 
    SUPPLIERS_BRING_TO_FACTORY_1 sb ON s.supplier_id = sb.supplier_id
GROUP BY 
    s.name
HAVING 
    SUM(sb.quantity) > 1000
ORDER BY 
    total_pieces DESC;

-- Vue 4: ROBOTS_FACTORIES
CREATE VIEW ROBOTS_FACTORIES AS
SELECT 
    r.model, 
    f.main_location AS factory_location
FROM 
    ROBOTS r
JOIN 
    ROBOTS_FROM_FACTORY rf ON r.id = rf.robot_id
JOIN 
    FACTORIES f ON rf.factory_id = f.id;
