require('RgoogleMaps')
library(RColorBrewer)
require(maps)
locData = read.table('E:/allCountries.txt',sep = '\t', quote='', comment.char='')
colnames(locData) = c('geonameid', 'name','asciiname','alternateNames','latitude','longitde','featureClass','featureCode','countryCode','cc2','admin1Code','admin2Code','admin3Code','admin4Code','population','elevation','dem','timeZone','modificationDate')
locData = locData[,c('name', 'asciiname','alternateNames', 'latitude', 'longitde','featureClass','featureCode', 'countryCode','population','timeZone')]
locData$asciiname = tolower(locData$asciiname)

locNames = unique(locData$asciiname)


headbubbleMap(SP, coords = c("x", "y"), crs = CRS("+proj=longlat +datum=WGS84"),
          map, filename = "", zcol = 1, max.radius = 100, key.entries = quantile(SP@data[,
                                                                                         zcol], (1:5)/5), do.sqrt = TRUE, colPalette = NULL, strokeColor = "#FFAA00",
          alpha = 0.7, strokeWeight = 1, LEGEND = TRUE, legendLoc = "topleft",
          verbose = 0)
GetMap( zoom=1, maptype= "mobile", destfile = "terrain.png")



map()

map(points)