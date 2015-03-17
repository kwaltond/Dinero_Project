RA <- data_2013_2014$PARM_CD[grep("wu",data_2013_2014$PARM_NM,fixed=TRUE)]
RA <- unique(RA)
RA_names <- data_2013_2014$PARM_NM[which(data_2013_2014$PARM_CD %in% RA)]
RA_names <- unique(RA_names)

FA <- data_2013_2014$PARM_CD[grep("wf",data_2013_2014$PARM_NM,fixed=TRUE)]
FA <- unique(FA)
FA_names <- data_2013_2014$PARM_NM[which(data_2013_2014$PARM_CD %in% FA)]
FA_names <- unique(FA_names)




unique(data_2013_2014$PARM_NM)

names(pcodes) <- "PARM_CD"
RA <- as.data.frame(RA)
names(RA) <- "PARM_CD"
RA <- join(RA,data_2013_2014[c("PARM_CD","PARM_NM")],by="PARM_CD")
RA <- unique(RA)

write.table(RA,"RAs.txt",row.names=FALSE,quote=FALSE,sep="\t")
missingcodes <- subset(RA,!(PARM_CD %in% pcodes$PARM_CD))

names(pcodes) <- "PARM_CD"
FA <- as.data.frame(FA)
names(FA) <- "PARM_CD"
FA <- join(FA,data_2013_2014[c("PARM_CD","PARM_NM")],by="PARM_CD")
FA <- unique(FA)

write.table(FA,"FAs.txt",row.names=FALSE,quote=FALSE,sep="\t")
missingcodes <- subset(FA,!(PARM_CD %in% pcodes$PARM_CD))


library(dataRetrieval) #Load the library

###Type in your analyte of interest, not case sensitive
analyte <- "hafnium"

#####Run these two lines
parameters <- readNWISpCode("all")
ironparms <- parameters[grep(analyte,parameters$parameter_nm,ignore.case=TRUE),]
