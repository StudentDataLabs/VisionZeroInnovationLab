install.packages("ggplot2")
library(ggplot2)

# Set the working directory and read in our data
setwd("M:/VisionZeroInnovationLab-master/data") # If you are using a Mac, then you will need to change this line to: setwd("~/VisionZeroInnovationLab-master/data")
road <- read.csv("accidents_2009-2014_duplicates_mapping.csv", header = TRUE, stringsAsFactors = FALSE)

# Inspect first few rows
head(road)

# Create a histogram showing the number of road accidents by age
ggplot(road, aes(Age.of.Casualty)) +
  geom_histogram(binwidth=1, fill="#fddf00", alpha=0.75) + 
  labs(title="", x="Age", y="") + 
  theme(axis.text = element_text(size=10, family="Helvetica"))

# Remove columns we don't want to investigate
road$Reference.Number <- NULL
road$Grid.Ref..Easting <- NULL
road$Grid.Ref..Northing <- NULL
road$Accident.Date <- NULL
road$Easting <- NULL
road$Northing <- NULL
road$Latitude <- NULL
road$Longitude <- NULL
road$Col.Number <- NULL

# Find correlation between number of casualties and age of casualty
cor(road$Number.of.Casualties, road$Age.of.Casualty)

install.packages("reshape2")
library(reshape2)

# Build correlation matrix
Correlation <- cor(road)
# Melt into long format
Correlation_Melt <- melt(Correlation, varnames=c("x", "y"), value.name="Correlation")
# Order according to correlation
Correlation_Melt <- Correlation_Melt[order(Correlation_Melt$Correlation), ]
# Display
Correlation_Melt

# Create a heatmap showing the correlation between variables
ggplot(Correlation_Melt, aes(x=x, y=y)) +
  geom_tile(aes(fill=Correlation)) +
  scale_fill_gradient2(low="red", mid="white", high="blue", guide=guide_colorbar(ticks=FALSE), limits=c(-1,1)) +
  theme_minimal() + labs(x=NULL, y=NULL)

# Build a linear model, with Number of Casualties as our dependent variable and age as the single independent variable
linear_model <- lm(Number.of.Casualties ~ Age.of.Casualty, data = road)
print(summary(linear_model))

# Build a logistic regression model for Casualty Severity since it is not a continuous variable
logistic_model  <- glm(Casualty.Severity ~ Weather.Conditions + Road.Surface + Lighting.Conditions + Sex.of.Casualty + Type.of.Vehicle, data = road)
print(summary(logistic_model))

# If you want to look at all variables, you can use code below
logistic_model_2 <- glm(Casualty.Severity~., data = road)
print(summary(logistic_model_2))

install.packages("coefplot")
library(coefplot)

# We can plot the coefficients of one of the logistic models
coefplot(logistic_model_2)

# Using multiplot, we can compare the two models - one where the dependent variable is Casualty Severity (logistic_model_2) and the other is continuous Number of Casualties (linear_model)
multiplot(logistic_model, logistic_model_2)
