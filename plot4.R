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
png(file="plot4.png",width=480,height=480,units="px",bg="transparent")
#Publish plot4.png
par(mfrow=c(2,2),mar=c(4,4,2,1))
#Topleft plot-Time series of global active power
with(data,plot(Date, Global_active_power, 
               type="n", 
               ylab="Global Active Power",
               xlab="",
))
with(data,lines(Date, Global_active_power))
#Topright plot-Time series of voltage
with(data,plot(Date, Voltage, 
               type="n", 
               ylab="Voltage",
               xlab="datetime"
))
with(data,lines(Date, Voltage))
#Bottomleft plot-Time series of sub meterings
with(data,plot(Date, Sub_metering_1, 
               type="n", 
               ylab="Energy sub metering",
               xlab=""
))
with(data,lines(Date, Sub_metering_1))
with(data,lines(Date, Sub_metering_2,col="red"))
with(data,lines(Date, Sub_metering_3,col="blue"))
with(data,legend("topright",legend=colnames(data)[6:8],
                 lty=c(1,1),
                 col=c("black","red","blue"),
                 bty="n",
))
#Bottomright plot-Time series of global reactive power
with(data,plot(Date, Global_reactive_power, 
               type="n", 
               ylab="Global_reactive_power",
               xlab="datetime",
))
with(data,lines(Date, Global_reactive_power))
dev.off()
rm(filename,archivename)
message("plot4.png generated in your working directory")




