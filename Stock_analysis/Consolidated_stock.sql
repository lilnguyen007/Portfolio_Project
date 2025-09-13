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
    ROUND(AVG(deliverydate - orderdate), 0) AS avg_lead_time,
    MAX(deliverydate - orderdate) AS max_lead_time,
    MIN(deliverydate - orderdate) AS min_lead_time
  FROM sales_base
  GROUP BY productkey
),
sales_summary AS (
  SELECT
    productkey,
    SUM(quantity) AS quantity_sold,
    SUM(revenue) AS product_sales
  FROM sales_base
  GROUP BY productkey
),
total_sales AS (
  SELECT SUM(product_sales) AS total FROM sales_summary
),
sales_abc AS (
  SELECT
    s.productkey,
    s.quantity_sold,
    s.product_sales,
    ROUND((s.product_sales * 100.0 / t.total)::numeric, 4) AS sales_contribution,
    ROUND(SUM(s.product_sales * 100.0 / t.total) OVER (
      ORDER BY s.product_sales DESC
      ROWS UNBOUNDED PRECEDING
    )::numeric, 4) AS cumulative_sales_proportion
  FROM sales_summary s
  CROSS JOIN total_sales t
),
abc_xyz AS (
  SELECT *,

    CASE
      WHEN cumulative_sales_proportion <= 80 THEN 'A'
      WHEN cumulative_sales_proportion <= 95 THEN 'B'
      ELSE 'C'
    END AS abc_classification
  FROM sales_abc
),
latest_stock AS (
  SELECT DISTINCT ON (productkey)
    productkey,
    currentstock
  FROM sales
  WHERE currentstock IS NOT NULL
  ORDER BY productkey, orderdate DESC
),
avg_price AS (
  SELECT productkey, AVG(unitprice * exchangerate) AS avg_unit_price
  FROM sales_base
  GROUP BY productkey
)
SELECT
  a.productkey,
  a.quantity_sold,
  a.product_sales,
  a.sales_contribution,
  a.cumulative_sales_proportion,
  a.abc_classification,
  lt.avg_lead_time,
  lt.max_lead_time,
  lt.min_lead_time,
  ws.avg_weekly_demand,
  ws.std_weekly_demand,
  ws.coef_weekly_demand,

  -- Safety stock
  ROUND(1.65 * ws.std_weekly_demand * SQRT(lt.avg_lead_time / 7.0)::numeric, 0) AS safety_stock,

  -- XYZ classification
  CASE
    WHEN ws.coef_weekly_demand <= 0.5 THEN 'X'
    WHEN ws.coef_weekly_demand <= 1.0 THEN 'Y'
    ELSE 'Z'
  END AS xyz_classification,

  -- ABC-XYZ Combined
  a.abc_classification || '-' ||
  CASE
    WHEN ws.coef_weekly_demand <= 0.5 THEN 'X'
    WHEN ws.coef_weekly_demand <= 1.0 THEN 'Y'
    ELSE 'Z'
  END AS abc_xyz_classification,

  -- Reorder Point
  ROUND(ws.avg_weekly_demand * (lt.avg_lead_time / 7.0) + 
        1.65 * ws.std_weekly_demand * SQRT(lt.avg_lead_time / 7.0)::numeric, 0) AS reorder_point,

  -- Stock info
  ls.currentstock,
  p.avg_unit_price,
  ROUND((ls.currentstock * p.avg_unit_price)::numeric, 2) AS onhand_inventory_value,

  -- Re-ordering Status
  CASE
    WHEN (ws.avg_weekly_demand * (lt.avg_lead_time / 7.0) + 
          1.65 * ws.std_weekly_demand * SQRT(lt.avg_lead_time / 7.0)) >
         (1.65 * ws.std_weekly_demand * SQRT(lt.avg_lead_time / 7.0)) THEN 'YES'
    ELSE 'NO'
  END AS re_ordering_status

FROM abc_xyz a
JOIN leadtime lt ON a.productkey = lt.productkey
JOIN weekly_stats ws ON a.productkey = ws.productkey
JOIN latest_stock ls ON a.productkey = ls.productkey
JOIN avg_price p ON a.productkey = p.productkey
ORDER BY a.productkey;
