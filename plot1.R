#plot1.R
#Using the base plotting system, make a plot showing the total PM2.5 emission 
#from all sources for each of the years 1999, 2002, 2005, and 2008.

#Load R Data
NEI <- readRDS("summarySCC_PM25.rds")

#Subset Data by Year
NEI99 <- subset(NEI, year == 1999)
NEI02 <- subset(NEI, year == 2002)
NEI05 <- subset(NEI, year == 2005)
NEI08 <- subset(NEI, year == 2008)

#Calcuate Total Emissions for each year
em99 <- sum(NEI99$Emissions)
em02 <- sum(NEI02$Emissions)
em05 <- sum(NEI05$Emissions)
em08 <- sum(NEI08$Emissions)

#Get values in millions
emVector = round(c(em99, em02, em05, em08)/1e6, 2)

#Create barplot x-axis=year, y-axis=total emissions
png(file = "plot1.png", width = 600, height = 600)
bp <- barplot(emVector, main="Total PM2.5 Emissions by Year", 
        names.arg=c("1999","2002","2005","2008"),
        ylab="Amount of PM2.5 emitted, in millions of tons",  
        ylim=c(0, 8),
        col = "black")

text(bp, emVector, label=emVector, pos=3, col="red")
dev.off()

print(paste("Wrote file plot1.png to ", getwd()))