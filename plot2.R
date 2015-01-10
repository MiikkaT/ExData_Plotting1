## PLOT 2
## This script constructs the plot 2 and saves it to a PNG file in a
## working directory. First (if-else structure), it checks whether the
## required data alredy exist in the working directory. If not, it
## will download it using the given URL. For the unzipping procedure,
## I have used the code given here:

shell.exec("https://www.ocf.berkeley.edu/~mikeck/?p=688")

## After the data is read, the script will first convert the
## Date and Time variables to Date/Time classes and then construct 
## and save the plot 1.  
## I'm using default fonts, font sizes and line widths

require(data.table) # The script uses data-table package to read in the data

if(file.exists("household_power_consumption.txt")){
        dtime <- difftime(as.POSIXct("2007-02-03"),
                          as.POSIXct("2007-02-01"),units="mins")
        rowsToRead <- as.numeric(dtime)
        data <- fread("household_power_consumption.txt",
                      skip="1/2/2007", nrows = rowsToRead, na.strings = c("?", ""))
        setnames(data, colnames(fread("household_power_consumption.txt", nrows=0)))
} else {
        fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        # create a temporary directory
        td <- tempdir()
        # create the placeholder file
        tf <- tempfile(tmpdir=td, fileext=".zip")
        # download into the placeholder file
        download.file(fileURL, tf)
        fname <- unzip(tf, list=TRUE)$Name[1]
        # unzip the file to the temporary directory
        unzip(tf, files=fname, exdir=td, overwrite=TRUE)
        # fpath is the full path to the extracted file
        fpath <- file.path(td, fname)
        dtime <- difftime(as.POSIXct("2007-02-03"),
                          as.POSIXct("2007-02-01"),units="mins")
        rowsToRead <- as.numeric(dtime)
        data <- fread(fpath, skip="1/2/2007", nrows = rowsToRead,
                      na.strings = c("?", ""))
        setnames(data, colnames(fread(fpath, nrows=0)))
        
        unlink(td) # this deletes the temporary directory
}

Dates <- as.Date(data$Date, format="%d/%m/%Y")
Times <- data$Time
DateTime <- as.POSIXct(paste(as.character(Dates),as.character(Times)))
DateTime<-strptime(DateTime,"%Y-%m-%d %H:%M:%S")

Sys.setlocale("LC_TIME", "English")     # In case your computer is not a native
                                        # English speaker

png(file="plot2.png")
plot(DateTime,data$Global_active_power,type="l",xlab="",
     ylab="Global Active Power (kilowatts)")
dev.off()



