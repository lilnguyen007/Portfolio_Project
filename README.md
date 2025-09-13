# Contoso Data Analytics Project

## 📌 Project Background
The **Contoso Corporation** is a multinational business headquartered in Paris. As a manufacturer, sales, and support organization, the company manages a product portfolio of more than **100,000 items**.  

Although Contoso has accumulated significant data on **sales**, **operational efficiency**, and **loyalty programs**, much of this information has remained underutilized.  

This project aims to synthesize and analyze these datasets to extract insights and deliver recommendations that can improve performance across **sales, product and operation teams.**

---
## 🎯 Project Objectives
The project delivers insights and recommendations across the following key areas:

- **Sales Trends Analysis** – Evaluation of historical sales patterns in the US, focusin on Revenue, Order volume, and Average Order Value (AOV)
- **Product Level Perfomance** - An analysis of Contoso's various product lines, understanding top-tiers products on sales and returns
- **Inventory Analysis** – Evaluate stock performance and optimize inventory levels.  
- **Demand forecasting** - Forecasting demand trend for the next quarter base on historical data to better plan operations.

---

## 📊 Deliverables
- **Interactive Tableau Dashboard** – [Download here](#)  
- **SQL Queries** – Scripts used to clean, organize, and prepare data for the dashboard can be found [here](#)  
- **Python Scripts** – Models to project demand for the upcoming quarter are available [here](#)  

## Contoso Database ERD & Initial Checks

The **Contoso database** is designed using a **star schema**, with the **Sales** table serving as the central fact table and containing over **1.1 million transaction records** from **13rd January 2013** to **17th April 2024**. 
Surrounding it are several dimension tables that enrich the data with additional context for analytics and reporting:

- **Customer**: Stores demographic and geographical attributes (e.g., region, gender, start and end date as a customer), enabling customer segmentation and cohort analysis.

- **Product**: Provides detailed product information, including product hierarchy, manufacturer, brand, cost, and price, supporting product-level performance analytics.

- **Store**: Identifies the physical or online location where each transaction occurred, with geographic codes and operational dates.

- **Date**: Supplies a standardized calendar for time-series analysis.

- **CurrencyExchange**: Enables reporting in multiple currencies by linking daily exchange rates.

This schema is **optimized for business intelligence and reporting**, making it easy to analyze sales performance across customers, products, locations, time, and currencies.

<img src="project%20img/ERD.png" alt="Category Analysis" width="1000" height="500">

Before diving into the analysis, a variety of pre-checks were performed to inspect and familiarize with the dataset. The SQL queries ultilized to inspect and perform preliminary checks can be found [here]

## EXECUTIVE SUMMARY

After a period of steady growth, peaking in the late quarter of 2022, **Contoso** is now facing a **sharp revenue slowdown**. **Sales have dropped to _$4.93 billion_ (-32.9% YoY)**, reflecting the cooling of the consumer technology market following the post-pandemic boom. **Operating costs** have decreased in tandem (**-33.4%**), indicating that the company has proactively tightened spending to protect margins.

A bright spot lies in **inventory turnover**, which has improved to **_1.17 weeks (+14.5% YoY)_**, while the **service level** remains at **_46.7% (+1%)_**. This points to a more agile supply chain—products are moving faster, reducing capital lock-up—even as overall market demand contracts.

The **product portfolio** remains heavily dependent on **Computers (44%)** and **Cell Phones (16%)**. These categories surged during 2020–2021 but are now seeing significant revenue pressure as post-COVID demand normalizes. A small uptick in **New Brunswick (+0.5%)** signals the presence of stable niche markets, contrasting with steep declines in **Los Angeles (-44%)**, **Houston (-37%)**, and **Atlanta (-33%)**.

The **Tableau overview panel** is shown below and more detailed examples are included throughout the report. The interactive dashboard can be **[downloaded here](#)**.


<img src="project%20img/overview.png" alt="Category Analysis">


## SALES TREND AND GROWTH RATE

A deeper look into the company’s sales performance reveals a cycle of **rapid growth** followed by **correction**:  

- **Peak performance in mid-2022**  
  Sales reached an *all-time high* in **July 2022**, generating around **$4.5M in revenue from 4,200+ orders**.  
  This peak corresponded with **pandemic-driven consumer behavior**, when customers shifted spending heavily online.  

- **Sustained decline in 2023**  
  Starting in **February 2023**, revenue declined on a *year-over-year basis* for **14 consecutive months**.  
  The lowest point occurred in **June 2023**, when monthly sales fell below **$2M** — more than a **50% drop compared to the 2022 peak**.  
  While revenue recovered slightly later in the year, growth mainly followed **seasonal patterns** such as *back-to-school (Aug–Sep)* and *holiday demand (Nov–Dec)*.  

- **Post-COVID baseline remains higher**  
  Despite the downturn, both **2022 ($47.7M)** and **2023 ($35.2M)** stayed *well above* the **pre-pandemic 2019 baseline (<$12M)**.  
  Order volume also remained elevated (**15,500+ orders in 2023 vs. ~4,800 in 2020**), with **average order value (AOV)** stabilizing at *$900–1,000* despite fluctuations.  

- **Seasonality as a driver**  
  Performance continued to be shaped by *recurring cycles*:  
  - **April–May** consistently delivered the strongest sales across all years.  
  - **February** showed repeated weakness, reflecting shorter cycles and post-holiday slowdowns.  

This trajectory highlights how **explosive growth in 2021–2022** eventually gave way to **normalization in 2023**, as demand patterns adjusted to *post-pandemic market conditions*.  

<img src="project%20img/Sales trend.png" alt="Category Analysis">

## PRODUCT CATEGORY PERFORMANCE

- **Computers and Consumer Electronics Dominated Overall Performance**  
  **Desktops** led the way with more than **$43M in sales** and **$4.2M in profit**, while **Projectors & Screens** and **Digital Cameras** also proved highly profitable despite smaller volumes. These categories form the *financial backbone of the business.*  

- **Not All High-Volume Products Performed Well**   
  **Laptops** brought in nearly **$18M** but barely generated profit; **Bluetooth Headphones** faced the same challenge. Both suffered from heavy discounting with **6.24%** for the former and **6.12%** for the latter, highlighting the trade-off between *chasing sales and protecting margins.*  

- **Sales Trends Reveal Strong Seasonal Peaks**   
  Particularly during the **summer holiday period**, reflecting back-to-school demand and increased leisure consumption. This seasonality makes them reliable growth drivers but also emphasizes the need for careful planning around peak demand cycles.  

- **Notable takeaways from risk-mapping process**  
  - **Computers** are high-volume with relatively stable demand, making them **low-risk**.  
  - **Cell phones and TV/Video** display higher demand variation, creating forecasting challenges.  
  - Smaller categories like **Accessories, Lamps, and MP3 players** contribute little and carry high uncertainty, raising questions about their strategic value.  

In summary, the business thrives on **computers and electronics**, but sustaining profitability requires better discount management in **laptops and headphones**, and sharper forecasting in volatile categories like **phones and TVs**.

<img src="project%20img/CATEGORY%20ANALYSIS.png" alt="Category Analysis">

## INVENTORY ANALYSIS

- **High stock value but low efficiency**  
  Stock performance paints a complex picture of both resilience and inefficiency within the company’s inventory management. On the surface, a total stock value exceeding **$451M** signals strong capacity to serve demand, yet slow turnover at just **1.17 weeks** indicates that too much capital is tied up in inventory. At the same time, a **fill rate of only 70%** suggests that despite the size of the inventory, frequent stockouts occur — pointing to an imbalance between what is stocked and what customers actually demand. Re-ordering efficiency, although improving with **59% of SKUs actively replenished**, still falls short of establishing a robust replenishment rhythm, exposing the company to volatility.  

- **Revenue contraction despite stable demand volume**  
  The demand cycle reinforces these inefficiencies. After peaking in **February 2023**, sales contracted sharply, hitting a three-year low by **May 2023** with revenues falling nearly **42% year-over-year**. Strikingly, the number of orders declined by only **5%**, meaning customers continued to buy but shifted toward smaller, lower-value transactions. This shift not only compressed margins but also increased **transaction intensity and warehousing costs**, amplifying strain on supply chain profitability.  

- **Overstock risk concentrated in key desktop models**  
  At the SKU level, desktops remain the anchor of demand. Models such as **XD233 Black** and **XD233 Silver** dominate order volumes but also tie up a disproportionate share of stock, creating potential **overstock and obsolescence risk**. An **ABC analysis** reveals deeper structural flaws: C-type SKUs, which should represent marginal value, generated **sales almost equal to A-type items in 2023**. Meanwhile, A-category products — designed to be fewer but higher in value — ended up with stock and sales levels **twice as high as many C-items**. This misalignment inflates both holding and transaction costs, while exposing weaknesses in **demand forecasting and inventory policy design**.  

- **Seasonality and mid-tier SKUs as growth drivers**  
  Layering in **ABC–XYZ segmentation** offers more nuance. A large portion of products cluster in the **B–Y quadrant (0.6 - 80%)** — items of medium cumulative value with **moderate demand variability**. These SKUs exhibit strong **seasonal cycles**, with reliable peaks during **academic and holiday periods** such as summer breaks and year-end holidays in the US. While these products represent stable growth drivers, capturing their value requires **precisely timed stock build-ups**. Any deviation risks either lost sales during peak demand or excess inventory in off-season months.  

- **Profitability pressured by portfolio inefficiencies**  
  In essence, the business continues to thrive on desktops and core electronics but is weighed down by **portfolio inefficiencies and policy gaps**. Sustaining profitability will require tighter control over **discounting and margin leakage**, more **service-level based forecasting and replenishment models**, and a leaner inventory strategy that reallocates capital away from **low-value C-type exposure** toward supporting **seasonal peaks and high-priority A/B SKUs**.  

<img src="project%20img/Stock%20dash.png" alt="Category Analysis">


## RECOMMENDATIONS

### 1. Inventory optimization

- **Service Level Calibration**     
  - Increase target **fill rates** for A- and B-class SKUs by recalibrating **safety stock levels** using a *service-level driven approach* within the **newsvendor framework**.  
  - By applying differentiated targets (≥90% for A, ~80% for B, 60–70% for C), inventory buffers are optimized across the portfolio, balancing *availability* with *working capital efficiency*.  

- **Inventory Coverage Adjustment**   
  - Extend **stock coverage** for high-priority SKUs to mitigate risks of frequent stockouts, considering industry-standard *lead times (6–8 weeks for desktops/PCs)*.  
  - A **multi-echelon inventory optimization** approach can be applied to determine optimal safety stock placement across central and regional warehouses.  
  - Introducing **Vendor Managed Inventory (VMI)** or **consignment stock models** with key suppliers further stabilizes supply flows and reduces the *bullwhip effect*.  

- **SKU Portfolio Rationalization**     
  - Streamline the SKU assortment by applying **ABC–XYZ segmentation** to identify *hidden heroes* among C-items (high sales, high variability) and reclassify them into higher planning priority groups.  
  - Simultaneously, long-tail SKUs with minimal contribution (<5% of revenue) can be placed under **periodic review cycles** or moved to a **make-to-order policy**.  
  This reduces planning complexity, lowers carrying cost, and focuses resources on high-impact products.  

- **Lifecycle & Demand Alignment**  
  - Embed **phase-in/phase-out rules** aligned with technology refresh cycles (*typically 6–12 months in electronics*).  
  - Incorporating **time-series forecasting models with causal variables** (e.g., seasonality, promotional lifts, academic calendar) ensures better synchronization of supply with demand.  
  - Lifecycle curves (e.g., **Bass diffusion model**) can be applied to forecast adoption and decline phases, minimizing obsolete stock while maximizing availability during peak demand.  

### 2. Predictive Demand-Driven Inventory Management

- **Adopt a Cautious, Forecast-Driven Inventory Strategy**  
  With all demand models (Regression, SARIMA, TES, and RNN) indicating only marginal growth — or even contraction — over the next few quarters, inventory policy should prioritize **capital efficiency** over aggressive stock build-up.  
  Reduce purchase quantities for slow-moving SKUs and focus on **just-in-time replenishment** to avoid excess carrying costs and obsolescence risk.
  
<img src="project%20img/model%20img.png" alt="Category Analysis">

- **Integrate Forecasts into Replenishment Planning**  
  Leverage demand forecasts from Regression, SARIMA, Holt-Winters, and RNN models as the core driver of replenishment decisions. Instead of relying solely on historical averages, use forecasted demand curves to dynamically set **reorder points** and **order quantities**, aligning supply with expected demand patterns.

- **Forecast-Linked Safety Stock Policy**  
  Establish **forecast-driven safety stocks** by combining demand variability from the models with service level targets. For example, adjust safety stock levels monthly based on updated forecast accuracy (MAPE, RMSE), ensuring a balance between stock availability and capital efficiency.

- **Rolling Forecast & S&OP Alignment**  
  Move toward a **rolling forecast approach**, where demand plans are refreshed each month using the latest model outputs. This supports better **Sales & Operations Planning (S&OP)** alignment and allows procurement, production, and finance teams to respond faster to demand shifts.

- **Scenario-Based Forecast Planning**  
  Use model outputs to simulate different demand scenarios (base, optimistic, pessimistic). This allows planners to create **contingency inventory strategies** — for example, keeping additional buffer stock only under high-demand scenarios while maintaining lean levels otherwise.

- **Continuous Model Monitoring & Retraining**  
  Build a governance process around forecast models: track forecast error metrics (e.g., MAPE, bias) and retrain models regularly. This ensures that inventory decisions remain data-driven and improve over time as models become more accurate.


### 3. Customer Growth and Retention
* Boost repeat purchases: Target single-purchase with personalised re-engagement campaigns to introduce rewards within loyalty program to incentivize purchases and improve retention.
* Leverage core customers insights: Analyse behaviors and preferences of repeat customers to enhance loyalty campaigns. Introduce referal incentives to drive word-to-mouth growth and acquire new customers from existing networks

### 4. Optimizing Channels and Platform
* Expand affliate partnerships: Increase affiliate partnerships or offer higher commision to atrract influencers, enhancing brand reach and boosting AOV 
* Enhance mobile app experience: Since the highest ROI products are electronics targeting youngsters, 
