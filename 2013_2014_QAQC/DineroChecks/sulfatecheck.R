###Sulfate method check
data_2013_2014 <- subset(.guiEnv$qw.data$PlotTable, SAMPLE_START_DT > as.POSIXct("2013-01-01"))
sulfateData <- subset(data_2013_2014,PARM_CD=="00945") 
write.table(sulfateData,"sulfateData",quote=FALSE,row.names=FALSE,sep="\t")
