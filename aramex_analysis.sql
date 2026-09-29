-- Project 1: UAE Last-Mile Delivery Performance
-- Dataset: Simulated 2025 shipment data
-- On-time delivery % = on-time delivered / delivered shipments
-- Returned/Lost shipments are excluded from the on-time denominator.


CREATE TABLE shipments_raw (
    shipment_id VARCHAR(20),
    dispatch_date DATE,
    delivered_date DATE,
    promised_days INT,
    carrier_id VARCHAR(10),
    hub_id VARCHAR(10),
    destination_emirate VARCHAR(50),
    area_type VARCHAR(20),
    service_level VARCHAR(20),
    weight_kg DECIMAL(10,2),
    shipping_cost_aed DECIMAL(10,2),
    status VARCHAR(20),
    season_flag VARCHAR(20),
    weather_condition VARCHAR(30)
);

SELECT COUNT(*) AS total_rows
FROM shipments_raw;

SELECT COUNT(DISTINCT shipment_id) AS unique_shipments
FROM shipments_raw;

SELECT carrier_id, COUNT(*) AS shipments
FROM shipments_raw
GROUP BY carrier_id
ORDER BY carrier_id;

SELECT 
    MIN(dispatch_date) AS first_date,
    MAX(dispatch_date) AS last_date,
    COUNT(*) AS rows_imported
FROM shipments_raw;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT shipment_id) AS unique_ids,
    COUNT(*) - COUNT(DISTINCT shipment_id) AS duplicate_id_rows
FROM shipments_raw;

TRUNCATE TABLE shipments_raw;

SHOW VARIABLES LIKE 'local_infile';

TRUNCATE TABLE shipments_raw;

LOAD DATA LOCAL INFILE 'C:/Users/whitec/Downloads/shipments.csv'
INTO TABLE shipments_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE shipments_staging (
    shipment_id VARCHAR(20),
    dispatch_date VARCHAR(20),
    delivered_date VARCHAR(20),
    promised_days VARCHAR(20),
    carrier_id VARCHAR(10),
    hub_id VARCHAR(10),
    destination_emirate VARCHAR(50),
    area_type VARCHAR(20),
    service_level VARCHAR(20),
    weight_kg VARCHAR(20),
    shipping_cost_aed VARCHAR(20),
    status VARCHAR(20),
    season_flag VARCHAR(20),
    weather_condition VARCHAR(30)
);

SELECT COUNT(*) AS total_rows
FROM shipments_staging;

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT shipment_id) AS unique_shipments,
       COUNT(*) - COUNT(DISTINCT shipment_id) AS duplicate_rows
FROM shipments_staging;

SELECT
    shipment_id,
    COUNT(*) AS occurrences
FROM shipments_staging
GROUP BY shipment_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

SELECT
    COUNT(*) AS duplicate_rows,
    COUNT(DISTINCT CONCAT_WS('|',
        shipment_id,
        dispatch_date,
        delivered_date,
        promised_days,
        carrier_id,
        hub_id,
        destination_emirate,
        area_type,
        service_level,
        weight_kg,
        shipping_cost_aed,
        status,
        season_flag,
        weather_condition
    )) AS distinct_duplicate_records
FROM shipments_staging
WHERE shipment_id IN (
    SELECT shipment_id
    FROM shipments_staging
    GROUP BY shipment_id
    HAVING COUNT(*) > 1
);

CREATE TABLE shipments_clean AS
SELECT DISTINCT *
FROM shipments_staging;

SELECT COUNT(*) AS cleaned_rows
FROM shipments_clean;

SELECT
    SUM(shipment_id = '') AS missing_shipment_id,
    SUM(dispatch_date = '') AS missing_dispatch_date,
    SUM(delivered_date = '') AS missing_delivered_date,
    SUM(promised_days = '') AS missing_promised_days,
    SUM(carrier_id = '') AS missing_carrier_id,
    SUM(hub_id = '') AS missing_hub_id,
    SUM(destination_emirate = '') AS missing_emirate,
    SUM(area_type = '') AS missing_area_type,
    SUM(service_level = '') AS missing_service_level,
    SUM(weight_kg = '') AS missing_weight,
    SUM(shipping_cost_aed = '') AS missing_cost,
    SUM(status = '') AS missing_status,
    SUM(season_flag = '') AS missing_season,
    SUM(weather_condition = '') AS missing_weather
