# ABC Foodmart SQL Database Project

This project was developed as part of Columbia University’s APAN5310 course.  
Our team designed and implemented a relational database for **ABC Foodmart**, a growing grocery chain expanding from 2 to 5 locations.  

## Project Overview
- **Business Problem:** ABC Foodmart relied on spreadsheets, leading to errors and poor decision-making:contentReference[oaicite:4]{index=4}.  
- **Solution:** Designed a **PostgreSQL database** in 3NF with 16+ tables, automated triggers, and an ETL pipeline for data migration.  
- **Deliverables:** SQL schema, ER diagram, sample data, analytical queries, and executive dashboards.

## Repository Structure
- `sql/` – Database schema (DDL), triggers, constraints:contentReference[oaicite:5]{index=5}  
- `data/` – Sample mock datasets (CSV) used for testing  
- `docs/` – Project report, slides, ER diagram:contentReference[oaicite:6]{index=6}:contentReference[oaicite:7]{index=7}:contentReference[oaicite:8]{index=8}  
- `README.md` – Project overview and instructions  

## Key Features
- **Schema Design:** 16 normalized tables covering employees, sales, products, suppliers, customers, inventory, returns, and promotions.  
- **Triggers & Automation:** Real-time updates for sales totals, inventory adjustments, delivery statuses.  
- **ETL Pipeline:** Python-based scripts used to transform Excel/CSV input into the PostgreSQL schema.  
- **Analytics:** SQL queries for profitability, sales seasonality, supplier performance, and customer loyalty.  
- **Dashboards:** Metabase dashboards with KPIs for executives.

## Getting Started
1. Clone repo:
   ```bash
   git clone https://github.com/your-username/abc-foodmart-sql-database.git
   cd abc-foodmart-sql-database/sql
