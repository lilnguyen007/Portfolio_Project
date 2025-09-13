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
abc_classified AS (
  SELECT *,
    CASE
      WHEN cumulative_sales_proportion <= 80 THEN 'A'
      WHEN cumulative_sales_proportion <= 95 THEN 'B'
      ELSE 'C'
    END AS abc_classification
  FROM sales_abc
)
SELECT * FROM abc_classified;
