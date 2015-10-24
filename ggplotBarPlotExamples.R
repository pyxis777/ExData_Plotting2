#=============================================
dat <- data.frame(country=c('USA','Brazil','Ghana','England','Australia'), Stabbing=c(15,10,9,6,7), Accidents=c(20,25,21,28,15), Suicide=c(3,10,7,8,6))

#horizontal
mm <- melt(dat, id.vars='country')
ggplot(mm, aes(x=country, y=value)) + geom_bar(stat='identity') + facet_grid(.~variable) + coord_flip() + labs(x='',y='')

#vertical
ggplot(mm, aes(variable, value)) + 
  geom_bar(aes(fill = country), position = "dodge", stat="identity")
#=============================================





#Get counts for each category by type

raw <- read.csv("http://pastebin.com/raw.php?i=L8cEKcxS",sep=",")
#raw[,2]<-factor(raw[,2],levels=c("Very Bad","Bad","Good","Very Good"),ordered=FALSE)
#raw[,3]<-factor(raw[,3],levels=c("Very Bad","Bad","Good","Very Good"),ordered=FALSE)
#raw[,4]<-factor(raw[,4],levels=c("Very Bad","Bad","Good","Very Good"),ordered=FALSE)

raw=raw[,c(2,3,4)] # getting rid of the "people" variable as I see no use for it

freq=table(col(raw), as.matrix(raw)) # get the counts of each factor level

Names=c("Food","Music","People")     # create list of names
data=data.frame(cbind(freq),Names)   # combine them into a data frame
data=data[,c(5,3,1,2,4)]             # sort columns

# melt the data frame for plotting
data.m <- melt(data, id.vars='Names')

# plot everything
ggplot(data.m, aes(Names, value)) +   
  geom_bar(aes(fill = variable), position = "dodge", stat="identity")
