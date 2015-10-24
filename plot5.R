#plot5.R
#How have emissions from motor vehicle sources changed from 1999-2008 in
#Baltimore City?

#Load R Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Get all SCC where emissions are from motor vehicles
mvSCC <- SCC[grep("vehicles", SCC$Short.Name, ignore.case=T), c("SCC", "Short.Name")]

#Subset all emissions data where emissions are from coal combustion and fips = Baltimore City, MD
dfMvBaltimore <- subset(NEI, fips == "24510" & SCC %in% mvSCC$SCC)

#Subset Data by Year
NEI99 <- subset(dfMvBaltimore, year == 1999)
NEI02 <- subset(dfMvBaltimore, year == 2002)
NEI05 <- subset(dfMvBaltimore, year == 2005)
NEI08 <- subset(dfMvBaltimore, year == 2008)

#Calcuate Total Emissions for each year
em99 <- sum(NEI99$Emissions)
em02 <- sum(NEI02$Emissions)
em05 <- sum(NEI05$Emissions)
em08 <- sum(NEI08$Emissions)

#Get values in tons
emVector = round(c(em99, em02, em05, em08), 2)

#Create barplot x-axis=year, y-axis=total emissions
png(file = "plot5.png", width = 600, height = 600)
bp <- barplot(emVector, main="Total PM2.5 Emissions from Motor Vehicles by Year for Baltimore City, MD", 
              names.arg=c("1999","2002","2005","2008"),
              ylab="Amount of PM2.5 emitted, in tons",  
              ylim=c(0, 100),
              col = "black")

text(bp, emVector, label=emVector, pos=3, col="red")
dev.off()

print(paste("Wrote file plot5.png to ", getwd()))