#########################################################
###########NWIS UploadeR v1.0############################
###########T. Joe Mills, USGS SCEP#######################
###########CO WSC, tmills@usgs.gov#######################
#########################################################

#########################################################
##########Requires some additional packages##############
##########install them and initialize here###############
library(plyr)
library(RODBC)
library(reshape2)
#########################################################
#########################################################
#########################################################


##########################################################
#############Read in your data############################
##########################################################
labfile <- "Labdata.csv"
pcodefile <- "pcodefile.csv"
DSN <- "NWISCO"
censor = TRUE
loggedin = FALSE
##########################################################
##########################################################
##########################################################
###For samples not logged in, manual QWsample inputs
agencycode <- "USGS"
labid <- NA
projectcode <- NA
aquifercode <- NA
analysisstatus <- "U"
analysissource <- NA
hydrologiccond <- "A"
hydrologicevent <- 9
tissue <- NA
bodypart <- NA
labcomment <- NA         
fieldcomment <- NA
timedatum <- NA
datumreliability <- NA 
colagencycode <- "USGS-BRD"
#####################################################################
############Run the function, censoring censors result to reporting
############limit and applies a "<" code, default is TRUE###########
####################################################################
nwisupload(DSN,
           labfile,
           pcodefile,
           censor,
           loggedin,
           agencycode,
           labid,
           projectcode,
           aquifercode,
           analysisstatus,
           analysissource,
           hydrologiccond,
           hydrologicevent,
           tissue,
           bodypart,
           labcomment,    
           fieldcomment,
           timedatum,
           datumreliability,
           colagencycode)
#####################################################################
#####################################################################
#####################################################################




