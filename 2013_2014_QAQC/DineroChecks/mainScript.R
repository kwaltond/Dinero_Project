library(QWToolbox)
qwtoolbox("AllsiteIDs.csv")
summary <- blankSummary(.guiEnv$qw.data,begin.date = "2013-01-01",multiple.levels = FALSE)

write.table(summary,file="blanksummary.txt",row.names=FALSE,quote=FALSE,sep="\t")

qsummary <- qualitySummary(.guiEnv$qw.data,.guiEnv$reports)
qsummary <- unique(qsummary)
write.table(qsummary,file="qualitysummary.txt",row.names=FALSE,quote=FALSE,sep="\t")

reps <- .guiEnv$qw.data$PlotTable
reps <- subset(reps, MEDIUM_CD %in% c("WSQ","WGQ"))
reps <- unique(reps[c("RECORD_NO","SITE_NO","STATION_NM","SAMPLE_START_DT","MEDIUM_CD","SAMP_TYPE_CD")])

reptable <- reptables()