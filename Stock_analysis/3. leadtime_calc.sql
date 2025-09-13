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
leadtime AS (
  SELECT
    productkey,
    ROUND(AVG(deliverydate - orderdate), 0) AS avg_lead_time,
    MAX(deliverydate - orderdate) AS max_lead_time,
    MIN(deliverydate - orderdate) AS min_lead_time
  FROM sales_base
  GROUP BY productkey
)
SELECT * FROM leadtime;
