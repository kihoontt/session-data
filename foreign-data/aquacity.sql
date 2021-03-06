--- Aquacity Table---

--if you want to drop the table -> DROP TABLE kevin_aquacity202009;

CREATE TABLE k_aquacity202101 AS
SELECT wifi_id, shop_id, area, dwell_time, date, time, hour, regexp_replace(country, ",.*$", "") as country, row_number() over () as r_no
    FROM (
        SELECT wifi_id, shop_id, area, dwell_time, ts,
        substr(from_unixtime(CAST(ts / 1000 + 32400 as BIGINT), 'yyyy-MM-dd HH:mm:ss'),1,10) AS date,
        substr(from_unixtime(CAST(ts / 1000 + 32400 as BIGINT), 'yyyy-MM-dd HH:mm:ss'),12,8) AS time, 
        substr(from_unixtime(CAST(ts / 1000 + 32400 as BIGINT), 'yyyy-MM-dd HH:mm:ss'),12,2) AS hour,
        country
        FROM wifi_sessions
        WHERE ((key >= '10:') and (key < '10:x'))
        AND deny is NULL
        AND local = false
        AND shop_id in (10)) A
        WHERE area not in ('hidden', 'out', 'in')
        AND country is not NULL
        AND dwell_time > 0
        AND date >= '2021-01-01'
     	AND date <= '2021-01-31';


SELECT shop_id, date, time, wifi_id, area, country, dwell_time
FROM k_aquacity202101
WHERE country not in ("ZM")
