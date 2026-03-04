-- models/intermadiate/int_orders_margin.sql

SELECT
  order_id,
  order_date,
  ROUND(SUM(revenue), 2) AS revenue,
  ROUND(SUM(quantity), 2) AS quantity,
  ROUND(SUM(purchase_cost), 2) AS purchase_cost,
  ROUND(SUM(margin), 2) AS margin
FROM {{ ref("int_sales_margin") }}
GROUP BY order_id, order_date
ORDER BY order_id DESC