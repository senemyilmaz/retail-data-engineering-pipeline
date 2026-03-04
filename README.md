# Retail Data Engineering Pipeline

## Project Overview

This project implements a modular data transformation pipeline using **dbt** and **Google BigQuery** to model and analyze retail transaction data.

The pipeline transforms raw transactional data into business-ready financial metrics using a layered analytics engineering architecture.

Key outputs include daily financial indicators such as:

- Revenue  
- Margin  
- Operational Margin  
- Purchase Cost  
- Shipping Cost  
- Average Basket Value  

---

## Architecture

The project follows a modern analytics engineering architecture:

```
raw → staging → intermediate → mart
```


---

## Raw Layer

Raw transactional data stored in BigQuery.

Tables:

- `raw_gz_sales`
- `raw_gz_product`
- `raw_gz_ship`

---

## Staging Layer

The staging layer standardizes raw data and prepares it for transformation.

Models:

- `stg_raw__sales`
- `stg_raw__product`
- `stg_raw__ship`

Responsibilities:

- Column standardization  
- Basic data cleaning  
- Data type casting  
- Renaming inconsistent fields  

---

## Intermediate Layer

Intermediate models compute business metrics and combine datasets.

Models:

### `int_sales_margin`

Calculates product-level purchase cost and margin.

```
purchase_cost = quantity × purchase_price
margin = revenue − purchase_cost
```

### `int_orders_margin`

Aggregates product-level metrics to the order level.

### `int_orders_operational`

Calculates operational margin including shipping and logistics costs.


```
operational_margin =
margin + shipping_fee − (log_cost + ship_cost)
```


---

## Mart Layer

The mart layer produces analytics-ready datasets.

Model:

- `finance_days`

Daily aggregated metrics include:

- Revenue  
- Margin  
- Operational Margin  
- Purchase Cost  
- Shipping Fee  
- Logistics Costs  
- Number of Transactions  
- Average Basket Value  

---

## Data Model Flow

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
<img width="1148" height="208" alt="image" src="https://github.com/user-attachments/assets/2362f90d-f89f-4286-9f3a-9ab86d682a75" />



---

## Data Quality & Freshness

Data quality validation is implemented using **dbt tests**:

- `unique`
- `not_null`
- `relationships`
- composite key validation

Examples:

- `(orders_id, pdt_id)` uniqueness in the sales table
- foreign key validation between orders and product tables

Source freshness is monitored using **dbt source freshness checks**.

---

## Key Business Metrics

### Revenue

Total amount paid by customers.

### Purchase Cost
```
purchase_cost = quantity × purchase_price
```

### Margin

```
margin = revenue − purchase_cost
```

### Operational Margin

```
operational_margin =
margin + shipping_fee − (log_cost + ship_cost)
```

### Average Basket Value

```
average_basket = revenue / number_of_transactions
```


---

## Technologies Used

- **dbt**
- **Google BigQuery**
- **SQL**
- **dbt_utils**

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

## Author

**Senem Yılmaz**




