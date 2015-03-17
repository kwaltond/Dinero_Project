library(RODBC)
library(lubridate)
library(plyr)
library(xtable)
library(stringr)
library(reshape2)
library(ggplot2)
library(grid)
library(extrafont)

STAID <- scan(STAIDS)

DSN <- "NWISCO"

#Change to a list that SQL can understand. SQL requires a parenthesized list of expressions, so must look like c('05325000', '05330000') for example
STAID.list <- paste("'", STAID, "'", sep="", collapse=",")

# Open the odbc connection
Chan1 <- odbcConnect(DSN)

##################
###DATABASE 1#####
##################

#get the record numbers
Query <- paste("select * from ", DSN, ".QW_SAMPLE_01 where site_no IN (", STAID.list, ")", sep="")
Samples <- sqlQuery(Chan1, Query, as.is=T)


QWSample1 <- data.frame(Samples$RECORD_NO,
                       "*UNSPECIFIED*",
                       Samples$AGENCY_CD,
                       Samples$SITE_NO,
                       strftime(as.POSIXct(Samples$SAMPLE_START_DT,),"%Y%m%d%H%M"),
                       strftime(as.POSIXct(Samples$SAMPLE_END_DT),"%Y%m%d%H%M"),
                       Samples$MEDIUM_CD,
                       Samples$LAB_NO,
                       Samples$PROJECT_CD,
                       Samples$AQFR_CD,
                       Samples$SAMP_TYPE_CD,
                       Samples$ANL_STAT_CD,
                       "",
                       Samples$HYD_COND_CD,
                       Samples$HYD_EVENT_CD,
                       Samples$TU_ID,
                       Samples$BODY_PART_ID,
                       "",
                       "",
                       "",
                       "",
                       Samples$COLL_ENT_CD)
##################
###DATABASE 2#####
##################

#get the record numbers
Query <- paste("select * from ", DSN, ".QW_SAMPLE_02 where site_no IN (", STAID.list, ")", sep="")
Samples <- sqlQuery(Chan1, Query, as.is=T)


QWSample2 <- data.frame(Samples$RECORD_NO,
                        "*UNSPECIFIED*",
                        Samples$AGENCY_CD,
                        Samples$SITE_NO,
                        strftime(as.POSIXct(Samples$SAMPLE_START_DT,),"%Y%m%d%H%M"),
                        strftime(as.POSIXct(Samples$SAMPLE_END_DT),"%Y%m%d%H%M"),
                        Samples$MEDIUM_CD,
                        Samples$LAB_NO,
                        Samples$PROJECT_CD,
                        Samples$AQFR_CD,
                        Samples$SAMP_TYPE_CD,
                        Samples$ANL_STAT_CD,
                        "",
                        Samples$HYD_COND_CD,
                        Samples$HYD_EVENT_CD,
                        Samples$TU_ID,
                        Samples$BODY_PART_ID,
                        "",
                        "",
                        "",
                        "",
                        Samples$COLL_ENT_CD)

QWSample <- rbind(QWSample1,QWSample2)
QWSampleheader <- c("sample.integer",  "user.code",  "agency",  "site.no",	"start.date",	"end.date",	"medium",	"labid",
                    "project.code",	"aquifer.code",	"sample.type",	"analysis.status",	"analysis.source",	"hydrologic.cond",
                    "hydrologic.event",	"tissue",	"body.part",	"lab.comment.",	"field.comment",	"time.datum",	"datum.reliability",
                    "collecting.agency.code")
colnames(QWSample)<-QWSampleheader
QWSample$sample.integer <- paste(QWSample$site.no,QWSample$start.date,QWSample$medium,sep="")
