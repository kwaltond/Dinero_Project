#############################################################################
#############This is the function for perofrming hte upload, compile this####
#############DO NOT TOUCH!!, NO USER EDITS ARE NEEDED BELOW THIS POINT#######
#############################################################################
nwisupload <- function(qwsampletype,
                       DSN = "NWISCO",
                       labfile,
                       pcodefile,
                       qwsamplefile = "",
                       qwresultname = "qwresult",
                       qwsamplename = "qwsample",
                       censor = FALSE,
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
                 colClasses = c("character","character","character","character","character","character"),na.strings = "NA")
  numdatacols <- ncol(data)-6  
  
  
  pcodedata <- read.csv(pcodefile,header=TRUE,
                        colClasses = "character",na.strings = "NA")
  names(pcodedata) <- c("pcode",
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
                        "analyzing.entity.code"
  )
  STAID <- data[[1]]
  
  #Change to a list that SQL can understand. SQL requires a parenthesized list of expressions, so must look like c('05325000', '05330000') for example
  STAID.list <- paste("'", STAID, "'", sep="", collapse=",")
  
  if (qwsampletype == 1)
  {
    # Open the odbc connection
    Chan1 <- odbcConnect(DSN)
    
    ##################
    ###DATABASE 1#####
    ##################
    
    #get the record numbers
    Query <- paste("select * from ", DSN, ".QW_SAMPLE_01 where site_no IN (", STAID.list, ")", sep="")
    Samples <- sqlQuery(Chan1, Query, as.is=T)
   
    ###SAMPLE TIMES PULLED THIS WAY ARE NOT THE ACTUAL SAMPLE TIME. THESE MUST BE CONVERTED USING THE SAMPLE_START_TZ_CD OR THEY WILL NOT MATCH ACTUAL SAMPLE TIMES
    ###THERE IS CODE BELOW TO DO THIS
    
    
      QWSample1 <- data.frame(Samples$RECORD_NO,
                            "*UNSPECIFIED*",
                            Samples$AGENCY_CD,
                            Samples$SITE_NO,
                            Samples$SAMPLE_START_DT,
                            Samples$SAMPLE_END_DT,
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
                            Samples$COLL_ENT_CD,
                            Samples$SAMPLE_START_TZ_CD,
                            Samples$SAMPLE_START_LOCAL_TM_FG)
    ##################
    ###DATABASE 2#####
    ##################
    
    #get the record numbers
    Query <- paste("select * from ", DSN, ".QW_SAMPLE_02 where site_no IN (", STAID.list, ")", sep="")
    Samples <- sqlQuery(Chan1, Query, as.is=T)
    
    ####Close ODBC Connection
    odbcClose(Chan1)
    ######################
    
    QWSample2 <- data.frame(Samples$RECORD_NO,
                            "*UNSPECIFIED*",
                            Samples$AGENCY_CD,
                            Samples$SITE_NO,
                            Samples$SAMPLE_START_DT,
                            Samples$SAMPLE_END_DT,
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
                            Samples$COLL_ENT_CD,
                            Samples$SAMPLE_START_TZ_CD,
                            Samples$SAMPLE_START_LOCAL_TM_FG)
    
    qwsample <- rbind(QWSample1,QWSample2)
    qwsampleheader <- c("sample.integer",  "user.code",  "agency",  "site.no",  "start.date",  "end.date",  "medium",  "labid",
                        "project.code",  "aquifer.code",	"sample.type",	"analysis.status",	"analysis.source",	"hydrologic.cond",
                        "hydrologic.event",	"tissue",	"body.part",	"lab.comment.",	"field.comment",	"time.datum",	"datum.reliability",
                        "collecting.agency.code","time.zone","std.time.code")
    colnames(qwsample)<-qwsampleheader
    

    
    ##Format times into GMT and correct of daylight savings offset according to location
    ##Weather or not to apply daylight savings is in the std.time.code column, which is from the SAMPLE_START_LOCAL_TM_FG NWIS parameter
    ##e.g. in Colorado, SAMPLE_START_LOCAL_TM_FG = Y, timezone = MDT, SAMPLE_START_LOCAL_TM_FG = N, timezone = MST
    qwsample$start.date <- as.POSIXct(qwsample$start.date, tz="GMT")
    qwsample$offset <- ifelse (qwsample$std.time.code == "Y", 60*60,0)
    qwsample$start.date.offset <- qwsample$start.date + qwsample$offset
    ###Format times from GMT to appropriate time zone
    ###Using a loop because I could not figure out how to vectorize it, perhaps "mapply" would work, but don't know
    for ( i in 1:nrow(qwsample))
    {
    ###Converts to time zone
        qwsample$start.date.adj[i] <- format(qwsample$start.date.offset[i],"%Y%m%d%H%M", tz=as.character(qwsample$time.zone[i]))
    }
    
    qwsample$start.date <- qwsample$start.date.adj 
    qwsample$start.date.adj <- NULL
    qwsample$offset <- NULL
    qwsample$start.date.offset <- NULL
    qwsample$time.zone <- NULL
    ###Remove extra empty character space from medium to make it match medium in data file of 2-3 char
    qwsample$medium <- (gsub(" ", "", qwsample$medium))

    qwsample$sample.integer <- seq(1:nrow(qwsample))
    qwsample$UID <- paste(qwsample$site.no,qwsample$start.date,qwsample$medium,sep="")
    
  }else if (qwsampletype == 2)
  {
    qwsample <- read.delim(file = qwsamplefile,header=FALSE, sep = "\t" )
    qwsampleheader <- c("sample.integer",  "user.code",  "agency",  "site.no",  "start.date",  "end.date",  "medium",  "labid",
                        "project.code",  "aquifer.code",	"sample.type",	"analysis.status",	"analysis.source",	"hydrologic.cond",
                        "hydrologic.event",	"tissue",	"body.part",	"lab.comment.",	"field.comment",	"time.datum",	"datum.reliability",
                        "collecting.agency.code")
    colnames(qwsample)<-qwsampleheader
    qwsample$UID <- paste(qwsample$site.no,qwsample$start.date,qwsample$medium,sep="")
  } else if (qwsampletype == 3)
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
    qwsample$start.date <- paste(data$Sample.start.date..yyyymmdd.,data$Sample.start.time..hhmm.,sep="")
    qwsample$end.date <- paste(data$Sample.end.date..yyyymmdd.,data$Sample.end.time..hhmm.,sep="")
    qwsample$medium <- data$medium.code
    qwsample$labid <- labid
    qwsample$project.code <- projectcode
    qwsample$aquifer.code <- aquifercode
    ###Get proper coding for sample type###
    ##Asign temporary UIDs for qwsample and data , THESE ARE NOT TRULY UNIQUE SINCE JUST ID and DATE
    data$UID <- paste(data$USGS.SID, data$Sample.start.date..yyyymmdd.)
    qwsample$UID <- paste(data$USGS.SID,data$Sample.start.date..yyyymmdd.)
    ###Go through data and check for reps
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
        ###Asign coding of 7 to an evnironmental sample with a rep.
        ###This will not always work if there are multiple reps and environmental samples collected at the same site on the same day
        if (qwsample$UID[i] %in% qwsample$UID[which(qwsample$medium == "WSQ" | qwsample$medium == "WGQ")] )
        {
          qwsample$sample.type[i] <- 7
        } else (qwsample$sample.type[i] <- 9)
      }
    }
    ###Get rid of temp UIDs
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
  
  ###Rearrange data frame into qwresult format
  meltdata<-melt(data,id.vars=colnames(data[,1:6]))
  meltdata$variable <- (gsub("X", "", meltdata$variable))
  colnames(meltdata) <- c("USGS.SID" , "Sample.start.date..yyyymmdd.",	"Sample.start.time..hhmm.","medium","Sample.end.date..yyyymmdd.",  "Sample.end.time..hhmm.",	"pcode",	"result")
  ###Make a unique sample ID out of ID date time medium code
  meltdata$UID <- paste(meltdata$USGS.SID,meltdata$Sample.start.date..yyyymmdd.,meltdata$Sample.start.time..hhmm.,meltdata$medium,sep="")
  ###Join the lab data to the pcode meta data in the pcode file
  mergeddata <- (join(meltdata, pcodedata, by = 'pcode'))
  ###Make an empty QWresult dataframe
  qwresult <- matrix(nrow=nrow(mergeddata),ncol=20)
  qwresult <- (as.data.frame(qwresult))
  
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
  
  ###Populate qwresult
  qwresult[,1]<-mergeddata$UID
  qwresult[,2]<-mergeddata$pcode
  qwresult[,3]<-mergeddata$result
  ###Censor data if applicable and add a < code
  if (censor == TRUE){
    for (i in 1:nrow(mergeddata)){
      
      if(!is.na(as.numeric(mergeddata$result[i])) && !is.na(as.numeric(mergeddata$reporting.level[i])))
      {
        if(as.numeric(mergeddata$result[i]) <= as.numeric(mergeddata$reporting.level[i])){
          qwresult[i,3]<- mergeddata$reporting.level[i]
          qwresult[i,4]<- "<"
          qwresult[i,10]<- mergeddata$reporting.level.type[i]
        } else{}
      }
    }
  } else if(censor == FALSE){
    qwresult[,4]<- ""
  }
  ###Populate rest of QWResult
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
  
  ###Matchup sample integers between the qwsample and qwresult file
  qwresult <- join(qwresult, qwsample[c("UID","sample.integer")], by = "UID")
  qwresult$UID <- qwresult$sample.integer
  qwresult$sample.integer <- NULL
  qwsample$UID <- NULL
  colnames(qwresult)[1] <- "sample.integer"

  
  ###Remove rows with missing results to avoid annoying watlist errors from NWIS
  qwresult <- subset(qwresult, result != "")
  
  ###Wire qwresult and qwsample files
  write.table(qwsample,file=qwsamplename,sep="\t", col.names = F, row.names = F,na="", quote = FALSE)
  write.table(qwresult,file=qwresultname,sep="\t", col.names = F, row.names = F, na="",quote = FALSE)
}
