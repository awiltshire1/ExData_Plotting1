# load lubridate for easy date/time conversion 
library(lubridate)

# load dplyr for tibble functions / chaining
library(dplyr)

# download & unzip data file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile="./data/exdata_data_household_power_consumption.zip",method="curl")
unzip("./data/exdata_data_household_power_consumption.zip", exdir="./data")

# read data file & convert to tibble
power <- as_tibble(read.table("./data/household_power_consumption.txt",
                              header = TRUE, sep = ";", na.strings = "?"))

# convert date/time chars to date/time objects
# reorder cols & remove char date & time cols
# select only data from 2007-02-01 & 2007-02-02
power <- power %>%
  mutate(DateTime = dmy_hms(paste(Date, Time))) %>%
  select(DateTime, Global_active_power:Sub_metering_3) %>%
  filter((DateTime >= ymd("2007-02-01")) & (DateTime < ymd("2007-02-03")))

# open png graphics device
png(file = "./plot2.png", height = 480, width = 480)

# construct plot 2 using base R graphics
par(mar = c(4, 4, 3, 1), cex = 0.9)
plot(power$DateTime, power$Global_active_power, type = "l",
     xlab = "", ylab = "Global Active Power (kilowatts)")

# close png graphics device
dev.off()
