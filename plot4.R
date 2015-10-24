#plot4.R
#Across the United States, how have emissions from coal combustion-related 
#sources changed from 1999-2008?


#Load R Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Get all SCC where emissions are from combustion
combSCC <- SCC[grep("comb", SCC$Short.Name, ignore.case=T), c("SCC", "Short.Name")]

#Get all SCC where emissions are from coal combustion
coalSCC <- combSCC[grep("coal", combSCC$Short.Name, ignore.case=T),]


#Subset all emissions data where emissions are from coal combustion
dfCoal <- subset(NEI, SCC %in% coalSCC$SCC)

#Subset Data by Year
NEI99 <- subset(dfCoal, year == 1999)
NEI02 <- subset(dfCoal, year == 2002)
NEI05 <- subset(dfCoal, year == 2005)
NEI08 <- subset(dfCoal, year == 2008)

#Calcuate Total Emissions for each year
em99 <- sum(NEI99$Emissions)
em02 <- sum(NEI02$Emissions)
em05 <- sum(NEI05$Emissions)
em08 <- sum(NEI08$Emissions)

#Get values in millions
emVector = round(c(em99, em02, em05, em08)/1e6, 2)

#Create barplot x-axis=year, y-axis=total emissions
png(file = "plot4.png", width = 600, height = 600)
bp <- barplot(emVector, main="Total PM2.5 Emissions from Coal Combustion by Year", 
              names.arg=c("1999","2002","2005","2008"),
              ylab="Amount of PM2.5 emitted, in millions of tons",  
              ylim=c(0, 1),
              col = "black")

text(bp, emVector, label=emVector, pos=3, col="red")
dev.off()

print(paste("Wrote file plot4.png to ", getwd()))