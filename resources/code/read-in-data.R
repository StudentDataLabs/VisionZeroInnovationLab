# Aim: read in and plot some safety data

library(sp)

leeds = read.csv("data/leeds-2014.csv")

lsp = SpatialPointsDataFrame(coords = cbind(leeds$Easting, leeds$Northing),
                             data = leeds)

plot(lsp)
bbox(lsp)
proj4string(lsp)
proj4string(lsp) = CRS("+init=epsg:27700")
lsp_wgs = spTransform(lsp, CRSobj = CRS("+init=epsg:4326"))

# install.packages("mapview")
library(mapview)
mapview(lsp_wgs)

# Convert into spatial class


# Automated access to stats19 data via stplanr