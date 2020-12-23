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
  BC <- filter(NEI_SCC, fips == "24510")
 
##filtering data set by motor vehicle emission
  index_mv <- grep("[Vv]ehicle", BC$EI.Sector)
  BC_mv <- BC[index_mv,]

##calculate total PM2.5 emission by summing up all emissions per year 
  emission_sum <- setNames(aggregate(BC_mv$Emissions, by=list(BC_mv$year), FUN=sum), 
                           c("Year","Emissions"))
  
##open PNG device: creates "plot5.png" in working directory  
  png(filename = "plot5.png", width = 480*1.5, height = 480*1.5, units = "px")
  
  #barplot
  ggplot(emission_sum, aes(x=as.character(Year), y=Emissions)) + 
          geom_bar(fill=rgb(0.1,0.4,0.5,0.7), stat = "identity") +
          theme_grey(base_size = 20) +
          labs(x = "Years", y = expression("Emissions in tons")) +
          labs(title = "PM2.5 Emissions Baltimore City - Coal Sources") 
  
##close the PNG file device
  dev.off()