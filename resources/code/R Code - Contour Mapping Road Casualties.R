install.packages("ggmap")
library(ggmap)

# Set the working directory and read in the data
setwd("M:/VisionZeroInnovationLab-master/data") # If you are using a Mac, then you will need to change this line to: setwd("~/VisionZeroInnovationLab-master/data")
accidents <- read.csv("accidents_2009-2014_duplicates_mapping.csv", header = TRUE, stringsAsFactors = FALSE)

# Set the map centre
leeds = c(lon = -1.5486, lat =  53.8013)

# We're now setting the map design, zoom level and location
leeds.map = get_map(location = leeds, zoom = 13, color = "bw")

# Create a contour/density map
ggmap(leeds.map, extent = "normal", maprange=FALSE) %+% accidents + aes(x = Longitude, y = Latitude) +
        geom_density2d(data = accidents, aes(x = Longitude, y = Latitude)) +
        stat_density2d(data = accidents, aes(x = Longitude, y = Latitude,  fill = ..level.., alpha = ..level..),
                       size = 2, bins = 12, geom = 'polygon') +
       scale_fill_gradient(low = "green", high = "red") +
       scale_alpha(range = c(0.00, 0.23), guide = FALSE) +
       coord_map(projection="mercator", 
                                 xlim=c(attr(leeds.map, "bb")$ll.lon, attr(leeds.map, "bb")$ur.lon),
                                 ylim=c(attr(leeds.map, "bb")$ll.lat, attr(leeds.map, "bb")$ur.lat)) +
       theme(legend.position = "none", axis.title = element_blank(), text = element_text(size = 12))
