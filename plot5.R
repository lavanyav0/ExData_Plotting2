library(dplyr)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
SCC$SCC <- as.character(SCC$SCC)
data <- left_join(NEI,SCC,by="SCC")
data_sn <- unique(data$Short.Name)
motor_sources <- data_sn[grep("Motor|Veh",data_sn)]
NEI_Balt_Motor <- data %>%
  filter(fips=="24510" & Short.Name %in% motor_sources) %>%
  group_by(year) %>% 
  summarize(Emissions=sum(Emissions))
years <- as.vector(NEI_Balt_Motor$year)
title <- paste("Baltimore Motor PM2.5 Emissions (",as.character(years[1])," - ",as.character(years[length(years)]),")",sep="")
g <- ggplot(NEI_Balt_Motor,aes(x=year,y=Emissions))
print(g + geom_line() + labs(y = "Emissions (in tons)") + labs(title=title))
dev.copy(png,file="plot5.png",width=480,height=480)
dev.off()