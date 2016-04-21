install.packages("ggmap")
install.packages("ggplot2")

library(ggmap)
library(ggplot2)

# Read in the data
road <- read.csv("accidents_2009-2014_duplicates_mapping.csv",header = TRUE,stringsAsFactors = FALSE)

# Create a subset containing bicycle crashes
bicycles <- subset(road, Type.of.Vehicle == 1)

# We're now setting the map design, zoom level and location
map.leeds <- qmap("leeds", source="stamen", zoom=11, maptype="toner", lighten=c(.5, "#BBBBBB")) 

# Let's create our dot density map
map.leeds +
  geom_point(data=bicycles, aes(x=Longitude, y=Latitude, size=Number.of.Casualties, color=Number.of.Casualties), alpha=.4, na.rm=T) +
  scale_color_gradient(low="#feb24c", high="#f03b20", name="", breaks = c(1,2,3)) + # Set the colour gradient
  scale_size(range=c(1,3), name="", breaks = c(1,2,3)) + # Set the scale from the lowest (1) to the highest (12)
  ggtitle("BICYCLE CASUALTIES, LEEDS '14") + # Create our title
  theme(text = element_text(family = "Helvetica", color="#666666")) + # Set the font and colour of our title
  theme(plot.title = element_text( size=17, face="bold", hjust=0, vjust=.6)) + # Add some more elements to the title
  guides(colour = guide_colourbar(order = 1), alpha = guide_legend(order = 2)) + # This tells R where to position the legends relative to one another
  theme(legend.position="bottom", legend.box = "horizontal") # This line of code positions the legends at bottom rather than the side 
