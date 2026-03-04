SELECT
    f.order_date,
    f.operational_margin - COALESCE(c.ads_cost, 0) AS ads_margin,
    ROUND(f.average_basket, 2) AS average_basket,
    f.operational_margin,
    COALESCE(c.ads_cost, 0) AS ads_cost,
    COALESCE(c.ads_impression, 0) AS ads_impression,
    COALESCE(c.ads_clicks, 0) AS ads_clicks,
    f.quantity,
    f.revenue,
    f.purchase_cost,
    f.margin,
    f.shipping_fee,
    f.log_cost,
    f.ship_cost
FROM {{ ref('finance_days') }} f
LEFT JOIN {{ ref('int_campaigns_day') }} c
ON f.order_date = c.date_date