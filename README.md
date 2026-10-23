World Layoffs — Data Cleaning and Exploratory Data Analysis with MySQL

Project Overview
This project uses MySQL to clean and explore a dataset of company layoffs. It focuses on preparing the data for analysis and identifying patterns in reported layoffs across companies, industries, funding stages, countries and time periods.
The project demonstrates practical SQL skills in data preparation, data quality checks, aggregation, date functions, joins, Common Table Expressions (CTEs) and window functions.

Objectives :
Prepare a staging dataset for analysis.
Identify and remove duplicate records.
Standardise inconsistent company, industry, location and country values.
Handle missing values where appropriate.
Analyse reported layoffs by company, year, industry, funding stage and month.
Identify companies with the highest reported layoff totals.
Rank companies by total layoffs within each year.

Tools and Technologies :
Database: MySQL
Language: SQL

Version control and portfolio: GitHub

Project Structure

World Layoffs - Data Cleaning and Analysis SQL Project.sql — SQL script containing the data cleaning workflow and exploratory analysis queries.

1. Data Cleaning :The data cleaning workflow uses staging tables to preserve the original dataset and prepare a separate working copy.

The main steps include:
Staging tables: Created copies of the original table for cleaning and analysis.
Duplicate identification: Used ROW_NUMBER() with PARTITION BY to identify records with matching values across selected columns.
Duplicate removal: Removed additional matching records from the cleaned staging table.
Text standardisation: Trimmed leading spaces from company names and standardised selected industry, country and location values.
Missing-value handling: Converted empty industry values to NULL and populated missing industry values using matching company records where appropriate.
Record filtering: Removed records where both total layoffs and layoff percentage were missing.
Data preparation: Converted date strings into date values for temporal analysis.

2. Exploratory Data Analysis (EDA)

The analysis investigates the following questions:
Which company recorded the highest number of layoffs in an individual record?
Which companies reported laying off 100% of their workforce, and how much funding had they raised?
Which companies had the largest individual reported layoff counts?
Which companies had the highest cumulative layoff totals?
How did total reported layoffs vary by year?
Which industries recorded the highest layoff totals?
Which funding stages accounted for the largest reported layoff totals?
Which calendar months had the highest combined layoff totals across the dataset?
Which companies had the highest total layoff counts within each year?

SQL Concepts Demonstrated
SELECT, WHERE, ORDER BY and LIMIT
Aggregate functions: SUM(), MAX() and COUNT()
GROUP BY and HAVING
String functions: TRIM(), LTRIM(), SUBSTRING() and LIKE
Date functions: STR_TO_DATE(), YEAR() and MONTHNAME()
CASE-independent conditional filtering and data updates
Self-joins for handling missing values
Common Table Expressions (CTEs)
Window functions: ROW_NUMBER() and DENSE_RANK()
Subqueries and table creation

Key Findings

This section will document the main findings obtained by executing the SQL queries.

Company-level findings: Google had the highest cumulative reported layoffs, which was 12,000.
Time-based findings: Uber had the highest layoffs in 2020 with 7525,Bytedance	in 2021 with 3600, Meta in 2022 with 11000,Google in	2023 with 12000.
Industry-level findings: The Consumer,Retail,Transportation, Finance and Healthcare industries were amongst the highest in terms of layoffs in.
Funding-stage findings: Most People were laid off in the Post IPO, Acquired and Series C stages.

Limitations

The analysis reflects the records available in the dataset and may not represent every layoff event.
Missing values and differences in reporting coverage may affect comparisons.
Removing records with missing layoff counts and percentages may exclude events that still contain other useful information.
The analysis identifies patterns in reported layoffs but does not establish the causes of those layoffs.
The results depend on the accuracy of the original data and the cleaning assumptions applied.

How to Run the Project
Set up a MySQL database and obtain the original dataset.
Import the original data into a table named layoffs.
Open the SQL project file in MySQL Workbench or another compatible MySQL client.
Execute the script in order, starting with the staging-table creation and data cleaning steps.
Review the EDA queries and their results.

Note: The script creates and modifies tables. Run it in a suitable development database, and reset the staging tables as needed before rerunning it.

Author
Tony Richard Raguraman
www.linkedin.com/in/trr135
