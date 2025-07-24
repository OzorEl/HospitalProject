
/*
						Script Purpose:
	This stored procedure performs the Cleaning and Transformation process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
        
        
        */

-- =================================
-- 	CLEAN AND LOAD SILVER.PATIENTS DATA
-- =================================

CREATE TABLE silver.patients (  
    patient_id INT,
    name VARCHAR(100),
    gender VARCHAR(50),
    birth_date DATE
); 

INSERT INTO silver.patients
(patient_id, name, gender, birth_date)
SELECT 
	patient_id,							-- since no anomaly was found (refer to test script) on this column.
	TRIM( REGEXP_REPLACE(
        REGEXP_REPLACE(name, '^(Dr\\.|Mr\\.|Mrs\\.)\\s+', ''),  -- remove title
        '\\s+(Jr\\.|DDS|II|MD)$', ''                            -- remove suffix
    )) name,
    TRIM(gender) gender,
    STR_TO_DATE(birth_date, '%Y-%m-%d') AS birth_date			-- Converts birth_date in text/string to date format
FROM 
	bronze.patients							
    
-- explore table created
SELECT * FROM silver.patients
    
    

-- =================================
-- 	CLEAN AND LOAD SILVER.DOCTORS DATA	
-- =================================
 
 CREATE TABLE silver.doctors (
    doctor_id INT,
    doctor_name VARCHAR(100),
    specialty VARCHAR(100)
);
 
INSERT INTO silver.doctors
(doctor_id, doctor_name, specialty)
SELECT
	doctor_id,
    TRIM(REGEXP_REPLACE(name, '\\s+(Jr\\.|DDS|II|MD)$', '')) doctor_name,
    specialty
FROM 
	bronze.doctors
    
-- explore table created
SELECT * FROM silver.doctors


 
-- =================================
-- CLEAN AND LOAD SILVER.VISITS DATA
-- =================================

 CREATE TABLE silver.visits (
    visit_id INT,
    patient_id INT,
    doctor_id INT,
    visit_date DATE,			
    diagnosis_code VARCHAR(50),
    duration_min INT,
    visit_type VARCHAR(50),
    cost_usd DECIMAL(10, 2)
);
INSERT INTO silver.visits
(visit_id, patient_id, doctor_id, visit_date, diagnosis_code, duration_min, visit_type, cost_usd)
SELECT
	visit_id,
    patient_id,
	doctor_id,
    date(FROM_UNIXTIME(visit_date / 1000)) AS visit_date,
	trim(replace(diagnosis_code, '-', '_')) as diagnosis_code,
    duration_min,
    trim(visit_type) as visit_type,
    cost_usd
FROM
	bronze.visits

-- explore table created
SELECT * FROM silver.visits

-- =========================================================
-- ===================-----===============-----=============
 
 
 
 