FROM shipments_clean;

SELECT
    status,
    COUNT(*) AS missing_weight_rows
FROM shipments_clean
WHERE weight_kg = ''
GROUP BY status
ORDER BY missing_weight_rows DESC;

SELECT
    carrier_id,
    COUNT(*) AS missing_weight_rows
FROM shipments_clean
WHERE weight_kg = ''
GROUP BY carrier_id
ORDER BY missing_weight_rows DESC;

SELECT
    status,
    COUNT(*) AS missing_delivery_date
FROM shipments_clean
WHERE delivered_date = ''
GROUP BY status
ORDER BY missing_delivery_date DESC;

SELECT
    destination_emirate,
    COUNT(*) AS shipment_count
FROM shipments_clean
GROUP BY destination_emirate
ORDER BY shipment_count DESC;

SELECT
    destination_emirate,
    LENGTH(destination_emirate) AS character_length,
    COUNT(*) AS shipment_count
FROM shipments_clean
GROUP BY destination_emirate
ORDER BY destination_emirate;

UPDATE shipments_clean
SET destination_emirate =
    CASE
        WHEN TRIM(destination_emirate) IN ('Dubai', 'DXB') THEN 'Dubai'
        WHEN TRIM(destination_emirate) IN ('Abu Dhabi', 'AUH') THEN 'Abu Dhabi'
        WHEN TRIM(destination_emirate) IN ('Sharjah', 'SHJ') THEN 'Sharjah'
        WHEN TRIM(destination_emirate) IN ('Ajman', 'AJM') THEN 'Ajman'
        WHEN TRIM(destination_emirate) IN ('Ras Al Khaimah', 'Ras Al-Khaimah', 'RAK') THEN 'Ras Al Khaimah'
        WHEN TRIM(destination_emirate) IN ('Fujairah', 'Fujeirah', 'FUJ') THEN 'Fujairah'
        WHEN TRIM(destination_emirate) IN ('Umm Al Quwain', 'Umm Al Qaiwain', 'UAQ') THEN 'Umm Al Quwain'
        ELSE TRIM(destination_emirate)
    END;
    
    UPDATE shipments_clean
SET destination_emirate =
    CASE
        WHEN TRIM(destination_emirate) IN ('Dubai', 'DXB') THEN 'Dubai'
        WHEN TRIM(destination_emirate) IN ('Abu Dhabi', 'AUH') THEN 'Abu Dhabi'
        WHEN TRIM(destination_emirate) IN ('Sharjah', 'SHJ') THEN 'Sharjah'
        WHEN TRIM(destination_emirate) IN ('Ajman', 'AJM') THEN 'Ajman'
        WHEN TRIM(destination_emirate) IN ('Ras Al Khaimah', 'Ras Al-Khaimah', 'RAK') THEN 'Ras Al Khaimah'
        WHEN TRIM(destination_emirate) IN ('Fujairah', 'Fujeirah', 'FUJ') THEN 'Fujairah'
        WHEN TRIM(destination_emirate) IN ('Umm Al Quwain', 'Umm Al Qaiwain', 'UAQ') THEN 'Umm Al Quwain'
        ELSE TRIM(destination_emirate)
    END
WHERE shipment_id IS NOT NULL;

ALTER TABLE shipments_clean
ADD COLUMN row_id INT AUTO_INCREMENT PRIMARY KEY;

