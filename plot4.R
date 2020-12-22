library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)

##reading in data form exdata_data_NEI data set - data folder should be in working directory
  NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
  SCC_class <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")
  
##merge NEI and SCC classification to combined data frame
  NEI_SCC <- merge(cbind(SCC_class, X=rownames(SCC_class)), cbind(NEI, variable=rownames(NEI)))

##filtering coal related sources by using grep function in "EI.Sectors"
  index <- grep("[Cc]oal", NEI_SCC$EI.Sector)
  NEI_SCC_Coal <- NEI_SCC[index,]
  
##open PNG device: creates "plot4.png" in working directory  
  png(filename = "plot4.png", width = 480, height = 480, units = "px")

##plot PM2.5 emmissions data for US for coal combustion related sources
  NEI_SCC_Coal  <- transform(NEI_SCC_Coal, year = factor(year))
  boxplot(log10(Emissions) ~ year, NEI_SCC_Coal, xlab = "Year", ylab = expression("log10 "* PM[2.5]), 
          cex.lab=1, main = "Total PM2.5 US-Emissions in tons - Coal Combustion Sources", cex.main=1.3)

##close the PNG file device
  dev.off()