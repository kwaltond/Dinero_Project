library(RGtk2)
library(gWidgetsRGtk2)
library(USGSwsQW)
library(cairoDevice)
library(reshape2)
library(plyr)
###Initialize variables
siteIDs <- read.csv("siteids.csv", header=F,colClasses = "character")
colnames(siteIDs) <- "Station IDs"

pcodes <- read.csv("pcodes.csv", header=F,colClasses = "character")
colnames(pcodes) <- "pcodes"

sitenumber <- siteIDs[1,1]
sitedata <- readNWISqw(sites = 401723105394800, params = scan("pcodes.csv",what="character"), begin.date = "", end.date = "")
