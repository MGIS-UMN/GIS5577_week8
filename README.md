# GIS5577 Week 8

This is the repository for Week 8 class exercises

The purpose of this weeks lecture is to beginn understanding how to use PostGIS functions to analyze and edit raster data within the database. It is important to remember that the tile size of the dataset affects the performance greatly.


### Datasets can be found in the shapefile directory
1. States - Cartographic boundaries of the US States (WGS84, 4326)
2. Cities - Centroids of Cities in the US (WGS84, 4326)

### GeoTiffs
1. `glc2000_nodata_clipped.tif` (WGS84, 4326)
1. `meris_2010_clipped_nodata.tif` (WGS84, 4326)
1. `meris_2015_clipped_nodata.tif` (WGS84, 4326)

### Homework
1. Read Mastering PostGIS Chapter 5
1. [PostGIS Raster Cheat Sheet](http://www.postgis.us/downloads/postgis21_raster_cheatsheet.html)


### Tips
1. ```
(ST_Clip(rast, geom)- Requires raster field/column, geometry field/column```

1. ```ST_SummaryStatsAgg(rast,1, True) - Requires raster field/column, rasterband_num, Boolean (noData)```

1. ```(ST_SummaryStatsAgg((ST_Clip(r.rast, p.geom),1,True))).* - Same requirements as above, but unpacks the record type```

1. ```ST_Reclass(rast, 1, '12:1', '8BUI')  - Requires raster field/column, rasterband_num, value map, pixel type
``` 