#############################################################################
#############This is the function for perofrming hte upload, compile this####
#############DO NOT TOUCH!!, NO USER EDITS ARE NEEDED BELOW THIS POINT#######
#############################################################################
nwisupload <- function(DSN,
                       labfile,
                       pcodefile,
                       censor = FALSE,
                       loggedin = FALSE,
                       agencycode = "USGS",
                       labid = NA,
                       projectcode = NA,
                       aquifercode = NA,
                       analysisstatus = NA,
                       analysissource = NA,
                       hydrologiccond = "A",
                       hydrologicevent = 9,
                       tissue = NA,
                       bodypart = NA,
                       labcomment = NA,    
                       fieldcomment = NA,
                       timedatum = NA,
                       datumreliability = NA,
                       colagencycode = "USGS"){
  
  data<-read.csv(labfile,header=TRUE,
                 colClasses = c("character","character","character","character"),na.strings = "NA")
  numdatacols <- ncol(data)-4  
  data<-read.csv(labfile,header=TRUE,
                 colClasses = c("character","character","character","character",rep("numeric",numdatacols)),na.strings = "NA")
  
  pcodedata <- read.csv(pcodefile,header=TRUE,
                        colClasses = "character",na.strings = "NA")
  
  STAID <- data[[1]]
  
  #Change to a list that SQL can understand. SQL requires a parenthesized list of expressions, so must look like c('05325000', '05330000') for example
  STAID.list <- paste("'", STAID, "'", sep="", collapse=",")
  
  if (loggedin == TRUE)
  {
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
  
  qwsample <- rbind(QWSample1,QWSample2)
  qwsampleheader <- c("sample.integer",  "user.code",  "agency",  "site.no",  "start.date",	"end.date",	"medium",	"labid",
                      "project.code",	"aquifer.code",	"sample.type",	"analysis.status",	"analysis.source",	"hydrologic.cond",
                      "hydrologic.event",	"tissue",	"body.part",	"lab.comment.",	"field.comment",	"time.datum",	"datum.reliability",
                      "collecting.agency.code")
  colnames(qwsample)<-qwsampleheader
  qwsample$UID <- paste(qwsample$site.no,qwsample$start.date,qwsample$medium,sep="")
  
  }
  if (loggedin == FALSE)
  {
       
    ###Manual QWSample generator
    
    qwsample <- matrix(nrow=nrow(data),ncol=22)
    qwsample <- (as.data.frame(qwsample))
    names(qwsample) <-  c("sample.integer","user.code","agency","site.no","start.date","end.date","medium",
                          "labid","project.code","aquifer.code","sample.type","analysis.status",       
                          "analysis.source","hydrologic.cond","hydrologic.event","tissue","body.part","lab.comment.",          
                          "field.comment","time.datum","datum.reliability","collecting.agency.code") 
    qwsample$sample.integer <- seq(1:nrow(qwsample))
    qwsample$user.code <- "*UNSPECIFIED*"
    qwsample$agency <- agencycode
    qwsample$site.no <- data$USGS.SID
    qwsample$start.date <- paste(data$Sample.date..yyyymmdd.,data$Sample.time..hhmm.,sep="")
    qwsample$end.date <- NA
    qwsample$medium <- data$medium.code
    qwsample$labid <- labid
    qwsample$project.code <- projectcode
    qwsample$aquifer.code <- aquifercode
    ###Get proper coding for sample type
    data$UID <- paste(data$USGS.SID, data$Sample.date..yyyymmdd.)
    qwsample$UID <- paste(data$USGS.SID,data$Sample.date..yyyymmdd.)
    for (i in 1:nrow(data))
    {
      if(qwsample$medium[i] == "OAQ")
      {
        qwsample$sample.type[i] <- 2
      } else if (qwsample$medium[i] == "WSQ" | qwsample$medium[i] == "WGQ")
      {
        qwsample$sample.type[i] <- 7
      } else if(qwsample$medium[i] == "WS" | qwsample$medium[i] == "WG")
      {
        if (qwsample$UID[i] %in% qwsample$UID[which(qwsample$medium == "WSQ" | qwsample$medium == "WGQ")] )
        {
          qwsample$sample.type[i] <- 7
        } else (qwsample$sample.type[i] <- 9)
      }
    }
    data$UID <- NULL
    qwsample$UID <- NULL
    ############################################
    qwsample$analysis.status <- analysisstatus
    qwsample$analysis.source <- analysissource
    qwsample$hydrologic.cond <- hydrologiccond
    qwsample$hydrologic.event <- hydrologicevent
    qwsample$tissue <- tissue
    qwsample$body.part <- bodypart
    qwsample$lab.comment. <- labcomment         
    qwsample$field.comment <- fieldcomment
    qwsample$time.datum <- timedatum
    qwsample$datum.reliability <- datumreliability
    qwsample$collecting.agency.code <- colagencycode
    qwsample$UID <- paste(qwsample$site.no,qwsample$start.date,qwsample$medium,sep="")
    
  }
  
  meltdata<-melt(data,id.vars=colnames(data[,1:4]))
  meltdata$variable <- (gsub("X", "", meltdata$variable))
  colnames(meltdata) <- c("USGS.SID" , "Sample.date..yyyymmdd.",	"Sample.time..hhmm.",	"medium","pcode",	"result")
  meltdata$UID <- paste(meltdata$USGS.SID,meltdata$Sample.date..yyyymmdd.,meltdata$Sample.time..hhmm.,meltdata$medium,sep="")
  meltdata$result <- as.character(meltdata$result)
  meltdata$result <- as.numeric(meltdata$result)
  mergeddata <- (join(meltdata, pcodedata, by = 'pcode'))
  mergeddata$reporting.level <- as.numeric(mergeddata$reporting.level)
  
  qwresult <- matrix(nrow=nrow(mergeddata),ncol=20)
  qwresult <- (as.data.frame(qwresult))
  

  qwresult[,1]<-mergeddata$UID
  qwresult[,2]<-mergeddata$pcode
  qwresult[,3]<-mergeddata$result
  if (censor){
    for (i in 1:nrow(mergeddata)){
      if(!is.na(mergeddata$result[i]) && !is.na(mergeddata$reporting.level[i]))
      {
      if(mergeddata$result[i] <= mergeddata$reporting.level[i]){
        qwresult[i,3]<- mergeddata$reporting.level[i]
        qwresult[i,4]<- "<"
      } else{}
    }
    }
  } else if(!censor){
    qwresult[,4]<- ""
  }
  qwresult[,5]<-mergeddata$qa.code
  qwresult[,6]<-mergeddata$method.code
  qwresult[,7]<-mergeddata$rounding.code
  qwresult[,8]<-mergeddata$qualifiers
  qwresult[,9]<-mergeddata$reporting.level
  qwresult[,10]<-mergeddata$reporting.level.type
  qwresult[,11]<-mergeddata$dqi.code
  qwresult[,12]<-mergeddata$null.value.qualifier
  qwresult[,13]<-mergeddata$prep.set.no
  qwresult[,14]<-mergeddata$analytical.set.no
  qwresult[,15]<-mergeddata$analysis.date
  qwresult[,16]<-mergeddata$prep.date
  qwresult[,17]<-mergeddata$lab.comment
  qwresult[,18]<-mergeddata$field.comment
  qwresult[,19]<-mergeddata$lab.stdev
  qwresult[,20]<-mergeddata$analyzing.entity.code
  names(qwresult) <- c("UID","pcode",
                       "result",
                       "qual code",
                       "qa.code",
                       "method.code",
                       "rounding.code",
                       "qualifiers",
                       "reporting.level",
                      "reporting.level.type",
                       "dqi.code",
                       "null.value.qualifier",
                       "prep.set.no",
                       "analytical.set.no",
                       "analysis.date",
                       "prep.date",
                       "lab.comment",
                       "field.comment",
                       "lab.stdev",
                       "analyzing.entity.code")

qwresult <- join(qwresult, qwsample[c("UID","sample.integer")], by = "UID")
qwresult$UID <- qwresult$sample.integer
qwresult$sample.integer <- NULL
colnames(qwresult)[1] <- "sample.integer"

write.table(qwsample,file="qwsample",sep="\t", col.names = F, row.names = F,na="")
write.table(qwresult,file="qwresult",sep="\t", col.names = F, row.names = F, na="")
}

