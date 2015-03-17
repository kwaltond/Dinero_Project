# Note must be run in 32-bit mode for drivers
library(RODBC)
library(lubridate)
library(plyr)
library(xtable)
library(stringr)
library(reshape2)
library(ggplot2)
library(grid)
library(extrafont)
library(USGSwsQW)
loadfonts(device="pdf")
#------ begin user input
# Set the DSN for the nwis database
DSN <- "NWISCO"
# get station IDs
QWsample <- read.delim("qwsample.20141016.155915",header=FALSE,colClasses = "character")

#Get staiton IDs
STAID <- QWsample[[4]]

# Set the range of dates in POSIX format, NOT IMPLEMENTED YET
# set BEGIN to "" to retrieve data from the earliest record
# set END to "" to retrieve data to the most current record
BEGIN <- "2010-05-01 00:00:00"
END <- "2014-09-24 24:00:00"
#------ end of user input

#################################
###Pulls data and formats into a readable table and a melted plot table
Tables <- NWISPullR(STAID)

PlotData <- Tables$PlotTable
TableData <- Tables$DataTable
############################

###Plot timeseries of all parameters. this may take a LONG time depending on number of sites and parameters
PlotR(PlotData)
###############


