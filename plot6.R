library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)

##reading in data form exdata_data_NEI data set - data folder should be in working directory
  NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
  SCC_class <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

##merge NEI and SCC classification to combined data frame
  NEI_SCC <- merge(cbind(SCC_class, X=rownames(SCC_class)), cbind(NEI, variable=rownames(NEI)))

##filtering data set by motor vehicle emission
  index_mv <- grep("[Vv]ehicle", NEI_SCC$EI.Sector)
  NEI_SCC_mv <- NEI_SCC[index_mv,]

##filter data related to Baltimore City and Los Angeles County
  BC_LA_mv <- filter(NEI_SCC_mv, fips %in% c("24510", "06037"))
  
##replace fips code by county name
  BC_LA_mv <- rename(BC_LA_mv, County = fips)
  BC_LA_mv$County <- gsub("24510", "Baltimore City", BC_LA_mv$County)
  BC_LA_mv$County <- gsub("06037", "LA County", BC_LA_mv$County)
  
##open PNG device: creates "plot5.png" in working directory  
  png(filename = "plot6.png", width = 480, height = 480, units = "px")

##plot PM2.5 emmissions data related to motor vehicle
  BC_LA_mv  <- transform(BC_LA_mv, year = factor(year))
  BC_LA_mv  <- transform(BC_LA_mv, County = factor(County))
  qplot(year, log10(Emissions), data = BC_LA_mv, color = County,
        facets = . ~ County, geom = "boxplot", main = "County-Comparison PM2.5-Emissions in tons - Motor vehicles", 
        xlab="Year", ylab= expression("log10 "* PM[2.5]))

##close the PNG file device
  dev.off()