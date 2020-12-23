library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)

##reading in data form exdata_data_NEI data set - data folder should be in working directory
  NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
  SCC_class <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")
  
##merge NEI and SCC classification to combined data frame
  NEI_SCC <- merge(cbind(SCC_class, X=rownames(SCC_class)), cbind(NEI, variable=rownames(NEI)))
  # CoalMatches <- grepl("coal",SCC_class$Short.Name,ignore.case=TRUE)
  # subsetSCC <- SCC_class[coalMatches,]
  # NEI_SCC <- merge(NEI,subsetSCC, by ="SCC")

##filtering coal related sources by using grep function in "EI.Sectors"
  index <- grep("[Cc]oal", NEI_SCC$EI.Sector)
  NEI_SCC_Coal <- NEI_SCC[index,]

##calculate total PM2.5 emission by summing up all emissions per year 
  emission_sum <- setNames(aggregate(NEI_SCC_Coal$Emissions, by=list(NEI_SCC_Coal$year), FUN=sum), 
                  c("Year","Emissions"))
    
##open PNG device: creates "plot4.png" in working directory  
  png(filename = "plot4.png", width = 480, height = 480, units = "px")

  #barplot
  ggplot(emission_sum, aes(x=as.character(Year), y=Emissions/10^6)) + 
    geom_bar(fill=rgb(0.1,0.4,0.5,0.7), stat = "identity") +
    theme_grey(base_size = 15) +
    labs(x = "Years", y = expression("Emissions in mega tons")) +
    labs(title = "Total PM2.5 US-Emissions - Coal Sources") 

##close the PNG file device
  dev.off()