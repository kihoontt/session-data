--- Mine Foreign Table ---
DROP TABLE k_mine_foreign_202101;

CREATE TABLE k_mine_foreign_202101 AS
SELECT wifi_id, shop_id, area, dwell_time, date, time, hour, regexp_replace(country, ",.*$", "") as country, row_number() over () as r_no
    FROM (
        SELECT wifi_id, shop_id, area, dwell_time, ts,
        substr(from_unixtime(CAST(ts / 1000 + 32400 as BIGINT), 'yyyy-MM-dd HH:mm:ss'),1,10) AS date,
        substr(from_unixtime(CAST(ts / 1000 + 32400 as BIGINT), 'yyyy-MM-dd HH:mm:ss'),12,8) AS time, 
        substr(from_unixtime(CAST(ts / 1000 + 32400 as BIGINT), 'yyyy-MM-dd HH:mm:ss'),12,2) AS hour, country
        FROM wifi_sessions
        WHERE ((key >= '13:') and (key < '14:x'))
        AND shop_id in (13,14)
        AND deny is NULL
        AND area not in ('hidden')
        AND country is not NULL
        AND dwell_time > 0
        AND local = false) A
    	WHERE date >= '2020-04-01'
	    AND date <= '2020-12-31';

SELECT shop_id, date, time, wifi_id, area, country, dwell_time
FROM k_mine_foreign_202101
WHERE country !='ZM'
