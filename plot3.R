#plot3.R
#Of the four types of sources indicated by the type 
#(point, nonpoint, onroad, nonroad) variable, which of these four sources have 
#seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen 
#increases in emissions from 1999-2008? Use the ggplot2 plotting system to 
#make a plot answer this question.


#Load R Data
NEI <- readRDS("summarySCC_PM25.rds")

NEI_Baltimore_City <- subset(NEI, fips == "24510")

#Subset Data by Year. TODO: Figure out a more elegant way of doing this
NEI99_POINT <- subset(NEI_Baltimore_City, year == 1999 & type == "POINT")
NEI99_NONPOINT <- subset(NEI_Baltimore_City, year == 1999 & type == "NONPOINT")
NEI99_ONROAD <- subset(NEI_Baltimore_City, year == 1999 & type == "ON-ROAD")
NEI99_NONROAD <- subset(NEI_Baltimore_City, year == 1999 & type == "NON-ROAD")

NEI02_POINT <- subset(NEI_Baltimore_City, year == 2002 & type == "POINT")
NEI02_NONPOINT <- subset(NEI_Baltimore_City, year == 2002 & type == "NONPOINT")
NEI02_ONROAD <- subset(NEI_Baltimore_City, year == 2002 & type == "ON-ROAD")
NEI02_NONROAD <- subset(NEI_Baltimore_City, year == 2002 & type == "NON-ROAD")

NEI05_POINT <- subset(NEI_Baltimore_City, year == 2005 & type == "POINT")
NEI05_NONPOINT <- subset(NEI_Baltimore_City, year == 2005 & type == "NONPOINT")
NEI05_ONROAD <- subset(NEI_Baltimore_City, year == 2005 & type == "ON-ROAD")
NEI05_NONROAD <- subset(NEI_Baltimore_City, year == 2005 & type == "NON-ROAD")

NEI08_POINT <- subset(NEI_Baltimore_City, year == 2008 & type == "POINT")
NEI08_NONPOINT <- subset(NEI_Baltimore_City, year == 2008 & type == "NONPOINT")
NEI08_ONROAD <- subset(NEI_Baltimore_City, year == 2008 & type == "ON-ROAD")
NEI08_NONROAD <- subset(NEI_Baltimore_City, year == 2008 & type == "NON-ROAD")


library(ggplot2)
library(reshape) #may need to run install.packages("reshape") for the library to load

#create data frame where columns are type, year1999, year2002, year2005, year2008; 
#row values are total emissions for each year by type 
df <- data.frame(type=unique(NEI_Baltimore_City$type), #type = POINT, NONPOINT, ON-ROAD, NON-ROAD
                 year1999=c(sum(NEI99_POINT$Emissions),
                        sum(NEI99_NONPOINT$Emissions),
                        sum(NEI99_ONROAD$Emissions),
                        sum(NEI99_NONROAD$Emissions)),
                 year2002=c(sum(NEI02_POINT$Emissions),
                        sum(NEI02_NONPOINT$Emissions),
                        sum(NEI02_ONROAD$Emissions),
                        sum(NEI02_NONROAD$Emissions)),
                 year2005=c(sum(NEI05_POINT$Emissions),
                        sum(NEI05_NONPOINT$Emissions),
                        sum(NEI05_ONROAD$Emissions),
                        sum(NEI05_NONROAD$Emissions)),
                 year2008=c(sum(NEI08_POINT$Emissions),
                        sum(NEI08_NONPOINT$Emissions),
                        sum(NEI08_ONROAD$Emissions),
                        sum(NEI08_NONROAD$Emissions))
                 )

#"melt" data so that each row is a unique id-variable combination
dfMelt <- melt(df, id.vars='type') #from reshape library


#Draw grouped barplot - TODO: Figure out how to draw text over bars for ggplot
png(file="plot3.png", width=600, height=480)
g <- ggplot(dfMelt, aes(variable, value)) + 
  geom_bar(aes(fill = type), position = "dodge", stat="identity") +
  scale_x_discrete("Years", labels=unique(NEI_Baltimore_City$year)) +
  ylab("Amount of PM2.5 emitted, in tons") +
  ggtitle("Baltimore City emissions by type (1999-2008)") +
  theme(plot.title=element_text(size=20, face="bold"), 
        axis.title.x=element_text(face="bold"),
        axis.title.y=element_text(face="bold")) 
print(g)
dev.off()


print(paste("Wrote file plot3.png to ", getwd()))
