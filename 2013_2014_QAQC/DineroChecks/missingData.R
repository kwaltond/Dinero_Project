library(QWToolbox)
qwtoolbox("AllsiteIDs.csv")

data_2013_2014 <- subset(.guiEnv$qw.data$PlotTable, SAMPLE_START_DT > as.POSIXct("2013-01-01"))
field <- c("00010","00025","00095","00300","00400")
Q <- "00061"
NWQL <- c("00940","00945")
isotopes <- c("82082","82085")
Alk <- c("00418","29802","63786")
metals <- unique(data_2013_2014$PARM_CD[which(data_2013_2014$PARM_SEQ_GRP_CD %in% c("INM","IMM"))])

FARA <- subset(data_2013_2014,PARM_SEQ_GRP_CD %in% c("INM","IMM"))
FA <- FARA$PARM_CD[grep("wf",FARA$PARM_NM,fixed=TRUE)]
RA <- FARA$PARM_CD[grep("wu",FARA$PARM_NM,fixed=TRUE)]

pcodes_byGroup <- as.data.frame(cbind(FA,RA,field,Q,Alk,NWQL,isotopes))
pcodes_byGroup$FA[duplicated(pcodes_byGroup$FA)] <- NA
pcodes_byGroup$RA[duplicated(pcodes_byGroup$RA)] <- NA
pcodes_byGroup$field[duplicated(pcodes_byGroup$field)] <- NA
pcodes_byGroup$Q[duplicated(pcodes_byGroup$Q)] <- NA
pcodes_byGroup$NWQL[duplicated(pcodes_byGroup$NWQL)] <- NA
pcodes_byGroup$isotopes[duplicated(pcodes_byGroup$isotopes)] <- NA
pcodes_byGroup$Alk[duplicated(pcodes_byGroup$isotopes)] <- NA

missingData <- whatData(qw.data = .guiEnv$qw.data, searchParms = pcodes_byGroup,begin.date = "2013-01-01",end.date = "2014-12-31",groups=TRUE)
write.table(missingData,file="missingData.txt",sep="\t",quote = FALSE,row.names=FALSE)

labidsNWQL <- subset(data_2013_2014, PARM_CD %in% c("00940","00945"))




