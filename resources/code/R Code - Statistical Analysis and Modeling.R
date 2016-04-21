install.packages("ggplot2")
library(ggplot2)

# Read in our data
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

# Build the linear model, with Casualty Severity as our dependent variable and age as the single independent variable
linear_model <- lm(Casualty.Severity ~ Age.of.Casualty, data = road)
print(summary(linear_model))

# Build a multiple linear regression model
linear_model_2  <- lm(Casualty.Severity ~ Age.of.Casualty + Weather.Conditions + Road.Surface + Lighting.Conditions + Sex.of.Casualty + Type.of.Vehicle + Number.of.Vehicles, data = road)
print(summary(linear_model_2))

# If you want to look at all variables, you can use code below
linear_model_2 <- lm(Casualty.Severity~., data = road)
print(summary(linear_model_2))

# Create a third linear model with Number of Casualties as the dependent variable
linear_model_3 <- lm(Number.of.Casualties~., data = road)
print(summary(linear_model_3))

install.packages("coefplot")
library(coefplot)

# We can plot the coefficients of one of the linear models
coefplot(linear_model_2)

# Using multiplot, we can compare the two models - one where the dependent variable is Casualty Severity (linear_model_2) and the other Number of Casualties (linear_model_3)
multiplot(linear_model_2, linear_model_3)
