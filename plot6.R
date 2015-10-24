#plot6.R
#Compare emissions from motor vehicle sources in Baltimore City with emissions 
#from motor vehicle sources in Los Angeles County, California (fips == "06037").
#Which city has seen greater changes over time in motor vehicle emissions?

#Load R Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Get all SCC where emissions are from motor vehicles
mvSCC <- SCC[grep("vehicles", SCC$Short.Name, ignore.case=T), c("SCC", "Short.Name")]

#Subset all emissions data where emissions are from coal combustion 
#and fips = Baltimore City, MD or Los Angeles County, CA 
dfMvBaltAndLA <- subset(NEI, fips %in% c("24510", "06037") & SCC %in% mvSCC$SCC)

#Subset Data by Year. TODO: Figure out a more elegant way of doing this
NEI99_Batimore <- subset(dfMvBaltAndLA, year == 1999 & fips == "24510")
NEI99_LA <- subset(dfMvBaltAndLA, year == 1999 & fips == "06037")

NEI02_Batimore <- subset(dfMvBaltAndLA, year == 2002 & fips == "24510")
NEI02_LA <- subset(dfMvBaltAndLA, year == 2002 & fips == "06037")

NEI05_Batimore <- subset(dfMvBaltAndLA, year == 2005 & fips == "24510")
NEI05_LA <- subset(dfMvBaltAndLA, year == 2005 & fips == "06037")

NEI08_Batimore <- subset(dfMvBaltAndLA, year == 2008 & fips == "24510")
NEI08_LA <- subset(dfMvBaltAndLA, year == 2008 & fips == "06037")

library(ggplot2)
library(reshape) #may need to run install.packages("reshape") for the library to load
library(Rmisc) # may ned to run install.packages("Rmisc") for the library to load

#create data frame where columns are city, year1999, year2002, year2005, year2008; 
#row values are total emissions for each year by city 
df1 <- data.frame(city=c("Baltimore, MD", "Los Angeles, CA"),
                 year1999=c(totalBalt99 <- sum(NEI99_Batimore$Emissions),
                            totalLA99 <- sum(NEI99_LA$Emissions)),
                 year2002=c(totalBalt02 <- sum(NEI02_Batimore$Emissions),
                            totalLA02 <- sum(NEI02_LA$Emissions)),
                 year2005=c(totalBalt05 <-sum(NEI05_Batimore$Emissions),
                            totalLA05 <- sum(NEI05_LA$Emissions)),
                 year2008=c(totalBalt08 <-sum(NEI08_Batimore$Emissions),
                            totalLA08 <- sum(NEI08_LA$Emissions))
                )

#"melt" data so that each row is a unique id-variable combination
dfMelt1 <- melt(df1, id.vars='city') #from reshape library

#Calculate percent change in emissions between 1999 and 2008 
percentChange_Baltimore = ((totalBalt08 - totalBalt99)/totalBalt99) * 100
percentChange_LA = ((totalLA08 - totalLA99)/totalLA99) * 100
  
df2 <- data.frame(city=c("Baltimore, MD", "Los Angeles, CA"),
                  percentChange=c(percentChange_Baltimore, percentChange_LA))

dfMelt2 <- melt(df2, id.vars='city') #from reshape library

#Draw grouped barplots Total emissions and Percent change
#TODO: Figure out how to draw text over bars for ggplot
png(file="plot6.png", width=800, height=480)
g1 <- ggplot(dfMelt1, aes(variable, value)) + 
  geom_bar(aes(fill = city), position = "dodge", stat="identity") +
  scale_x_discrete("Years", labels=unique(dfMvBaltAndLA$year)) +
  ylab("Amount of PM2.5 emitted, in tons") +
  ggtitle("Motor Vehicle emissions (1999-2008)") 


g2 <- ggplot(dfMelt2, aes(variable, value)) + 
  geom_bar(aes(fill = city), position = "dodge", stat="identity") +
  scale_x_discrete("", labels="") +
  scale_y_continuous(limits=c(-70, 70)) +
  ylab("Percent change in PM2.5 emitted") +
  ggtitle("Percent Change for Motor Vehicle emissions (1999-2008)") 


myplots <- multiplot(g1, g2, cols=2) #> multiplot from package Rmisc
print(myplots)
dev.off()


print(paste("Wrote file plot6.png to ", getwd()))

