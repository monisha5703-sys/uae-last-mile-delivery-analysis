# UAE Last-Mile Delivery Performance Analysis

## Business Problem

Last-mile delivery performance directly affects customer experience, operating cost, and logistics reliability.

This project analyses simulated 2025 UAE shipment data to evaluate delivery performance across carriers, emirates, service levels, weather conditions, area types, and seasonal/calendar periods.

The analysis was designed as a business analytics case study for a logistics company operating in the UAE.

---

## Project Objective

The objective of this project was to:

- Measure overall delivery performance
- Compare carrier reliability and cost
- Identify geographic and operational performance differences
- Analyse delivery performance by service level, weather and area type
- Evaluate return/loss patterns
- Build an Excel partner-switch scenario model
- Translate the analysis into business recommendations

---

## Dataset

**Dataset type:** Simulated shipment dataset  
**Year:** 2025  
**Initial shipment records:** 8,920  
**Duplicates removed:** 118  
**Final analysis records:** 8,802

The dataset contains shipment-level information including:

- Shipment status
- Carrier
- Destination emirate
- Service level
- Area type
- Weather condition
- Season
- Dispatch date
- Delivered date
- Promised delivery days
- Shipment weight
- Shipping cost

> **Important:** The shipment data used in this project is simulated and is not proprietary Aramex operational data. Public company information is used only as business context.

---

## Tools Used

- **SQL / MySQL** — data cleaning, transformation and analysis
- **Excel** — scenario modelling and sensitivity analysis
- **Power BI** — interactive dashboard and KPI reporting
- **DAX** — Power BI measures
- **Power Query** — data preparation

---

## Data Cleaning

The SQL workflow included:

1. Checking the raw shipment data
2. Identifying duplicate records
3. Standardising emirate names
4. Handling missing delivery dates
5. Calculating actual delivery days
6. Creating an on-time delivery indicator
7. Creating return/loss indicators
8. Preparing the cleaned dataset for analysis

The final analysis dataset contained **8,802 shipment records**.

---

## Analysis Performed

### Carrier Performance

Carrier performance was compared using:

- On-time delivery %
- Average shipping cost
- Return/loss %
- Shipment volume

A cost-versus-reliability analysis was also developed to compare carrier performance.

### Geographic Performance

Delivery performance was analysed across the seven UAE emirates:

- Abu Dhabi
- Ajman
- Dubai
- Fujairah
- Ras Al Khaimah
- Sharjah
- Umm Al Quwain

### Operational Factors

Performance was analysed by:

- Service level
- Weather condition
- Area type
- Season
- Month
- UAE calendar periods

---

## Excel Decision Model

An Excel partner-switch scenario model was developed to evaluate whether reallocating shipment volume between carriers could improve route-level delivery performance.

### Scenario

**Route:** Ras Al Khaimah  
**Current carrier:** C03  
**Alternative carrier:** C02  
**Volume moved:** 100%

### Scenario Result

The model estimates that moving the Ras Al Khaimah volume from C03 to C02 could increase route-level on-time delivery from approximately **82.0% to 87.2%**.

The estimated additional cost is approximately **AED 61 per month**, with approximately **26 additional on-time deliveries per year** under the scenario assumptions.

The model also tests a 90% on-time target. The sensitivity analysis indicates that the target cannot be achieved through this carrier switch alone under the model assumptions.

---

## Business Recommendation

The scenario analysis suggests that reallocating Ras Al Khaimah volume from C03 to C02 could improve route-level delivery reliability under the model assumptions.

However, the analysis should be treated as a scenario rather than a direct operational recommendation because the underlying shipment dataset is simulated.

Before implementing a carrier change, a logistics team should validate the result using:

- Actual carrier contracts
- Lane-level shipment volumes
- Capacity constraints
- SLA definitions
- Actual carrier costs
- Customer/service-level requirements
- Operational constraints

---

## Key Business Insight

Delivery performance should not be evaluated using cost alone.

Comparing **cost, reliability, shipment volume and return/loss performance together** provides a more useful basis for operational decision-making.

---

## Power BI Dashboard

The Power BI dashboard contains three pages:

### 1. UAE Last-Mile Delivery Performance

Provides an overall view of:

- Shipment volume
- Average delivery time
- On-time delivery
- Return/loss rate
- Shipping cost
- Emirate performance
- Service-level performance
- Weather and area-type performance
- Monthly trends

### 2. Carrier Performance

Focuses on:

- Carrier on-time performance
- Carrier cost
- Return/loss rate
- Shipment volume
- Cost versus delivery reliability

### 3. Customer/Shipment Insights

Explores:

- Shipment status
- Service-level delivery time
- Weather impact
- Shipping cost
- Area-type performance
- Monthly shipment trends

---

## Limitations

- Shipment data is simulated.
- Results should not be interpreted as actual Aramex operational performance.
- Carrier costs and performance relationships are based on the project dataset.
- The partner-switch model represents a scenario rather than a live operational recommendation.
- Real-world constraints such as contract terms, capacity, routing and service-level agreements would need to be evaluated before implementation.

---

## Skills Demonstrated

**SQL | MySQL | Excel | Power BI | DAX | Power Query | Data Cleaning | KPI Analysis | Scenario Modelling | Sensitivity Analysis | Business Analysis | Data Visualisation**

---

## Project Structure

```text
SQL/
    aramex_analysis.sql

Excel/
    Aramex_Partner_Switch_Model.xlsx

Power BI/
    UAE_Last_Mile_Delivery_Performance.pbix

Screenshots/
    dashboard_overview.png
    carrier_performance.png
    shipment_insights.png
