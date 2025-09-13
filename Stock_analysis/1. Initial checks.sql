WITH 
overview AS (
  SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT productkey) AS distinct_products
  FROM sales
),

-- Null / Missing values
null_check AS (
  SELECT
    COUNT(*) FILTER (WHERE productkey IS NULL) AS null_productkey,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantity,
    COUNT(*) FILTER (WHERE unitprice IS NULL) AS null_unitprice,
    COUNT(*) FILTER (WHERE exchangerate IS NULL) AS null_exchangerate,
    COUNT(*) FILTER (WHERE orderdate IS NULL) AS null_orderdate,
    COUNT(*) FILTER (WHERE deliverydate IS NULL) AS null_deliverydate,
    COUNT(*) FILTER (WHERE currentstock IS NULL) AS null_currentstock
  FROM sales
),

-- Value ranges
value_ranges AS (
  SELECT
    MIN(quantity) AS min_qty, MAX(quantity) AS max_qty,
    MIN(unitprice) AS min_price, MAX(unitprice) AS max_price,
    MIN(exchangerate) AS min_fx, MAX(exchangerate) AS max_fx,
    MIN(currentstock) AS min_stock, MAX(currentstock) AS max_stock
  FROM sales
),

-- Date ranges
date_ranges AS (
  SELECT
    MIN(orderdate) AS min_order_date,
    MAX(orderdate) AS max_order_date,
    MIN(deliverydate) AS min_delivery_date,
    MAX(deliverydate) AS max_delivery_date
  FROM sales
),

-- Logic checks
logic_check AS (
  SELECT
    COUNT(*) FILTER (WHERE deliverydate < orderdate) AS negative_leadtime,
    COUNT(*) FILTER (WHERE quantity <= 0) AS invalid_qty,
    COUNT(*) FILTER (WHERE unitprice <= 0 OR exchangerate <= 0) AS invalid_price
  FROM sales
)

SELECT
  o.total_rows,
  o.distinct_products,
  n.null_productkey,
  n.null_quantity,
  n.null_unitprice,
  n.null_exchangerate,
  n.null_orderdate,
  n.null_deliverydate,
  n.null_currentstock,
  v.min_qty, v.max_qty,
  v.min_price, v.max_price,
  v.min_fx, v.max_fx,
  v.min_stock, v.max_stock,
  d.min_order_date, d.max_order_date,
  d.min_delivery_date, d.max_delivery_date,
  l.negative_leadtime,
  l.invalid_qty,
  l.invalid_price
FROM overview o
CROSS JOIN null_check n
CROSS JOIN value_ranges v
CROSS JOIN date_ranges d
CROSS JOIN logic_check l;
