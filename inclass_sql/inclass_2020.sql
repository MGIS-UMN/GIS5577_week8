Vector dataset
(gid, att1, geom) (1, 'Minnesota', 01010)

raster dataset
(rid, filename, rast) VALUES (1, 'filepath', 01001)

raster2pgsql -C -x -I -Y -s 4326 -t 25x25 C:\git\GIS5577_week8\tiffs\glc2000_clipped_nodata.tif glc2000_25 | psql -h 129.114.17.63 -d classroom -U david


raster2pgsql -C -x -I -Y -s 4326 -t 25x25 C:\git\GIS5577_week8\tiffs\glc2000_clipped_nodata.tif glc2000_25 > c:\work\glc2000.sql

-l : overviews

SELECT count(1)
FROM glc2000_250
-- 29008 records (glc2000_25)
-- 312 records
-- 78 records (glc2000_500)

Getting pixel values?
SELECT ST_Value(r.rast, 0, 0) as my_value
-- ST_value(rast, integer, integer, boolean=default)
FROM glc2000_25 r



SELECT ST_Value(r.rast, 1, 1) as my_value
-- ST_value(rast, integer, integer, boolean=default)
FROM glc2000_250 r
WHERE r.rid = 1
-- 312 rows glc2000_250

SELECT (ST_ValueCount(r.rast)).* as my_value
-- ST_value(rast, integer, integer, boolean=default)
FROM glc2000_250 r
WHERE r.rid = 1
--62500

With dataset as 
(
SELECT (ST_ValueCount(r.rast)).* as my_value
-- ST_value(rast, integer, integer, boolean=default)
FROM glc2000_250 r
WHERE r.rid = 1
)
SELECT sum(count) as total_pixels
FROm dataset

--max pixel value (range)
With dataset as 
(
SELECT (ST_ValueCount(r.rast)).* as my_value
-- ST_value(rast, integer, integer, boolean=default)
FROM glc2000_250 r
WHERE r.rid = 1
)
SELECT max(value) as largest_pixel_value, min(value) as smallest_pixel_value
FROm dataset

--most popular pixel in the dataset
With dataset as 
(
SELECT (ST_ValueCount(r.rast)).* as my_value
-- ST_value(rast, integer, integer, boolean=default)
FROM glc2000_250 r
WHERE r.rid = 1
)
SELECT value, max(count) as most_populus
FROm dataset
GROUP BY value
ORDER BY 2 DESC
LIMIT 1

-- What is the range of state landcover types?
With dataset as 
(
SELECT p.name, r.rid, ST_Clip(r.rast, 1, p.geom, True) as rast
FROM glc2000_25 r, states p
	-- INNER JOIN states p on 
WHERE  ST_Intersects(r.rast, p.geom)
	-- p.name IN ('Minnesota', 'Wisconsin','Idaho') AND
-- ORDER BY 2
	-- glc2000_250 r , states p this is a cross join  15288
	-- cross join with Minnesota (312 tiles)
	-- Everytime we add a state, were duplicating tiles (multiplying the number of tiels by the number of states)
	-- Message are informing us that some of these tiles are empty
	-- By performing an inner join (24 rows returned)
), state_value_data as
(
SELECT name as place_name, (ST_ValueCount(r.rast)).* as my_value
FROM dataset r
)
SELECT place_name, max(value) as largest_pixel_value, min(value) as smallest_pixel_value
FROm state_value_data
GROUP BY place_name

-- Map Algebra Calculation
-- 
WITh dataset as
(
SELECT rast, ST_MapAlgebra(rast, 1, '8BUI', '[rast]*55') as rast2
--rast, int, pixel, expr
FROM glc2000_250 r
WHERE r.rid = 1
)
SELECT (ST_ValueCount(rast)).*, (ST_ValueCount(rast2)).*
FROM dataset


-- Calculating summary stats
SELECT p.name, ST_SummaryStats( ST_Union(ST_Clip(r.rast, p.geom)), True)
FROM glc2000_250 r INNER JOIN states p ON ST_Intersects(r.rast, p.geom)
GROUP BY p.name

-- Faster calculation of summary stats

SELECT p.name, (ST_SummaryStatsAgg( ST_Clip(r.rast, p.geom), 1, True)).*
FROM glc2000_250 r INNER JOIN states p ON ST_Intersects(r.rast, p.geom)
GROUP BY p.name



SELECT 250*250


