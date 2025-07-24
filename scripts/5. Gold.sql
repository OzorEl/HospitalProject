/*
					GOLD LAYER DATA
	1. Data in this module are created as view. 
	2. The data is created based on the business objectives and readerbility. 
	3. clearer column names are asinged at this stage.
	4. Tables are joined to make the work of the analyst easier. For instance,
    in cases where there are multiple dimension tables on customers, the same 
    tables are joined into a consolidated dimension customer table. In this case,
    however, the dimension tables are left as is because theyprovide information 
    of different areas. 
*/
-- =============================================================
-- 				PATIENT GOLD DATA 
-- =============================================================

-- reassigned clearer name in gold layer
-- creating view gold data
create view gold.dim_patients as
select
	patient_id,
    name as patient_name,
    gender as patient_gender,
    birth_date as patient_birth_date
from
	silver.patients


select * from gold.dim_patients

-- =============================================================
-- 				DOCTOR GOLD DATA 
-- =============================================================

create view gold.dim_doctors as
SELECT
	doctor_id,
    doctor_name,
    specialty
from
	silver.doctors

select * from gold.dim_doctors

-- =============================================================
-- 				VISIT GOLD DATA 
-- =============================================================

create view gold.fct_visits as
SELECT
	visit_id,
    patient_id,
    doctor_id,
    visit_date,
    diagnosis_code,
    duration_min,
    visit_type,
    cost_usd
from 
	silver.visits

select * from gold.fct_visits