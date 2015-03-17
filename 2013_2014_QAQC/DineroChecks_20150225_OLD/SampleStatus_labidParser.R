library(RCurl)
library(XML)

siteIDs <- unique(data_2013_2014$SITE_NO)
begin.date <- "20130101"
parsed_ids <- character()

for(i in 1:length(siteIDs))
{
webpage <- getURL(paste("http://wwwnwql.cr.usgs.gov/USGS/sampstatus/index.cfm?t=stationid&q=",siteIDs[i],"&ac=&sd=",begin.date,"&ed=",sep=""))
webpage <- readLines(tc <- textConnection(webpage)); close(tc)
pagetree <- htmlTreeParse(webpage, error=function(...){}, useInternalNodes = TRUE)
# parse the tree by tables
x <- xpathSApply(pagetree, "//*/table", xmlValue)  
# do some clean up with regular expressions
x <- unlist(strsplit(x, "\n"))
x <- gsub("\t","",x)
x <- sub("^[[:space:]]*(.*?)[[:space:]]*$", "\\1", x, perl=TRUE)
x <- x[!(x %in% c("", "|"))]

parsed_ids <- append(parsed_ids,x[which(nchar(x)==11)])
}


parsed_ids <- as.numeric(parsed_ids)
parsed_ids <- na.omit(parsed_ids)
parsed_ids <- as.character(parsed_ids)

write.table(parsed_ids,file="labIDS.txt",sep="\t")
