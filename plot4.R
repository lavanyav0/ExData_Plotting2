library(dplyr)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
SCC$SCC <- as.character(SCC$SCC)
data <- left_join(NEI,SCC,by="SCC")
data_sn <- unique(data$Short.Name)
coal_combustion_sources <- data_sn[grep("Coal",data_sn)]
coal_combustion_sources <- coal_combustion_sources[grep("Comb",coal_combustion_sources)]
NEI_Coal <- data %>%
  filter(Short.Name %in% coal_combustion_sources) %>%
  group_by(year) %>% 
  summarize(Emissions=sum(Emissions))
years <- as.vector(NEI_Coal$year)
title <- paste("Coal PM2.5 Emissions (",as.character(years[1])," - ",as.character(years[length(years)]),")",sep="")
g <- ggplot(NEI_Coal,aes(x=year,y=Emissions))
print(g + geom_line() + labs(y = "Emissions (in tons)") + labs(title=title))
dev.copy(png,file="plot4.png",width=480,height=480)
dev.off()