UPDATE shipments_clean
SET destination_emirate =
    CASE
        WHEN TRIM(destination_emirate) IN ('Dubai', 'DXB') THEN 'Dubai'
        WHEN TRIM(destination_emirate) IN ('Abu Dhabi', 'AUH') THEN 'Abu Dhabi'
        WHEN TRIM(destination_emirate) IN ('Sharjah', 'SHJ') THEN 'Sharjah'
        WHEN TRIM(destination_emirate) IN ('Ajman', 'AJM') THEN 'Ajman'
        WHEN TRIM(destination_emirate) IN ('Ras Al Khaimah', 'Ras Al-Khaimah', 'RAK') THEN 'Ras Al Khaimah'
        WHEN TRIM(destination_emirate) IN ('Fujairah', 'Fujeirah', 'FUJ') THEN 'Fujairah'
        WHEN TRIM(destination_emirate) IN ('Umm Al Quwain', 'Umm Al Qaiwain', 'UAQ') THEN 'Umm Al Quwain'
        ELSE TRIM(destination_emirate)
    END
WHERE row_id > 0;

SELECT
    destination_emirate,
    COUNT(*) AS shipment_count
FROM shipments_clean
GROUP BY destination_emirate
ORDER BY shipment_count DESC;

SELECT
    COUNT(*) AS zero_cost_rows
FROM shipments_clean
WHERE shipping_cost_aed = '0';

SELECT
    status,
    COUNT(*) AS shipment_count
FROM shipments_clean
GROUP BY status
ORDER BY shipment_count DESC;

SELECT
    promised_days,
    COUNT(*) AS shipment_count
FROM shipments_clean
GROUP BY promised_days
ORDER BY promised_days;

SELECT
    MIN(dispatch_date) AS earliest_dispatch,
    MAX(dispatch_date) AS latest_dispatch,
    MIN(delivered_date) AS earliest_delivery,
    MAX(delivered_date) AS latest_delivery
    

FROM shipments_clean;

ALTER TABLE shipments_clean
ADD COLUMN actual_days INT;

UPDATE shipments_clean
SET actual_days = DATEDIFF(delivered_date, dispatch_date)
WHERE delivered_date IS NOT NULL
  AND row_id > 0;
  
  UPDATE shipments_clean
SET actual_days = DATEDIFF(delivered_date, dispatch_date)
WHERE delivered_date <> ''
  AND row_id > 0;
  
  SELECT
    COUNT(actual_days) AS shipments_with_actual_days,
    MIN(actual_days) AS minimum_days,
    MAX(actual_days) AS maximum_days,
    AVG(actual_days) AS average_days
FROM shipments_clean;

SELECT
    shipment_id,
    dispatch_date,
    delivered_date,
    actual_days,
    promised_days,
    status
FROM shipments_clean
WHERE actual_days < 0
ORDER BY actual_days;

SELECT COUNT(*) AS invalid_delivery_dates
FROM shipments_clean
WHERE actual_days < 0;

ALTER TABLE shipments_clean
ADD COLUMN on_time TINYINT;


UPDATE shipments_clean
SET on_time =
    CASE
        WHEN actual_days >= 0
             AND actual_days <= promised_days THEN 1
        WHEN actual_days >= 0
             AND actual_days > promised_days THEN 0
        ELSE NULL
    END
WHERE row_id > 0;

SELECT
    on_time,
    COUNT(*) AS shipment_count
FROM shipments_clean
GROUP BY on_time
ORDER BY on_time;

SELECT
    ROUND(
        100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
        2
    ) AS on_time_delivery_pct
FROM shipments_clean;

SELECT
    ROUND(AVG(actual_days - promised_days), 2) AS average_delay_days
FROM shipments_clean
WHERE on_time = 0;

SELECT
    ROUND(
        100.0 * SUM(status IN ('Returned', 'Lost')) / COUNT(*),
        2
    ) AS return_loss_rate_pct
FROM shipments_clean;

SELECT
    ROUND(SUM(CAST(shipping_cost_aed AS DECIMAL(10,2))) / COUNT(*), 2)
        AS cost_per_shipment_aed
FROM shipments_clean;

SELECT
    ROUND(
        SUM(CAST(shipping_cost_aed AS DECIMAL(10,2))) /
        SUM(CAST(weight_kg AS DECIMAL(10,2))),
        2
    ) AS cost_per_kg_aed
