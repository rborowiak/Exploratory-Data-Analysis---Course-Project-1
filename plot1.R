library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)

##reading in data form exdata_data_NEI data set - data folder should be in working directory
  NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
  SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

##calculate total PM2.5 emission by summing up all emissions per year 
  emission_sum <- setNames(aggregate(NEI$Emissions, by=list(NEI$year), FUN=sum), c("Year","Emissions"))
  #totalEmissions <- tapply(NEI$Emissions,NEI$year,sum)
  
##open PNG device: creates "plot1.png" in working directory  
  png(filename = "plot1.png", width = 480*1.5, height = 480*1.5, units = "px")
    
  #barplot
  barplot(Emissions/1E06 ~ Year, data=emission_sum, main="Total US PM2.5 Emissions", xlab="Year", 
          ylab="Emissions in 10^6 tons", cex.lab=1.5, cex.main=1.3, col="wheat")
  
##close the PNG file device
  dev.off()