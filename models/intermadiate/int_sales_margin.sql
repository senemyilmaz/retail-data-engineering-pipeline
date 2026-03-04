-- models/intermadiate/int_sales_margin.sql

SELECT
  s.product_id,
  s.order_date,
  s.order_id,
  s.revenue,
  s.quantity,
  p.purchase_price,
  ROUND(s.quantity * p.purchase_price, 2) AS purchase_cost,
  ROUND(s.revenue - s.quantity * p.purchase_price, 2) AS margin
FROM {{ ref("stg_raw__sales") }} s
LEFT JOIN {{ ref("stg_raw__product") }} p
USING (product_id)