FROM shipments_clean
WHERE weight_kg <> '';

SELECT
    carrier_id,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
        2
    ) AS on_time_pct,
    ROUND(
        AVG(CASE WHEN on_time = 0
                 THEN actual_days - promised_days END),
        2
    ) AS avg_delay_days,
    ROUND(
        SUM(CAST(shipping_cost_aed AS DECIMAL(10,2))) / COUNT(*),
        2
    ) AS cost_per_shipment_aed
FROM shipments_clean
GROUP BY carrier_id
ORDER BY on_time_pct DESC;

SELECT
    destination_emirate,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
        2
    ) AS on_time_pct,
    ROUND(
        AVG(CASE WHEN on_time = 0
                 THEN actual_days - promised_days END),
        2
    ) AS avg_delay_days
FROM shipments_clean
GROUP BY destination_emirate
ORDER BY on_time_pct DESC;

SELECT
    service_level,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
        2
    ) AS on_time_pct,
    ROUND(
        AVG(CASE WHEN on_time = 0
                 THEN actual_days - promised_days END),
        2
    ) AS avg_delay_days,
    ROUND(
        SUM(CAST(shipping_cost_aed AS DECIMAL(10,2))) / COUNT(*),
        2
    ) AS cost_per_shipment_aed
FROM shipments_clean
GROUP BY service_level
ORDER BY on_time_pct DESC;

SELECT
    season_flag,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
        2
    ) AS on_time_pct,
    ROUND(
        AVG(CASE WHEN on_time = 0
                 THEN actual_days - promised_days END),
        2
    ) AS avg_delay_days
FROM shipments_clean
GROUP BY season_flag
ORDER BY on_time_pct DESC;

SELECT
    weather_condition,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
        2
    ) AS on_time_pct,
    ROUND(
        AVG(CASE WHEN on_time = 0
                 THEN actual_days - promised_days END),
        2
    ) AS avg_delay_days
FROM shipments_clean
GROUP BY weather_condition
ORDER BY on_time_pct DESC;

WITH carrier_emirate AS (
    SELECT
        carrier_id,
        destination_emirate,
        COUNT(*) AS shipments,
        ROUND(
            100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
            2
        ) AS on_time_pct
    FROM shipments_clean
    WHERE on_time IS NOT NULL
    GROUP BY carrier_id, destination_emirate
)
SELECT
    carrier_id,
    destination_emirate,
    shipments,
    on_time_pct,
    RANK() OVER (
        ORDER BY on_time_pct ASC
    ) AS performance_rank
FROM carrier_emirate
ORDER BY on_time_pct ASC;

WITH carrier_emirate AS (
    SELECT
        carrier_id,
        destination_emirate,
        COUNT(*) AS shipments,
        ROUND(
            100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
            2
        ) AS on_time_pct
    FROM shipments_clean
    WHERE on_time IS NOT NULL
    GROUP BY carrier_id, destination_emirate
)
SELECT
    carrier_id,
    destination_emirate,
    shipments,
    on_time_pct,
    RANK() OVER (
        ORDER BY on_time_pct ASC
    ) AS performance_rank
FROM carrier_emirate
WHERE shipments >= 100
ORDER BY on_time_pct ASC;

SELECT
    DATE_FORMAT(dispatch_date, '%Y-%m') AS month,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
        2
    ) AS on_time_pct,
    ROUND(
        SUM(CAST(shipping_cost_aed AS DECIMAL(10,2))),
        2
    ) AS total_cost_aed
FROM shipments_clean
GROUP BY DATE_FORMAT(dispatch_date, '%Y-%m')
ORDER BY month;

SELECT
    area_type,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
        2
    ) AS on_time_pct,
    ROUND(
        AVG(CASE
            WHEN on_time = 0 THEN actual_days - promised_days
        END),
        2
    ) AS avg_delay_days
FROM shipments_clean
GROUP BY area_type
ORDER BY on_time_pct DESC;

