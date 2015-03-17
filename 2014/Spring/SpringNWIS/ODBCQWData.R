
NWISPullR <- function(STAID)
{
#Change to a list that SQL can understand. SQL requires a parenthesized list of expressions, so must look like c('05325000', '05330000') for example
STAID.list <- paste("'", STAID, "'", sep="", collapse=",")

# Open the odbc connection
Chan1 <- odbcConnect(DSN)

##################
###DATABASE 1#####
##################
# First get the site info--need column SITE_ID
Query <- paste("select * from ", DSN, ".SITEFILE_01 where site_no IN (", STAID.list, ")", sep="")
SiteFile <- sqlQuery(Chan1, Query, as.is=T)

#get the record numbers
Query <- paste("select * from ", DSN, ".QW_SAMPLE_01 where site_no IN (", STAID.list, ")", sep="")
Samples <- sqlQuery(Chan1, Query, as.is=T)

#get the QWResult file using the record numbers
records.list <- paste("'", Samples$RECORD_NO, "'", sep="", collapse=",")
Query <- paste("select * from ", DSN, ".QW_RESULT_01 where record_no IN (", records.list, ")", sep="")
Results <- sqlQuery(Chan1, Query, as.is=T)
Results$Val_qual <- paste(Results$RESULT_VA,Results$REMARK_CD, sep = " ")
Results$Val_qual <- gsub("NA","",Results$Val_qual)

#Get list of parm names
parms.list <- paste("'", unique(Results$PARM_CD), "'", sep="", collapse=",")

Query <- paste("select * from ", DSN, ".PARM where PARM_CD IN (", parms.list, ")", sep="")
parms <- sqlQuery(Chan1, Query, as.is=T)
parms <- parms[c("PARM_CD","PARM_NM")]

#station names and dates
name_num <- SiteFile[c("SITE_NO","STATION_NM")]
Sample_meta <- join(Samples, name_num,by="SITE_NO")
Sample_meta <- Sample_meta[c("SITE_NO","STATION_NM","SAMPLE_START_DT","MEDIUM_CD","RECORD_NO")]
#join tables so parm names are together
Results<- join(Results,parms,by="PARM_CD")

#Make dataframe as record number and pcode. MUST HAVE ALL UNIQUE PCODE NAMES
DataTable1 <- dcast(Results, RECORD_NO ~ PARM_NM ,value.var = c("Val_qual"))

#fill in record number meta data (statoin ID, name, date, time)
DataTable1 <- join(DataTable1,Sample_meta, by="RECORD_NO")

#reorder columns so meta data is at front
parmcols <- seq(from =1, to =ncol(DataTable1)-4 )
metacols <- seq(from = ncol(DataTable1)-3, to =ncol(DataTable1))
DataTable1 <- DataTable1[c(metacols,parmcols)]
PlotTable1 <- join(Results,Sample_meta,by="RECORD_NO")

##################
###DATABASE 2#####
##################
# First get the site info--need column SITE_ID
Query <- paste("select * from ", DSN, ".SITEFILE_02 where site_no IN (", STAID.list, ")", sep="")
SiteFile <- sqlQuery(Chan1, Query, as.is=T)

#get the record numbers
Query <- paste("select * from ", DSN, ".QW_SAMPLE_02 where site_no IN (", STAID.list, ")", sep="")
Samples <- sqlQuery(Chan1, Query, as.is=T)

#get the QWResult file using the record numbers
records.list <- paste("'", Samples$RECORD_NO, "'", sep="", collapse=",")
Query <- paste("select * from ", DSN, ".QW_RESULT_02 where record_no IN (", records.list, ")", sep="")
Results <- sqlQuery(Chan1, Query, as.is=T)
Results$Val_qual <- paste(Results$RESULT_VA,Results$REMARK_CD, sep = " ")
Results$Val_qual <- gsub("NA","",Results$Val_qual)

#Get list of parm names
parms.list <- paste("'", unique(Results$PARM_CD), "'", sep="", collapse=",")

Query <- paste("select * from ", DSN, ".PARM where PARM_CD IN (", parms.list, ")", sep="")
parms <- sqlQuery(Chan1, Query, as.is=T)
parms <- parms[c("PARM_CD","PARM_NM")]

#station names and dates
name_num <- SiteFile[c("SITE_NO","STATION_NM")]
Sample_meta <- join(Samples, name_num,by="SITE_NO")
Sample_meta <- Sample_meta[c("SITE_NO","STATION_NM","SAMPLE_START_DT","MEDIUM_CD","RECORD_NO")]
#join tables so parm names are together
Results<- join(Results,parms,by="PARM_CD")

#Make dataframe as record number and pcode. MUST HAVE ALL UNIQUE PCODE NAMES
DataTable2 <- dcast(Results, RECORD_NO ~ PARM_NM,value.var = "Val_qual")

#fill in record number meta data (statoin ID, name, date, time)
DataTable2 <- join(DataTable2,Sample_meta, by="RECORD_NO")

#reorder columns so meta data is at front
parmcols <- seq(from =1, to =ncol(DataTable2)-4 )
metacols <- seq(from = ncol(DataTable2)-3, to =ncol(DataTable2))
DataTable2 <- DataTable2[c(metacols,parmcols)]
PlotTable2 <- join(Results,Sample_meta,by="RECORD_NO")

DataTable <- rbind.fill(DataTable1,DataTable2)
PlotTable <- rbind.fill(PlotTable1,PlotTable2)
PlotTable$REMARK_CD <- gsub("NA","",PlotTable$REMARK_CD)
PlotTable$SAMPLE_START_DT <- as.POSIXct(PlotTable$SAMPLE_START_DT)
PlotTable$REMARK_CD[is.na(PlotTable$REMARK_CD)] <- "Sample"
PlotTable$REMARK_CD <- as.factor(PlotTable$REMARK_CD)
PlotTable$REMARK_CD = factor(PlotTable$REMARK_CD,levels(PlotTable$REMARK_CD)[c(4,1:3)])

PlotTable$RESULT_VA <- as.numeric(PlotTable$RESULT_VA)
# Close the connection
odbcClose(Chan1)


return(list(DataTable=DataTable,PlotTable=PlotTable))

}

