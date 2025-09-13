WITH sales_base AS (
  SELECT
    productkey,
    quantity,
    unitprice,
    exchangerate,
    orderdate,
    deliverydate,
    quantity * unitprice * exchangerate AS revenue
  FROM sales
),

weekly_demand AS (
  SELECT
    productkey,
    DATE_TRUNC('week', orderdate) AS week_start,
    SUM(quantity) AS weekly_quantity
  FROM sales_base
  GROUP BY productkey, DATE_TRUNC('week', orderdate)
),

weekly_stats AS (
  SELECT
    productkey,
    ROUND(AVG(weekly_quantity), 2) AS avg_weekly_demand,
    ROUND(STDDEV_POP(weekly_quantity), 2) AS std_weekly_demand,
    CASE
      WHEN AVG(weekly_quantity) > 0 THEN ROUND(STDDEV_POP(weekly_quantity) / AVG(weekly_quantity), 2)
      ELSE NULL
    END AS coef_weekly_demand
  FROM weekly_demand
  GROUP BY productkey
),

leadtime AS (
  SELECT
    productkey,
    ROUND(AVG(deliverydate - orderdate), 0) AS avg_lead_time
  FROM sales_base
  GROUP BY productkey
),

xyz_classified AS (
  SELECT
    ws.productkey,
    ws.avg_weekly_demand,
    ws.std_weekly_demand,
    ws.coef_weekly_demand,
    lt.avg_lead_time,

    -- Safety Stock:
    ROUND(1.65 * ws.std_weekly_demand * SQRT(lt.avg_lead_time / 7.0)::numeric, 0) AS safety_stock,

    -- Phân loại XYZ dựa trên hệ số biến động
    CASE
      WHEN ws.coef_weekly_demand <= 0.5 THEN 'X'
      WHEN ws.coef_weekly_demand <= 1.0 THEN 'Y'
      ELSE 'Z'
    END AS xyz_classification
  FROM weekly_stats ws
  JOIN leadtime lt ON ws.productkey = lt.productkey
)
SELECT
  productkey,
  avg_weekly_demand,
  std_weekly_demand,
  coef_weekly_demand,
  avg_lead_time,
  safety_stock,
  xyz_classification
FROM xyz_classified
ORDER BY productkey;

