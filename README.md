# 🚀 Retail Analytics with dbt and Snowflake

## 📌 Prerequisites
- **DBT Core** installed ([Installation Guide](https://docs.getdbt.com/docs/core/installation))
- **VS Code && dbt Power User Extension**
- **Snowflake** account and credentials
- **Git && GitHub (for version control)**
- **Looker Studio (for dashboarding)**

## ❄️ Snowflake Related Setup
### 🛠️ Create an S3 Bucket and Upload CSV Files
Refer to AWS documentation or a tutorial on how to integrate AWS S3 with Snowflake.

### 🔗 Setting up AWS Integration:
```sql
USE WAREHOUSE ECOMMERCE_WH;

CREATE OR REPLACE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = '<YOUR_AWS_ROLE>'
  STORAGE_ALLOWED_LOCATIONS = ('s3://your-bucket/Assignment1/','s3://your-bucket/Assignment1_json/')
  COMMENT = 'This is for assignment1 Snowflake';
```

### 🏗️ Setting Up Data:
```sql
CREATE DATABASE Retail_Analytics_dbt;
USE DATABASE Retail_Analytics_dbt;
CREATE SCHEMA ecommerce;

CREATE WAREHOUSE ecommerce_wh_dbt WITH 
    WAREHOUSE_SIZE = 'X-SMALL' 
    AUTO_SUSPEND = 60 
    AUTO_RESUME = TRUE;

USE WAREHOUSE ecommerce_wh_dbt;

CREATE OR REPLACE TABLE Retail_Analytics_dbt.ecommerce.raw_retail_data (
    InvoiceNo STRING,
    StockCode STRING,
    Description STRING,
    Quantity INTEGER,
    InvoiceDate TIMESTAMP,
    UnitPrice FLOAT,
    CustomerID STRING,
    Country STRING
);
```

### 📤 Creating External Stage and Loading Data:
```sql
CREATE OR REPLACE STAGE Retail_Analytics_dbt.external_stages.csv_folder
    URL = 's3://your-bucket/Assignment1/'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = Retail_Analytics_dbt.file_formats.csv_fileformat;

COPY INTO Retail_Analytics_dbt.ecommerce.raw_retail_data
FROM (
    SELECT 
        $1::STRING AS InvoiceNo,
        $2::STRING AS StockCode,
        $3::STRING AS Description,
        $4::INTEGER AS Quantity,
        TO_TIMESTAMP($5, 'MM/DD/YY HH24:MI') AS InvoiceDate, 
        $6::FLOAT AS UnitPrice,
        $7::STRING AS CustomerID,
        $8::STRING AS Country
    FROM @Retail_Analytics_dbt.external_stages.csv_folder
    (FILE_FORMAT => Retail_Analytics_dbt.file_formats.csv_fileformat)
);      
```

### **3. Configure DBT Profiles**
### **Location of profiles.yml:**
```sh
C:\Users\YourUsername\.dbt\profiles.yml
```

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




## 📊 Model Descriptions
### **1. Staging Layer**
- `raw_retail.sql`: Taking raw transaction data into a dbt model for further transformations

### **2. Intermediate Layer**
- `retail_cleansed.sql`: Cleaning raw_retail (trims text, removes nulls, filters out invalid values and removes duplicates).

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

## 🚀 Running Tests and Models
- Run all models:
  ```sh
  dbt run
  ```
- Run tests to validate transformations:
  ```sh
  dbt test
  ```
- Run a specific model:
  ```sh
  dbt run --select <model-name>
  ```
- Run incremental models:
  ```sh
  dbt run --full-refresh
  ```

## 🔄 Setting Up GitHub Actions for CI/CD
To automate `dbt run` and `dbt test` on every commit:
1. Create `.github/workflows/dbt-ci.yml` with:
```yaml
   name: "DBT CI/CD Pipeline"

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:  # Allows manual execution

jobs:
  dbt-ci-cd:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: "3.9"

      - name: Install DBT & Snowflake Adapter
        run: |
          pip install dbt-core dbt-snowflake

      - name: Configure DBT Profiles
        run: |
          mkdir -p ~/.dbt
          echo "${{ secrets.DBT_PROFILES }}" > ~/.dbt/profiles.yml

      - name: Install DBT Dependencies
        run: dbt deps

      - name: Run DBT Tests
        run: dbt test  # Runs data quality tests

      - name: Run DBT Models
        run: dbt run --exclude tag:skip_ci  # Runs models except those tagged as skip_ci

      - name: Check DBT Model Performance
        run: |
          cat target/run_results.json | jq '.results[] | {model: .unique_id, time: .execution_time}'

```
2. **Secure your credentials**: Store sensitive values (like Snowflake credentials) in **GitHub Secrets** instead of hardcoding them.
3. Commit and push the workflow file to trigger automated runs.

## 🔗 Integrations
### **1. Looker Studio Dashboard**
- Connected Snowflake to Looker Studio for real-time analytics.
- Includes KPI scorecards, sales trends, and customer segmentation.
- For exposure_dashboard replace the link with your report link =

## 📈 Key Findings
- Data cleansing and transformations ensure consistency and reliability.
- Snowflake optimizations, such as clustering by `InvoiceNo`, improve query performance.
- Integrating dbt with GitHub Actions enables automated testing and deployment.
- Looker Studio dashboards provide actionable insights based on transformed data.
