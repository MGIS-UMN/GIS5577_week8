-- CREATE SCHEMA week8;

-- SELECT rid, ST_Envelope(rast) as geom
-- FROM glc2000


-- SELECT rid, ST_DumpValues(rast, 1, TRUE)
-- FROM glc2000
-- WHERE rid = 66

-- SELECT rid, (ST_ValueCount(rast,1, True)).*
-- FROM glc2000;
-- WHERE rid = 66



-- WITH dataset as
-- (
-- SELECT rid, (ST_ValueCount(rast,1, True)).*
-- -- , count(count) as total_pixels
-- FROM glc2000
-- )
-- SELECT value, count(count) as total_pixels,
--  sum(count) as total_pixels
-- FROM dataset
-- GROUP BY value
-- ORDER BY value

SELECT 1 as rid, ST_Union(ST_Clip(r.rast,p.geom, True)) as rast
-- Ran ST_Clip, 11 records, but we had some extra, they aren't 1 record
INTO minnesota_tiles_cropped_minnesota
FROM glc2000 as r
INNER JOIN us_states p ON ST_Intersects(r.rast, p.geom)
-- 432 rows
-- WHERE p.name = ''
-- 11 tiles for Minnesota

-- This provides info for the whole us
SELECT p.name, (ST_SummaryStats(ST_Union(ST_Clip(r.rast,p.geom, True)))).* as stats
-- ST_Clip will crop the raster
-- ST_Union is an aggregator
--  as rast
FROM glc2000 as r
INNER JOIN us_states p ON ST_Intersects(r.rast, p.geom)
WHERE p.name = 'Minnesota'
GROUP BY p.name


SELECT ST_Union(rast) as rast
FROM glc2000


SELECT p.name, (ST_SummaryStatsAgg(ST_Clip(r.rast,p.geom, True),1, True)).* as stats
-- ST_Union is slow because we are making data
FROM glc2000 as r
INNER JOIN us_states p ON ST_Intersects(r.rast, p.geom)
-- WHERE p.name = 'Minnesota'
GROUP BY p.name

-- SELECT rast
-- FROM glc2000 as r, us_states p 
-- WHERE ST_Intersects(r.rast, p.geom)

SELECT (ST_ValueCount(rast)).*
--, (ST_ValueCount(ST_Reclass(rast, 1, '1-18:55', '8BUI'))).*
FROM glc2000 as r, us_states p 
WHERE rid = 66



