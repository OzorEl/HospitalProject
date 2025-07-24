-- =========================
-- = MY HOSPITAL PROJECT   =
-- =========================

-- Creating schemas for datasets Patients.csv, doctors.csv and visits.json
-- NOTE: one dataset (i.e. visits) has a json file extension. in order to work seamlesly with other csv datasets in MySQL,
-- therefore, we need to import correctly.

-- first of all, we create a database connection 'MyProject'.
-- Then we create schemas for our datasets. In this project we'd be using the Medallion Modurality i.e. Bronze, Silver and Gold.

-- Create Schemas
CREATE SCHEMA bronze;

CREATE SCHEMA silver;

CREATE SCHEMA gold;

-- in script Bronze.sql we defined the tables for the datasets. Data imported using table import wizard for csv files and MySQL Shell for json.

select * from bronze.patients;

select * from bronze.doctors;

-- ===================================================================================================================
-- After failing to import json using MySQL shell and python, i converted json files using online tool. :)
-- ===================================================================================================================

select * from bronze.visits;

-- All tables have been loaded into the schema succesfully. Now perform an EDA!

