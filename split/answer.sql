WITH point as
(
SELECT ST_SETSRID(  
            -- ST_SETRID(geom, SRID=INT)
            ST_MakeLine(
                -- geom1, geom2 = geom
                    ST_MakePoint(-97.239,(43.499+((49.384-43.499)/2))),
                    ST_MakePoint(-89.492,(43.499+((49.384-43.499)/2)))  ),4326 
                ) as geom,

ST_Makeline(ST_GeomFromText('POINT( -97.237 46.4415)',4326), ST_GeomFromText('POINT( -89.492 46.4415)',4326)) as line
), polygon_dump as
(
SELECT (ST_Dump(ST_Split(s.geom, p.line))).*
FROM states s 
INNER JOIN point p on ST_Intersects(s.geom, p.line)
WHERE lower(s.name) = 'minnesota'
)
SELECT unnest(path) as gid, geom
FROM polygon_dump