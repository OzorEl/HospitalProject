-- =================================================================
-- == 				Tests, Expectations and Assumptions						  ==
-- =================================================================

/*
						Script Purpose:
	This script stores the logic and assumptions of the performed EDA during the cleaning 
    and Transformation of the Bronze layer data leading to the creation of the 'silver' 
    schema tables from the 'bronze' schema.
    
    Consider this a rough sheet for my logic building.
        
        */
-- ==================================================================
-- 					BRONZE.PATIENTS TABLE
-- ==================================================================
select * from bronze.patients;

-- Checking uniqueness of patient_id
SELECT 
    patient_id, 
    COUNT(patient_id) AS count  -- counting the number of patient_id entry in the column 'patient_id' (repeated/duplicate entries)
FROM
    bronze.patients
GROUP BY patient_id				-- Assumption; running the query to this point should return all patient_id with 1 count
having
    COUNT(patient_id) > 1
    -- results returned 0 rows indicating patient_id is unique to each entry.
    

-- ==========================================================================================
/*			 In this case using cte or subquery make the query complex to read, 
			even after ChatGPT corrects the code. below is a failed cte and subquery attempt. 
 */
select Patient_id, count(select count(patient_id) from bronze.patients) from bronze.patients group by patient_id having count > 1
    
-- ==========================================================================================

-- Checking for nulls, empty value, unknowns etc in patients_id.
SELECT 
    *
FROM
    bronze.patients
WHERE
    patient_id is NULL
    or patient_id = ''
    or patient_id = 'Nan'
    or patient_id = 'n/a'
    or patient_id = 'unknown';
-- results returned 0 rows, indicating that there are no nulls in the column. 

-- Checking for spaces, errors/mispellings, invalid formats, unknowns, nulls in name column. 
-- Assumption: We expect all names as 'Firstname Lastname' (e.g. 'John Doe'). 
-- The format 'Firstname Lastname' is defined as '^[A-Z][a-z]+ [A-Z][a-z]+$'.
SELECT *
FROM bronze.patients
WHERE name NOT REGEXP '^[A-Z][a-z]+ [A-Z][a-z]+$';
-- 17 out of 500 rows returned did not match the format 'Firstname Lastname'.
-- Names contains titles (Mr., Mrs., Dr.) and sufix (Jr, II, DDS, MD)
-- In order to have a clean standadised data, we can go ahead and select the name(Firstname Lastname) only.
-- On the other hand we can leave the names as is if it does not affect the use case of the data.  

-- We first remove title with 
SELECT 
    *,
    REGEXP_REPLACE(name, '^(Dr\\.|Mr\\.|Mrs\\.)\\s+', '') AS title_cleaned
FROM
    bronze.patients;

-- Then we remove the sufix 
SELECT 
    *,
    REGEXP_REPLACE(name, '\\s+(Jr\\.|DDS|II|MD)$', '') AS sufix_cleaned
FROM
    bronze.patients;

-- The combined queries should give as a clean 'Firstname Lastname' format.
SELECT 
    patient_id,
   REGEXP_REPLACE(
        REGEXP_REPLACE(name, '^(Dr\\.|Mr\\.|Mrs\\.)\\s+', ''),  -- remove title
        '\\s+(Jr\\.|DDS|II|MD)$', ''                            -- remove suffix
    ) cleaned_name
FROM
    bronze.patients;

-- And now to check all the 17 rows that previously did not match the 'Firstname Lastname'.
with patient_name_cleaned as (
select patient_id,
	REGEXP_REPLACE(
        REGEXP_REPLACE(name, '^(Dr\\.|Mr\\.|Mrs\\.)\\s+', ''),  -- remove title
        '\\s+(Jr\\.|DDS|II|MD)$', ''                            -- remove suffix
    ) AS name_cleaned
from bronze.patients
)
SELECT bp.patient_id,
	name,
	p.name_cleaned
from bronze.patients as bp
left join patient_name_cleaned as p
on bp.patient_id = p.patient_id
WHERE name NOT REGEXP '^[A-Z][a-z]+ [A-Z][a-z]+$'
order by p.name_cleaned;
-- From the results returned we can see that the prefix and sufix are filtered out of the result returned. 

/*                 				THINGS TO NOTE: REGEXP_REPLACE function 
	Single \ doesnt filter out all titles in the column whereas double \\ filters all entries in the column.
    The period(.) was escaped from the title and sufix.
*/
-- Trim function will be added to the function to ensure that all spaces are trimmed. 


-- Checking string gender
SELECT gender
FROM bronze.patients  
WHERE gender IS NULL
 OR TRIM(gender) = '';      
-- no nulls, empty space
 
SELECT DISTINCT gender FROM bronze.patients  
-- results returned 3 rows (i.e. Male, Female, Other), shows column is quite clean with no mispelling, unknowns or abbreviations.
-- Again, depending on the data use case we can describe the 'other' values but in this case we leave it as is.



-- To chech date column for texts, invalid dates, nulls, empty etc.
-- We can check if a birth_date is in date format by simply using DESCRIBE;
DESCRIBE bronze.patients;
-- From result returned we found birth_date as text/string and not date format. 
-- We will go ahead and convert to date yyyy-mm-dd format
SELECT 
  birth_date,
  STR_TO_DATE(birth_date, '%Y-%m-%d') AS converted_date
FROM bronze.patients;

