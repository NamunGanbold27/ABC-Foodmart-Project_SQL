#ABC Foodmart SQL Database Project

This repository contains the final project for APAN5310 (SQL & Data Management), where we designed and implemented a relational database system for ABC Foodmart, a growing grocery chain expanding from 2 to 5 locations. The project includes database schema design, sample data, ER diagram, documentation, and final deliverables.

##Project Overview
**Business Problem:** ABC Foodmart relied on spreadsheets and manual processes, leading to errors, data silos, and poor decision-making as the business scaled.  
**Solution:** Designed a PostgreSQL relational database in Third Normal Form (3NF) with 16+ interconnected tables. Implemented triggers for automation, developed ETL scripts to transform raw spreadsheets into the new schema, and built interactive dashboards for executives.  
**Key Deliverables:**  
- ER diagram (schema visualization)  
- SQL code for schema, constraints, and triggers  
- Sample datasets for demonstration  
- Written report and final presentation slides  

##Features
- Database Schema: Covers locations, employees, staffing, customers, products, suppliers, sales, inventory, deliveries, promotions, expenses, and returns.  
- Automation with Triggers: Updates sales totals, adjusts inventory on sales/deliveries, sets expiration dates, and monitors delivery status.  
- ETL Pipeline: Python scripts (described in docs) extract, transform, and load Excel/CSV files into PostgreSQL.  
- Analytics & KPIs: SQL queries and dashboards measure profitability, seasonal sales trends, supplier reliability, and customer loyalty.  
- Dashboards: Built in Metabase to provide executives with real-time financial and operational insights.  

**Requirements:**  
- PostgreSQL 13+  
- Python 3.x (for ETL, optional)  
- Metabase (optional, for dashboards)  

**Setup:**  
1. Clone this repository:  
   git clone https://github.com/your-username/abc-foodmart-sql-database.git  
   cd abc-foodmart-sql-database/sql  

2. Run the schema file in PostgreSQL:  
   \i code.sql  

3. Load sample CSVs from the `data/` folder for testing.  

4. (Optional) Explore dashboards in Metabase by connecting to your database.  

##Results & Insights
- Enabled profitability tracking per store and product.  
- Improved supplier performance monitoring (late deliveries, return rates).  
- Found seasonal sales patterns (e.g., ice cream in summer, steady soda sales).  
- Customer loyalty rate exceeded 60% repurchase, far above industry averages.  

##Contributors
- Namun Ganbold  
- Sara Shreim  
- Jaejun Lee  
- Min Sung Kim  

## 📜 License
This project is for academic purposes (Columbia University, APAN5310).
