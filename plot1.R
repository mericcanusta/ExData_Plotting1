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
png(file="plot1.png",width=480,height=480,units="px")

#Publish plot1.png
with(data,hist(Global_active_power,
               main="Global Active Power",
               xlab="Global Active Power (kilowatts)",
               col="red"))
dev.off()
rm(filename,archivename)
message("plot1.png generated in your working directory")