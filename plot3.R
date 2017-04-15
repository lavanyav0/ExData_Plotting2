library(dplyr)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
NEI_Baltimore <- NEI %>% 
  filter(fips=="24510") %>%
  group_by(type,year) %>% 
  summarize(Emissions=sum(Emissions))
years <- as.vector(unique(NEI_Baltimore$year))
title <- paste("Baltimore PM2.5 Emissions By Type (",as.character(years[1])," - ",as.character(years[length(years)]),")",sep="")
g <- ggplot(NEI_Baltimore,aes(x=year,y=Emissions,group=type,color=type))
print(g + geom_line() + labs(y = "Emissions (in tons)") + labs(title=title))
dev.copy(png,file="plot3.png",width=480,height=480)
dev.off()