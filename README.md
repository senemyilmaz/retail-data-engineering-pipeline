# Retail Data Engineering Pipeline

Analytics engineering pipeline built with **dbt** and **Google BigQuery** to transform raw retail and marketing campaign data into reliable financial analytics datasets.
This project implements a layered data modeling architecture to clean, transform, and aggregate raw operational data into business-ready financial reporting tables used by finance teams.



## Project Overview
Raw transactional data and marketing campaign data are stored in BigQuery in multiple operational tables.
However, these raw datasets are not suitable for analytical reporting because:
- schemas are inconsistent
- business metrics are not precomputed
- multiple tables must be joined
- marketing costs are stored separately from sales data
This project builds a **dbt analytics engineering pipeline** that:
- standardizes raw datasets
- computes financial metrics
- integrates marketing campaign costs
- ensures data quality through tests
- produces analytics-ready finance datasets
The final output enables the finance team to monitor **daily and monthly business performance.**

The pipeline produces finance-ready datasets that combine sales performance and marketing campaign costs, enabling financial reporting and campaign profitability analysis.

---

## Key Metrics Produced
The pipeline computes the following financial and operational metrics:

Revenue
Purchase Cost
Operational Margin
Margin
Ads Margin
Shipping Fee
Logistics Cost
Average Basket Value
Number of Orders
Ad Clicks
Marketing Campaign Cost
Ad Impressions

Metric definitions:
```
Purchase Cost = quantity × purchase_price

Margin = revenue − purchase_cost

Operational Margin =
margin + shipping_fee − log_cost − ship_cost

Ads Margin =
operational_margin − ads_cost
```

---

## Architecture
The project follows a modern analytics engineering architecture using dbt.


```
       ┌──────────┐
       │   RAW    │ Operational source tables stored in BigQuery.
       └────┬─────┘
            ↓
       ┌──────────┐
       │ STAGING  │ Standardizes raw data by renaming columns, casting data types, and cleaning fields.
       └────┬─────┘
            ↓
    ┌───────────────┐
    │ INTERMEDIATE  │ Computes business metrics and integrates datasets.
    └───────┬───────┘
            ↓
       ┌──────────┐
       │   MART   │ Produces analytics-ready datasets used by finance teams.
       └──────────┘
```

---

## Data Lineage
The pipeline integrates transactional sales data with marketing campaign data.

```
Raw Sources
├── sales
├── product
├── ship
├── adwords
├── bing
├── criteo
└── facebook

Staging Models
├── stg_raw__sales
├── stg_raw__product
├── stg_raw__ship
├── stg_raw__adwords
├── stg_raw__bing
├── stg_raw__criteo
└── stg_raw__facebook

Intermediate Models
├── int_sales_margin
├── int_orders_operational
├── int_campaigns
└── int_campaigns_day

Mart Models
├── finance_days
├── finance_campaigns_day
└── finance_campaigns_month
```

The lineage graph below illustrates how raw operational and marketing data flows through staging and intermediate models before producing finance reporting datasets.

<img width="901" height="360" alt="image" src="https://github.com/user-attachments/assets/c8a6537b-8a87-42e9-a061-3f59c1bd2d61" />

---

## Data Models
Intermediate models contain the core business logic of the pipeline and calculate key financial metrics used in downstream mart models.
### Staging Layer
The staging layer standardizes raw datasets and prepares them for downstream transformations.

Typical transformations include:

- Column renaming
- Data type casting
- Schema normalization
- Basic data cleaning

Examples:

```
pdt_id → products_id
purchse_price → purchase_price
ads_cost → FLOAT64
camPGN_name → campaign_name
```


### Intermediate Layer

Intermediate models compute business metrics and combine datasets across domains.

#### Product-Level Margin
```int_sales_margin```
 ```
 purchase_cost = quantity × purchase_price
margin = revenue − purchase_cost
 ```

#### Order-Level Operational Margin
```int_orders_operational```
```
operational_margin =
margin + shipping_fee − log_cost − ship_cost
```

#### Marketing Campaign Integration
```int_campaigns```
Combines marketing data from multiple advertising platforms:
```
- Google Adwords
- Bing Ads
- Criteo
- Facebook Ads
```
Implemented using **UNION ALL** across standardized staging models.


#### Daily Campaign Aggregation
```int_campaigns_day```
Aggregates marketing campaign metrics at the daily level.


### Mart Layer
Mart models provide analytics-ready datasets for business stakeholders.

#### Finance Daily Metrics
```finance_days```
Daily financial performance metrics.


#### Finance Campaign Daily Metrics
```finance_campaigns_day```
Combines finance and marketing metrics.
New metric:
```
ads_margin = operational_margin − ads_cost
```


#### Finance Campaign Monthly Metrics
```finance_campaigns_month```
Monthly aggregated financial performance including marketing costs.

---

## Data Quality
The project implements data quality checks using dbt tests.
These tests are defined in the schema.yml file and executed during `dbt build`. 
Examples include:
- not_null
- unique
- relationships
- source freshness
These tests ensure:
- primary keys are valid
- relationships between models are consistent
- source data freshness can be monitored

---

## Materialization Strategy

Different materialization strategies are used depending on the layer:
```
Layer	Materialization
Staging	View
Intermediate	View
Mart	Table
```
Mart models are materialized as **tables** because they are frequently queried by analytics dashboards.

---

## Project Structure
```
models
│
├── staging
│   ├── stg_raw__sales.sql
│   ├── stg_raw__product.sql
│   ├── stg_raw__ship.sql
│   ├── stg_raw__adwords.sql
│   ├── stg_raw__bing.sql
│   ├── stg_raw__criteo.sql
│   └── stg_raw__facebook.sql
│
├── intermediate
│   ├── int_sales_margin.sql
│   ├── int_orders_operational.sql
│   ├── int_campaigns.sql
│   └── int_campaigns_day.sql
│
└── marts
    └── finance
        ├── finance_days.sql
        ├── finance_campaigns_day.sql
        └── finance_campaigns_month.sql


```

---

#### Data Sources

The pipeline integrates operational sales data with marketing campaign data.

Sales datasets
- raw.sales
- raw.product
- raw.ship

Marketing datasets
- raw.adwords
- raw.bing
- raw.criteo
- raw.facebook

---

## Technologies Used
- dbt (Data Build Tool)
- Google BigQuery
- SQL
- Analytics Engineering
- Data Warehousing

---

## Pipeline Execution
Run models only:
```
dbt run
```
The pipeline can be executed using:
```
dbt build
```
Selective model execution example:
```
dbt build --select finance_campaigns_day
```
Generate documentation:
```
dbt docs generate
dbt docs serve
```

---

## Production Deployment
The project includes a production deployment workflow using dbt Cloud:
- pull request workflow
- production environment
- scheduled job execution
- automated documentation generation

---

## Use Case
This pipeline enables finance teams to analyze:
- daily revenue performance
- marketing campaign profitability
- operational margins
- advertising ROI
By integrating sales and marketing datasets into a unified analytical model.

### Author
Senem Yılmaz
Data Engineering & Analytics Engineering Projects
