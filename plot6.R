library(dplyr)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
SCC$SCC <- as.character(SCC$SCC)
data <- left_join(NEI,SCC,by="SCC")
data_sn <- unique(data$Short.Name)
motor_sources <- data_sn[grep("Motor|Veh",data_sn)]
NEI_Balt_LA_Motor <- data %>%
  filter((fips=="24510"|fips=="06037") & Short.Name %in% motor_sources) %>%
  group_by(fips,year) %>% 
  summarize(Emissions=sum(Emissions))
fips <- as.vector(NEI_Balt_LA_Motor$fips)
cities <- as.vector(sapply(fips,function(x) if(x=="24510") "Baltimore" else "Los Angeles"))
NEI_Balt_LA_Motor$city_name <- cities
years <- as.vector(unique(NEI_Balt_LA_Motor$year))
title <- paste("Baltimore vs Los Angeles Motor PM2.5 Emissions (",as.character(years[1])," - ",as.character(years[length(years)]),")",sep="")
g <- ggplot(NEI_Balt_LA_Motor,aes(x=year,y=Emissions,group=city_name,color=city_name))
print(g + geom_line() + labs(y = "Emissions (in tons)") + labs(title=title))
dev.copy(png,file="plot6.png",width=480,height=480)
dev.off()