-- Test for errors
SELECT birth_date, STR_TO_DATE(birth_date, '%Y-%m-%d') AS converted_date
FROM bronze.patients
WHERE STR_TO_DATE(birth_date, '%Y-%m-%d') IS NULL;
-- Result returned no error

-- =========================================================================
-- 						BRONZE.DOCTORS TABLE
-- =========================================================================

select * from bronze.doctors;

-- Checking uniqueness of doctor_id
SELECT 
    doctor_id, 
    COUNT(doctor_id) AS count  -- counting the number of doctor_id entry in the column 'doctor_id' (repeated/duplicate entries)
FROM
    bronze.doctors
GROUP BY doctor_id				-- Assumption; running the query to this point should return all doctor_id with 1 count
having
    COUNT(doctor_id) > 1;
    -- results returned 0 rows indicating doctor_id is unique to each entry.

SELECT 
    *
FROM
    bronze.doctors
WHERE
    doctor_id is NULL
    or doctor_id = ''
    or doctor_id = 'Nan'
    or doctor_id = 'n/a'
    or doctor_id = 'unknown';
    -- results returned 0 rows, indicating that there are no nulls in the column. 
    
    

-- Checking for spaces, errors/mispellings, invalid formats, unknowns, nulls in name column. 
-- Assumption: We expect all names as 'Firstname Lastname' (e.g. 'John Doe'). 
-- The format 'Firstname Lastname' is defined as '^[A-Z][a-z]+ [A-Z][a-z]+$'.
SELECT *
FROM bronze.doctors
WHERE name NOT REGEXP '^[A-Z][a-z]+ [A-Z][a-z]+$';
-- 3 out of 100 rows returned did not match the format 'Firstname Lastname'.
-- Names contains titles as sufix (DDS, MD)
-- In order to have a clean standadised data, we can go ahead and select the name(Firstname Lastname) only. 
-- We remove the sufix 
SELECT 
    doctor_id,
    name,
    REGEXP_REPLACE(name, '\\s+(Jr\\.|DDS|II|MD)$', '') AS sufix_cleaned
FROM
    bronze.doctors;
    

-- And now to check all the 3 rows that previously did not match the 'Firstname Lastname'.
with doctor_name_cleaned as (
select doctor_id,
	REGEXP_REPLACE(name, '\\s+(Jr\\.|DDS|II|MD)$', '') AS name_cleaned
from bronze.doctors
)
SELECT bp.doctor_id,
	name,
	p.name_cleaned
from bronze.doctors as bp
left join doctor_name_cleaned as p
on bp.doctor_id = p.doctor_id
WHERE name NOT REGEXP '^[A-Z][a-z]+ [A-Z][a-z]+$'
order by p.name_cleaned;
-- From the results returned we can see that sufix are clean. 


SELECT DISTINCT specialty FROM bronze.doctors;
-- Results returned all specialty without cases of unknowns, n/a, null, abbreviations.
-- data in specialty is clean



-- =========================================================================
-- 						BRONZE.VISITS TABLE
-- =========================================================================

select * from bronze.visits;


-- Checking uniqueness of visit_id
SELECT 
    visit_id, 
    COUNT(visit_id) AS count  -- counting the number of visit_id entry in the column 'visit_id' (repeated/duplicate entries)
FROM
    bronze.visits
GROUP BY visit_id				-- Assumption; running the query to this point should return all visit_id with 1 count
having
    COUNT(visit_id) > 1
    -- results returned 0 rows indicating visit_id is unique to each entry.
    
    
    -- Checking for nulls, empty value, unknowns etc in visits_id.
SELECT 
    *
FROM
    bronze.visits
WHERE
    visit_id is NULL
    or visit_id = ''
    or visit_id = 'Nan'
    or visit_id = 'n/a'
    or visit_id = 'unknown';
    -- results returned 0 rows, indicating that there are no nulls in the column. 
    
-- The column visit_date contains big numbers instead of formated dates. 
-- Convert the figure into dates

select
	visit_id,
	date(FROM_UNIXTIME(visit_date / 1000)) AS visit_date_updated
from
	bronze.visits

-- testing for date format
SELECT *
FROM
	(SELECT
	visit_id,
	DATE(FROM_UNIXTIME(visit_date / 1000)) AS visit_date_updated
FROM
	bronze.visits
) t
WHERE visit_date_updated IS NULL
-- As expected the were no rows returned indication that no nulls were created in converting the unix code to date '%Y-%m-%d' 



-- Per best practise it is best to eliminate hyphen in our data. This makes it easier when searching.
SELECT
	diagnosis_code
FROM bronze.visits

-- Check if diagnosis_code values are in the same format (e.g. 'ABC-01.23')
SELECT *
FROM bronze.visits
WHERE diagnosis_code NOT REGEXP '^ICD-[0-9]{2}\\.[0-9]{2}$';

-- Replace hyphen with underscore
select
	replace(diagnosis_code, '-', '_') as clean_diagnosis
from
	bronze.visits


-- Checking for nulls, empty value, unknowns etc in duration_min column.
SELECT 
    *
FROM
    bronze.visits
WHERE
    duration_min is NULL
    or duration_min = ''
    or duration_min = 'Nan'
    or duration_min = 'n/a'
    or duration_min = 'unknown';
-- results returned 0 rows, indicating that there are no nulls in the column. 

-- Checking for spaces, errors/mispellings, invalid formats, unknowns, nulls in visit_type column. 
select distinct
	visit_type
from
	bronze.visits
-- Result returned clean values
