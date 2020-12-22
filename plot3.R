library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)

##reading in data form exdata_data_NEI data set - data folder should be in working directory
  NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
  SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

##filter data related to Baltimore City
  NEI_BC <- filter(NEI, fips == "24510")

##open PNG device: creates "plot3.png" in working directory  
  png(filename = "plot3.png", width = 480*1.5, height = 480*1.5, units = "px")

##plot PM2.5 emmissions data for Baltimore City (BC) for years 1999, 2002, 2005  and 2008
  #convert year and type into factor variable
  NEI_BC <- transform(NEI , year = factor(year))
  NEI_BC <- transform(NEI_BC , type = factor(type))
  
  #setup ggplot with data frame
  g <-ggplot(NEI_BC, aes(year,log10(Emissions)))
  #add layers
  g + geom_boxplot(aes(color = type), na.rm = TRUE) + 
      facet_grid(.~type) +
      labs(x = "Years", y = expression("log10 "* PM[2.5])) +
      labs(title = "Total PM2.5 Emissions for Baltimore City in tons - Source Types")

##close the PNG file device
  dev.off()