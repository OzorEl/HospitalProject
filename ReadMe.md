### Data Warehouse and Analytics Project

Welcome to my **HospitalProject** repository!  
This project demonstrates data warehousing and analytics solution, from building a data warehouse to generating actionable insights. 

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

📁 My Hospital Project – Data Engineering Pipeline
This project involves building a data pipeline for hospital-related datasets using MySQL. The datasets include:

patients.csv

doctors.csv

visits.json

To manage these datasets efficiently and ensure seamless integration—especially for the JSON-formatted visits dataset—we follow a structured ingestion process.

We begin by establishing a database connection named MyProject, and then define schemas for each dataset.


## 🏗️ Data Architecture
The project adopts the Medallion Architecture (Bronze, Silver, and Gold layers) to support modularity, data quality, and scalability:

**Bronze Layer**: Raw data ingestion

**Silver Layer**: Cleaned and structured data

**Gold Layer**: Aggregated and analytics-ready data

This modular design ensures data flows smoothly from raw input to meaningful insights.


## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Datasets used for the project (doctors.csv, patients.csv and visits.json data)
│
├── docs/                               # Project documentation
│   ├── Questions/
│     ├──Hospital_ETL_Problem_Statement # Pdf files contain project brief
│     ├──Hospital_SQL_Questions_Only    # Pdf file containing requested insight from the dataset
│   ├── Answers/
│     ├── Q. 1 - 15                     # Csv files containing query results from generated insights
│
├── scripts/                            # Contains sql scripts
│   ├── Initialising/                   # This script sets up the foundational schemas for a hospital data project in MySQL
│   ├── Bronze/                         # This script creates tables in the bronze schema
│   ├── Test_and_Assumptions/           # Outlines EDA, data validation, and cleaning logic applied to the bronze layer
│   ├── Silver/                         # Transformation and loading of cleaned data from the bronze schema into the silver schema
│   ├── Gold/                           # Creates the gold layer views into business-friendly, analysis-ready structures
│   ├── Analytics/                      # This script generates business insights by answering key analytical questions
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├
├
└── requirements.txt                    # Dependencies and requirements for the project




## 👤 About Me

I am a data enthusiast with a strong interest in building efficient and scalable data pipelines that transform raw data into actionable insights. This project showcases my ability to apply industry-standard data engineering practices—specifically, implementing the **Bronze-Silver-Gold architecture**—to clean, structure, and analyze healthcare data.

Through this hospital dataset, I designed and developed SQL-based pipelines that:

- Ingested and standardized raw data into a **bronze layer**.
- Applied cleaning, formatting, and transformation logic in the **silver layer**.
- Delivered analytics-ready views in the **gold layer** to support business decision-making.

This project not only demonstrates my SQL proficiency and understanding of data warehousing, but also my ability to think analytically and align data models to business goals. I’m passionate about turning data into insights, and this project reflects that drive.

---

### 📫 Contact Me

- 💼 [LinkedIn](https://www.linkedin.com/in/eliezer-ozor)
- 💻 [GitHub](https://github.com/OzorEl)
- 📧 **Email:** ozoryoung@gmail.com


```
---