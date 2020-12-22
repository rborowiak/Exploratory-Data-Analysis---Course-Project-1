library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)

##reading in data form exdata_data_NEI data set - data folder should be in working directory
  NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
  SCC_class <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

##merge NEI and SCC classification to combined data frame
 NEI_SCC <- merge(cbind(SCC_class, X=rownames(SCC_class)), cbind(NEI, variable=rownames(NEI)))

##filter data related to Baltimore City
 NEI_SCC_BC <- filter(NEI_SCC, fips == "24510")
 
##filtering data set by motor vehicle emission
  index_mv <- grep("[Vv]ehicle", NEI_SCC_BC$EI.Sector)
  NEI_SCC_BC_mv <- NEI_SCC_BC[index_mv,]

##open PNG device: creates "plot5.png" in working directory  
  png(filename = "plot5.png", width = 480, height = 480, units = "px")

##plot PM2.5 emmissions data related to motor vehicle
  NEI_SCC_BC_mv  <- transform(NEI_SCC_BC_mv, year = factor(year))
  boxplot(log10(Emissions) ~ year, NEI_SCC_BC_mv, xlab = "Year", ylab = expression("log10 "* PM[2.5]), 
        cex.lab=1, main = "Total PM2.5 US-Emissions Baltimore City in tons - Motor vehicles", cex.main=1)

##close the PNG file device
  dev.off()