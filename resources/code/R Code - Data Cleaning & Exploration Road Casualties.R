# First, you need to download the Github repository, which contains our data

# If you're using windows - set the working directory
setwd("M:/VisionZeroInnovationLab-master/data") # If an error message appears then use setwd("C:/VisionZeroInnovationLab-master/data")

# If you are using a Mac, then you will need to use this line to set the working directory: 
setwd("~/Downloads/VisionZeroInnovationLab-master/data")

# Read in the 5 datasets from 2009-2014
leeds_14 <- read.csv("leeds-2014.csv", header = TRUE, stringsAsFactors = FALSE)
leeds_13 <- read.csv("leeds-2013.csv", header = TRUE, stringsAsFactors = FALSE)
leeds_12 <- read.csv("leeds-2012.csv", header = TRUE, stringsAsFactors = FALSE)
leeds_11 <- read.csv("leeds-2011.csv", header = TRUE, stringsAsFactors = FALSE)
leeds_10 <- read.csv("leeds-2010.csv", header = TRUE, stringsAsFactors = FALSE)
leeds_09 <- read.csv("leeds-2009.csv", header = TRUE, stringsAsFactors = FALSE)

# Merge the datasets vertically
accidents <- rbind(leeds_09,leeds_10,leeds_11,leeds_12,leeds_13,leeds_14)

# Write merged datasets to a new file
write.csv(accidents, file = "accidents2009-2014(Duplicates).csv")

# Check number of rows
dim(accidents)[1]

# Check number of columns
dim(accidents)[2]

# Inspect the first few rows
head(accidents)

# Inspect the last few rows
tail(accidents)

# Replace ‘Road Surface’ column with numbers (you'll need to do all this for '09,'10,'11,'12 individually)
accidents[accidents$Road.Surface == "Dry",]$Road.Surface = 1
accidents[accidents$Road.Surface == "Wet / Damp",]$Road.Surface = 2
accidents[accidents$Road.Surface == "Snow",]$Road.Surface = 3
accidents[accidents$Road.Surface == "Frost / Ice",]$Road.Surface = 4
accidents[accidents$Road.Surface == "Flood",]$Road.Surface = 5

# Change column name “X1st Road Class” to “First Road Class”
colnames(accidents)[8] <- "First.Road.Class"

# Replace ‘Lighting Conditions’ column with numbers
accidents[accidents$Lighting.Conditions == "Daylight: street lights present",]$Lighting.Conditions = 1
accidents[accidents$Lighting.Conditions == "Daylight: no street lighting",]$Lighting.Conditions = 2
accidents[accidents$Lighting.Conditions == "Daylight: street lighting unknown",]$Lighting.Conditions = 3
accidents[accidents$Lighting.Conditions == "Darkness: street lights present and lit",]$Lighting.Conditions = 4
accidents[accidents$Lighting.Conditions == "Darkness: street lights present but unlit",]$Lighting.Conditions = 5
accidents[accidents$Lighting.Conditions == "Darkness: no street lighting",]$Lighting.Conditions = 6
accidents[accidents$Lighting.Conditions == "Darkness: street lighting unknown",]$Lighting.Conditions = 7

# Replace ‘Weather Conditions’ column with numbers
accidents[accidents$Weather.Conditions == "Fine without high winds",]$Weather.Conditions = 1
accidents[accidents$Weather.Conditions == "Raining without high winds",]$Weather.Conditions = 2
accidents[accidents$Weather.Conditions == "Snowing without high winds",]$Weather.Conditions = 3
accidents[accidents$Weather.Conditions == "Fine with high winds",]$Weather.Conditions = 4
accidents[accidents$Weather.Conditions == "Raining with high winds",]$Weather.Conditions = 5
accidents[accidents$Weather.Conditions == "Snowing with high winds",]$Weather.Conditions = 6
accidents[accidents$Weather.Conditions == "Fog or mist ñ if hazard",]$Weather.Conditions = 7
accidents[accidents$Weather.Conditions == "Other",]$Weather.Conditions = 8
accidents[accidents$Weather.Conditions == "Unknown",]$Weather.Conditions = 9

# Replace Casualty Class
accidents[accidents$Casualty.Class == "Driver",]$Casualty.Class = 1
accidents[accidents$Casualty.Class == "Passenger",]$Casualty.Class = 2
accidents[accidents$Casualty.Class == "Pedestrian",]$Casualty.Class = 3

# Replace Casualty Severity
accidents[accidents$Casualty.Severity == "Fatal",]$Casualty.Severity = 1
accidents[accidents$Casualty.Severity == "Serious",]$Casualty.Severity = 2
accidents[accidents$Casualty.Severity == "Slight",]$Casualty.Severity = 3

# Replace Sex of Casualty
accidents[accidents$Sex.of.Casualty == "Male",]$Sex.of.Casualty = 1
accidents[accidents$Sex.of.Casualty == "Female",]$Sex.of.Casualty = 2

# Replace Type of Vehicle
Type of Vehicle already numbered

# Age a continuous variable so need to divide into easier categories (e.g. 0-20, 20-30, 30-40 etc)
accidents$Age.of.Casualty[accidents$Age.of.Casualty < 10 & accidents$Age.of.Casualty > 0] <- "0-10"
accidents$Age.of.Casualty[accidents$Age.of.Casualty < 20 & accidents$Age.of.Casualty >= 10] <- "10-20"
accidents$Age.of.Casualty[accidents$Age.of.Casualty < 30 & accidents$Age.of.Casualty >= 20] <- '20-30'
accidents$Age.of.Casualty[accidents$Age.of.Casualty < 40 & accidents$Age.of.Casualty >= 30] <- '30-40'
accidents$Age.of.Casualty[accidents$Age.of.Casualty < 50 & accidents$Age.of.Casualty >= 40] <- '40-50'
accidents$Age.of.Casualty[accidents$Age.of.Casualty < 60 & accidents$Age.of.Casualty >= 50] <- '50-60'
accidents$Age.of.Casualty[accidents$Age.of.Casualty < 70 & accidents$Age.of.Casualty >= 60] <- '60-70'
accidents$Age.of.Casualty[accidents$Age.of.Casualty < 80 & accidents$Age.of.Casualty >= 70] <- '70-80'
accidents$Age.of.Casualty[accidents$Age.of.Casualty < 98 & accidents$Age.of.Casualty >= 80] <- '80+’

# Table of casualties by age
table(accidents$Age.of.Casualty)

# Breakdown of percentages by sex and age
prop.table(table(accidents$Sex.of.Casualty, accidents$Age.of.Casualty),1)

# Barplot of Age
counts <- table(accidents$Age.of.Casualty)
barplot(counts, xlab='Age', ylab='Frequency', ylim=c(0,1000), main='Number of Road Traffic Casualties by Age')

# For Proportion breakdown of gender, for example
prop.table(table(accidents$Sex.of.Casualty))

# Download the data visualisation package ggplot2
install.packages("ggplot2")
library(ggplot2)

# Mosaic plot of Age and Sex of Casualty
mosaicplot(accidents$Age.of.Casualty ~ accidents$Sex.of.Casualty, 
          main="", # Leave the plot title blank
          shade=FALSE, color=TRUE, xlab="Age", ylab="Sex") # Add axis labels

# Create subset for bicycle casualties
bicycles <- subset(accidents, Type.of.Vehicle == 1)

# Write the new subset to a csv file containing the bicycle casualties
write.csv(bicycles, file = "Bicycles.csv")
