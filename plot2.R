#plot2.R
#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
#(fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
#plot answering this question.

#Load R Data
NEI <- readRDS("summarySCC_PM25.rds")

NEI_Baltimore_City <- subset(NEI, fips == "24510")

#Subset Data by Year
NEI99 <- subset(NEI_Baltimore_City, year == 1999)
NEI02 <- subset(NEI_Baltimore_City, year == 2002)
NEI05 <- subset(NEI_Baltimore_City, year == 2005)
NEI08 <- subset(NEI_Baltimore_City, year == 2008)

#Calcuate Total Emissions for each year
em99 <- sum(NEI99$Emissions)
em02 <- sum(NEI02$Emissions)
em05 <- sum(NEI05$Emissions)
em08 <- sum(NEI08$Emissions)

#Get values in tons
emVector = round(c(em99, em02, em05, em08), 2)

#Create barplot x-axis=year, y-axis=total emissions
png(file = "plot2.png", width = 600, height = 600)
bp <- barplot(emVector, main="Total PM2.5 Emissions by Year for Baltimore City, MD", 
        names.arg=c("1999","2002","2005","2008"),
        ylab="Amount of PM2.5 emitted, in tons",  
        ylim=c(0, 4000),
        col = "black")

text(bp, emVector, label=emVector, pos=3, col="red")
dev.off()

print(paste("Wrote file plot2.png to ", getwd()))