
###Initialize variables
siteIDs <- read.csv("siteids.csv", header=F,colClasses = "character")
colnames(siteIDs) <- "Station IDs"

pcodes <- read.csv("pcodes.csv", header=F,colClasses = "character")
colnames(pcodes) <- "pcodes"

