-- Creating tables for datasets patients.csv, doctors.csv and visits.json in bronze.patients,
-- bronze.doctors and bronze.visits respectively. 

CREATE TABLE bronze.patients (  
    patient_id INT,
    name VARCHAR(100),
    gender VARCHAR(50),
    birth_date DATE
); 


CREATE TABLE bronze.doctors (
    doctor_id INT,
    name VARCHAR(100),
    specialty VARCHAR(100)
);


CREATE TABLE bronze.visits (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date BIGINT,			-- raw visit_date data is in integers instead of date
    diagnosis_code VARCHAR(50),
    duration_min INT,
    visit_type VARCHAR(50),
    cost_usd DECIMAL(10, 2)
);
-- However, visits.json can be imported using MySQL Shell. 
-- >>>Action Failed succesfully! haha. Beginner's challenges.
-- Attempting loading json into MySQL using python: connecting python to MySQL from python.
-- >>> Action failed! low capacity in python skills. 






