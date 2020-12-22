library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)

##reading in data form exdata_data_NEI data set - data folder should be in working directory
  NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
  SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

##checkiing for NAs and negative values in emmission data
  NAs      <- mean(is.na(NEI$Emissions))
  negative <- mean(NEI$Emissions < 0, na.rm = TRUE)
  
##open PNG device: creates "plo1.png" in working directory  
  png(filename = "plot1.png", width = 480*1.5, height = 480*1.5, units = "px")
    
##plot PM2.5 emmissions data for US for years 1999, 2002, 2005  and 2008
  #convert year into factor variable
  NEI <- transform(NEI , year = factor(year))
  boxplot(log10(Emissions) ~ year, NEI, xlab = "Year", ylab = expression("log10 "* PM[2.5]), 
          cex.lab=1, main = "Total PM2.5 US-Emissions in tons", cex.main=1.3)
  
##close the PNG file device
  dev.off()