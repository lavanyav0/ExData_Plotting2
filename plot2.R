library(dplyr)
NEI <- readRDS("summarySCC_PM25.rds")
NEI_Baltimore <- NEI %>% 
  filter(fips=="24510") %>%
  group_by(year) %>% 
  summarize(Emissions=sum(Emissions))
years <- as.vector(NEI_Baltimore$year)
title <- paste("Baltimore PM2.5 Emissions (",as.character(years[1])," - ",as.character(years[length(years)]),")",sep="")
plot(NEI_Baltimore,type="l",ylab="Emissions (in tons)",main=title)
dev.copy(png,file="plot2.png",width=480,height=480)
dev.off()