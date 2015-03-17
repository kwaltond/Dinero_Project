library(QWToolbox)

qwtoolbox("AllsiteIDs.csv")

QAdata <- .guiEnv$reports
repdata <- QAdata$repTable
fildata <- QAdata$wholevpartTable
qw.data <-.guiEnv$qw.data
plotdata <- qw.data$PlotTable
###Check for missing data
parmfile <- read.csv("parametergroups.csv",colClasses="character",header=TRUE,na.strings="")
parmfile <- parmfile[,c(1:8)]

missingData <- whatData(qw.data=qw.data,
												searchParms = parmfile,
												begin.date = "2013-01-01",
												end.date="2014-12-31",
												groups=TRUE)
write.table(missingData,"Dinero_2013_2014_missingData_20150223.txt",sep="\t")

missingiso <- subset(plotdata, RECORD_NO == "01305854")