SELECT
    area_type,
    service_level,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
        2
    ) AS on_time_pct,
    ROUND(
        AVG(CASE
            WHEN on_time = 0 THEN actual_days - promised_days
        END),
        2
    ) AS avg_delay_days
FROM shipments_clean
GROUP BY area_type, service_level
ORDER BY area_type, on_time_pct DESC;

CREATE TABLE uae_calendar_staging (
    calendar_date VARCHAR(20),
    period VARCHAR(50)
);
CREATE TABLE uae_calendar_staging (
    calendar_date VARCHAR(20),
    year VARCHAR(10),
    month_num VARCHAR(10),
    month_name VARCHAR(20),
    quarter VARCHAR(10),
    week_of_year VARCHAR(10),
    weekday VARCHAR(20),
    is_weekend VARCHAR(10),
    uae_period VARCHAR(50),
    is_peak_period VARCHAR(10),
    is_public_holiday VARCHAR(10),
    holiday_name VARCHAR(100),
    season VARCHAR(20)
);

DROP TABLE uae_calendar_staging;

CREATE TABLE uae_calendar_staging (
    calendar_date VARCHAR(20),
    year VARCHAR(10),
    month_num VARCHAR(10),
    month_name VARCHAR(20),
    quarter VARCHAR(10),
    week_of_year VARCHAR(10),
    weekday VARCHAR(20),
    is_weekend VARCHAR(10),
    uae_period VARCHAR(50),
    is_peak_period VARCHAR(10),
    is_public_holiday VARCHAR(10),
    holiday_name VARCHAR(100),
    season VARCHAR(20)
);

SELECT COUNT(*) AS calendar_rows
FROM uae_calendar_staging;

SELECT
    uae_period,
    COUNT(*) AS calendar_days
FROM uae_calendar_staging
GROUP BY uae_period
ORDER BY calendar_days DESC;

SELECT
    COUNT(*) AS total_shipments,
    COUNT(c.calendar_date) AS matched_calendar_dates,
    COUNT(*) - COUNT(c.calendar_date) AS unmatched_dates
FROM shipments_clean s
LEFT JOIN uae_calendar_staging c
    ON s.dispatch_date = c.calendar_date;
    
    SELECT
    c.uae_period,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * SUM(s.on_time = 1) / SUM(s.on_time IS NOT NULL),
        2
    ) AS on_time_pct,
    ROUND(
        AVG(CASE
            WHEN s.on_time = 0 THEN s.actual_days - s.promised_days
        END),
        2
    ) AS avg_delay_days,
    ROUND(
        SUM(CAST(s.shipping_cost_aed AS DECIMAL(10,2))),
        2
    ) AS total_cost_aed
FROM shipments_clean s
JOIN uae_calendar_staging c
    ON s.dispatch_date = c.calendar_date
GROUP BY c.uae_period
ORDER BY on_time_pct DESC;

SELECT
    carrier_id,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * SUM(on_time = 1) / SUM(on_time IS NOT NULL),
        2
    ) AS on_time_pct,
    ROUND(
        SUM(CAST(shipping_cost_aed AS DECIMAL(10,2))) / COUNT(*),
        2
    ) AS cost_per_shipment_aed,
    ROUND(
        SUM(CAST(shipping_cost_aed AS DECIMAL(10,2))) /
        NULLIF(SUM(CAST(weight_kg AS DECIMAL(10,2))), 0),
        2
    ) AS cost_per_kg_aed
FROM shipments_clean
GROUP BY carrier_id
ORDER BY on_time_pct DESC;

SELECT
    carrier_id,
    COUNT(*) AS total_shipments,
    SUM(on_time = 0) AS late_shipments,
    ROUND(
        100.0 * SUM(on_time = 0) / SUM(on_time IS NOT NULL),
        2
    ) AS late_pct,
    ROUND(
        AVG(CASE
            WHEN on_time = 0 THEN actual_days - promised_days
        END),
        2
    ) AS avg_delay_days
FROM shipments_clean
GROUP BY carrier_id
ORDER BY late_shipments DESC;