WITH sales_base AS (
    SELECT
    productkey,
    quantity,
    unitprice,
    exchangerate,
    orderdate,
    deliverydate,
    quantity * unitprice * exchangerate AS revenue
  FROM sales),
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
)
SELECT * FROM weekly_stats;
