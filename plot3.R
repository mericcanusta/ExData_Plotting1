archivename<-"exdata_data_household_power_consumption.zip"
filename<-"household_power_consumption.txt"
#Check if file exists in the working directory, otherwise download
#Requires curl for non-Windows platforms
if(!file.exists(archivename)){
    DownloadMethods<-c("internal","curl")
    fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileurl,archivename,mode="wb",method=DownloadMethods[2-as.numeric(.Platform$OS.type=="windows")])
    rm(fileurl,DownloadMethods)
}
#Read the zipped data
data <- read.table(file = unz(archivename,filename), 
                   sep = ";", 
                   colClasses=c(rep("character",2),rep("numeric",7)),
                   na.strings="?", 
                   header=T)
#Subset the data for the dates of interest
data <- data[grep("^[1-2]/2/2007",data$Date),]
rownames(data)<-seq(nrow(data))
#Convert Date+Time into a PosIXct
data$Date<-as.POSIXct(paste(data$Date,data$Time),
                      format="%d/%m/%Y %H:%M:%S")
data <- data[,-2]
png(file="plot3.png",width=480,height=480,units="px")

#Publish plot3.png
with(data,plot(Date, Sub_metering_1, 
                              type="n", 
                              ylab="Energy sub metering",
                              main=NULL))
with(data,lines(Date, Sub_metering_1))
with(data,lines(Date, Sub_metering_2,col="red"))
with(data,lines(Date, Sub_metering_3,col="blue"))
with(data,legend("topright",legend=colnames(data)[6:8],
                 lty=c(1,1),
                 col=c("black","red","blue"),
                  ))
dev.off()
rm(filename,archivename)
message("plot3.png generated in your Working directory")