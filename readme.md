# [Capital Bikeshare](http://www.capitalbikeshare.com/) Data Visualization - A FCC Fedex Day project

### Goals:

+ Investigate usgae of [TopoJSON](https://github.com/mbostock/topojson) in GIS mapping
+ Investigate combining [D3](http://d3js.org) mapping component with traditional GIS mapping tools, such as [LeafLet](http://leafletjs.com)
+ Investiage D3's [selection.transition](http://bost.ocks.org/mike/transition/) method and [reusable chart](http://bost.ocks.org/mike/chart/) pattern

****

### Workflow:

+ Download Capital Bikeshare [Trip History Data](http://www.capitalbikeshare.com/trip-history-data) for year 2012 as CSV
+ run this [script](https://github.com/xqin1/bikeshare/blob/master/script/loadBikedata.sql) to load the csv to Postgres
+ Download bike station and other DC GIS files from [DC GIS Data Clearinghouse/Catalog](http://dcatlas.dcgis.dc.gov/catalog/) as Shape files
+ Convert Shape files to [GeoJSON](http://www.geojson.org) using [QGIS](http://www.qgis.org)
+ Convert GeoJSON files to TopoJSON using command line. (note TopoJSON can take shape file as input, but there seems to be a bug for multiPolygon features)
****

### [Live Demo]

****

### Takeaways

+ TopoJSON is incredible powerful for compressing GIS data for client side mapping. The DC boundaries files used in this project(city boundary, neighborhood and water) is 7 MB as GeoJSON, but only 740k as TopoJSON without losing any precision.
+ D3's selection.transition method sophiscated, powerful but make you intend to abuse. Appropriate usage can vastly improve the apps visual appeal.
+ D3's mapping component is powerful, especially useful when mapping larger geographies, such as at national and state level. It has limitations when the map needs detailed features and more sophiscated cartography. Combining D3 with other Javascript-based mapping technology(such as Leaflet and Mapbox) might be a good approach. The tile layer used in the application is created by MapBox's [Chris Herwig](http://mapbox.com/about/team/#chris-herwig) which shows detailed 3D buildings in DC.

****
#### Left to do
+ continue explore interaction between D3 and Leaflet
+ finish the legend component using the Reusable Chart pattern
+ visualize another dataset which shows bike usage by hour

