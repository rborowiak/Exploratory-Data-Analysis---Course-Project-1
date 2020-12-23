library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)

##reading in data form exdata_data_NEI data set - data folder should be in working directory
  NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
  SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

##filter data related to Baltimore City
  NEI_BC <- filter(NEI, fips == "24510")

##calculate total PM2.5 emission by summing up all emissions per year 
  emission_sum <- setNames(aggregate(NEI_BC$Emissions, by=list(NEI_BC$year), FUN=sum), c("Year","Emissions"))
  
##open PNG device: creates "plot2.png" in working directory  
  png(filename = "plot2.png", width = 480*1.5, height = 480*1.5, units = "px")
  
  #barplot
  barplot(Emissions ~ Year, data=emission_sum, main="Total PM2.5 Emissions Baltimore City", 
          xlab="Year", ylab="PM2.5 Emissions in tons", cex.lab=1.5, cex.main=1.3, col="wheat")
  
##close the PNG file device
  dev.off()