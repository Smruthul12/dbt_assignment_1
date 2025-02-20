# DBT Retail Analytics Project

## 📌 Overview
This **DBT project** transforms raw retail transaction data into insightful reports and dashboards using **Snowflake** as the data warehouse. The transformed data powers analytics in **Looker Studio**, providing valuable insights into sales performance, customer behavior, and product trends.

## 🚀 Setup Instructions
### **1. Prerequisites**
- **DBT Core** installed ([Installation Guide](https://docs.getdbt.com/docs/core/installation))
- **Snowflake** account and credentials
- **GitHub (for version control)**
- **Looker Studio (for dashboarding)**

### **2. Clone the Repository**
```sh
git clone https://github.com/your-repo/dbt-retail-analytics.git
cd dbt-retail-analytics
```

### **3. Configure DBT Profiles**
Edit `profiles.yml` (usually found at `~/.dbt/profiles.yml` or in your project directory):
```yml
retail_analytics:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_snowflake_account
      user: your_user
      password: your_password
      role: your_role
      database: your_database
      warehouse: your_warehouse
      schema: your_schema
      threads: 4
      client_session_keep_alive: False
```

### **4. Install DBT Dependencies**
```sh
dbt deps
```

### **5. Run DBT Models**
```sh
dbt run
```
To run a specific model (e.g., `facts_sales`):
```sh
dbt run --select facts_sales
```

### **6. Test and Document Models**
```sh
dbt test
```
```sh
dbt docs generate && dbt docs serve
```

---

## 📂 Project Structure
```
/dbt_project
│── models
│   ├── staging/
│   │   ├── raw_retail.sql  # Cleans raw data
│   ├── intermediate/
│   │   ├── retail_cleansed.sql  # Standardized, validated data
│   ├── marts/
│   │   ├── dimensions/
│   │   │   ├── customer_details.sql
│   │   │   ├── customer_segmentation.sql
│   │   │   ├── rfm_segmentation.sql
│   │   ├── facts/
│   │   │   ├── facts_sales.sql
│   │   │   ├── customer_rfm.sql
│   │   │   ├── sales_performance.sql
│   ├── audit_log.sql  # Tracks DBT model runs
├── dbt_project.yml
├── packages.yml
├── README.md
```

---

## 📊 Model Descriptions
### **1. Staging Layer**
- `raw_retail.sql`: Cleans raw transaction data (trims text, removes nulls, filters out invalid values).

### **2. Intermediate Layer**
- `retail_cleansed.sql`: Applies business rules, standardizes data, and removes duplicates.

### **3. Marts Layer**
#### **Dimensions**
- `customer_details.sql`: Enriches customer data with segmentation info.
- `customer_segmentation.sql`: Categorizes customers based on purchase behavior.
- `rfm_segmentation.sql`: Calculates **Recency, Frequency, and Monetary Value (RFM)** scores.

#### **Facts**
- `facts_sales.sql`: **(Incremental model)** Aggregates sales data for analytics.
- `customer_rfm.sql`: Combines customer details with RFM segmentation.
- `sales_performance.sql`: Analyzes sales trends and KPIs.

#### **Audit Log**
- `audit_log.sql`: Captures DBT model execution details (run time, status, user).

---

## 🔗 Integrations
### **1. Looker Studio Dashboard**
- Connected Snowflake to Looker Studio for real-time analytics.
- Includes KPI scorecards, sales trends, and customer segmentation.

### **2. CI/CD with GitHub Actions**
- Automates `dbt run` and `dbt test` on every commit.

### **3. Alerts & Notifications**
- Automated alerts for **failed DBT runs** via Slack/Email.

---

## 🚀 Future Enhancements
🔹 Implement **Snowflake Materialized Views** for faster queries.
🔹 Use **dbt snapshots** for historical tracking of customer data.
🔹 Optimize incremental models for **faster DBT runs**.

---

## 📩 Questions?
Feel free to reach out or contribute via pull requests!

---

#### **🔹 Made with 💡 and DBT**

