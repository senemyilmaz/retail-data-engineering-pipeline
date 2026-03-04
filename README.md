# Retail Data Engineering Pipeline


A modular **analytics engineering pipeline built with dbt and Google BigQuery** to transform raw retail transaction data into reliable financial analytics datasets.

---

# Project Overview

This project implements a **modular data transformation pipeline** that converts raw retail transaction data into **business-ready financial analytics tables**.

The pipeline follows modern **analytics engineering principles** and organizes transformations into layered data models that ensure data quality, traceability, and maintainability.

The final output enables finance teams to monitor **daily business performance** through key financial indicators.

## Key Metrics Produced

- Revenue
- Purchase Cost
- Margin
- Operational Margin
- Shipping Cost
- Logistics Cost
- Average Basket Value
- Number of Transactions

---

# Problem Statement

The finance team requires a reliable dataset to monitor **daily operational performance.**
However, raw transactional data stored in BigQuery presents several challenges:

-Multiple tables must be joined together
-Business metrics are not pre-computed
-Raw tables contain inconsistent schemas
-Data structures are not optimized for analytical queries
To address these issues, this project builds a layered dbt pipeline that:
-standardizes raw data
-computes financial metrics
-ensures data quality
-provides analytics-ready datasets for stakeholders

--

# Architecture

The project follows a **layered analytics engineering architecture**:


```
       ┌──────────┐
       │   RAW    │
       └────┬─────┘
            ↓
       ┌──────────┐
       │ STAGING  │
       └────┬─────┘
            ↓
    ┌───────────────┐
    │ INTERMEDIATE  │
    └───────┬───────┘
            ↓
       ┌──────────┐
       │   MART   │
       └──────────┘
```


Each layer has a specific responsibility in the data transformation process.

---

# Source Data
The pipeline consumes raw transactional data stored in the **BigQuery dataset:**


```
gz_raw_data
```



**raw_gz_sales**

Order-level product transaction data.

Key fields:
-orders_id
-pdt_id
-date_date
-quantity
-revenue

**raw_gz_product**

Product information including purchase prices.

Key fields:
-products_id
-purchase_price

**raw_gz_ship**

Shipping and logistics cost information.

Key fields:
-orders_id
-shipping_fee
-log_cost
-ship_cost


---

# Data Modeling Strategy

The project uses a **three-stage transformation strategy** commonly used in analytics engineering.

## Staging Models
The staging layer standardizes raw data and prepares it for downstream transformations.

Models:

- `stg_raw__sales`
- `stg_raw__product`
- `stg_raw__ship`

Responsibilities:

- column renaming
- data type casting
- schema normalization
- basic data cleaning
- preparation for joins

---

## Intermediate Models

Intermediate models compute reusable metrics and simplify transformation logic.

### `int_sales_margin`

Calculates **product-level margin**.

Formula:
 
```
purchase_cost = quantity × purchase_price
margin = revenue − purchase_cost
```


---

### `int_orders_margin`

Aggregates product-level metrics **to order level**.

Outputs:

- order revenue
- quantity
- purchase cost
- margin

---

### `int_orders_operational`

Computes **operational margin** including logistics costs.

Formula:

```
operational_margin =
margin + shipping_fee − (log_cost + ship_cost)
```

---

## Mart Models

The **mart layer** produces analytics-ready datasets designed for business stakeholders.

### `finance_days`

This table provides **daily financial KPIs** used by the finance dashboard.

Daily metrics include:

- Revenue
- Margin
- Operational Margin
- Purchase Cost
- Shipping Fee
- Logistics Cost
- Number of Transactions
- Average Basket Value
- Quantity Sold

---

# Data Model Flow


```
raw.sales
raw.product
raw.ship
↓
stg_raw__sales
stg_raw__product
stg_raw__ship
↓
int_sales_margin
↓
int_orders_margin
↓
int_orders_operational
↓
finance_days
```

This structure ensures **clear lineage and modular transformations**.




---

# Data Quality Strategy

Data quality validation is implemented using **dbt tests defined in** schema.yml.
Implemented tests include:
- not_null
- unique
- relationships
- composite key validation
  
Examples:
- (orders_id, pdt_id) uniqueness validation in the sales table
- foreign key validation between orders and product tables

# Source Freshness Monitoring

dbt **source freshness checks** monitor upstream raw data tables.
These checks detect:
- stale data sources
- delayed data ingestion
- 
This ensures the analytics layer is always based on **up-to-date operational data.**

# Data Lineage
dbt automatically generates a **lineage graph** that shows dependencies between models.

This allows engineers and analysts to:

- trace each metric back to its raw data source
- debug transformation issues
- understand pipeline structure
  
The transformation pipeline follows:

```
raw → staging → intermediate → mart
```

<img width="1148" height="208" alt="image" src="https://github.com/user-attachments/assets/2362f90d-f89f-4286-9f3a-9ab86d682a75" />


# Key Business Metrics

### Revenue

Total amount paid by customers.

---

### Purchase Cost

Formula: 

```
purchase_cost = quantity × purchase_price
```

### Margin
Formula:

```
margin = revenue − purchase_cost
```

### Operational Margin
Formula:

```
operational_margin =
margin + shipping_fee − (log_cost + ship_cost)
```

### Average Basket Value
Formula:

```
average_basket = revenue / number_of_transactions
```

---

## Project Structure

```
models
│
├── staging
│   └── raw
│       ├── stg_raw__sales.sql
│       ├── stg_raw__product.sql
│       └── stg_raw__ship.sql
│
├── intermediate
│   ├── int_sales_margin.sql
│   ├── int_orders_margin.sql
│   └── int_orders_operational.sql
│
└── mart
    └── finance_days.sql
```


---


## Technologies

- **dbt**
- **Google BigQuery**
- **SQL**
- **dbt-utils**

---

## Running the Project

### Install dependencies


```
dbt deps
```

### Run the pipeline

```
dbt run
```

### Run tests

```
dbt test
```

### Generate documentation

```
dbt docs generate
dbt docs serve
```

---

## Project Goals

This project demonstrates:

- Modular data transformation pipelines  
- Analytics engineering best practices  
- Layered data modeling  
- Business metric computation  
- Data quality validation using dbt  

---

## Engineering Principles

This pipeline is designed based on the following principles:

**Modular transformations**
Each layer performs a specific transformation task.

**Data reliability**
dbt tests ensure invalid data does not propagate to analytics tables.

**Traceable lineage**
Data lineage makes the pipeline transparent and debuggable.

**Business-friendly datasets**
Mart models provide simplified datasets for business stakeholders.

---

## Author

Senem Yılmaz  
Industrial Engineering Graduate  
Data Engineering & Analytics Engineering



