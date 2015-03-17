

blankSummary <- function(qw.data,begin.date = NA,end.date=NA)
{

blanks <- subset(qw.data$PlotTable, MEDIUM_CD == "OAQ" & 
								 	SAMPLE_START_DT >= as.POSIXct(begin.date) &
								 	SAMPLE_START_DT <= as.POSIXct(end.date) &
								 	PARM_SEQ_GRP_CD !="INF" &
								 	PARM_SEQ_GRP_CD != "PHY")

#blankDetects <- subset(blanks,REMARK_CD != "<")
#blankDetects$flags <- ""
#blankDetects$flags[which(blankDetects$RESULT_VA >= 10*as.numeric(blankDetects$RPT_LEV_VA))] <- "Detection >= 10xLRL"

blanksummary <- data.frame(PARM_CD = unique(blanks$PARM_CD))
blanksummary <- join(blanksummary, blanks[c("PARM_CD","PARM_SEQ_GRP_CD","PARM_DS","RPT_LEV_VA")],by="PARM_CD")
blanksummary <- unique(blanksummary)

summary <- ddply(blanks, "PARM_CD", summarize,
			num_blanks = length(RESULT_VA),
			num_detects = length(RESULT_VA[which(REMARK_CD == "Sample")]),
			num_e_detects = length(RESULT_VA[which(REMARK_CD == "E")]),
			num_detects_10xRL = length(RESULT_VA[which(RESULT_VA >= 10*as.numeric(RPT_LEV_VA) &REMARK_CD == "Sample")]),
			median_detected_value = median(RESULT_VA[which(REMARK_CD == "Sample")]),
			max_detected_value = max(RESULT_VA[which(REMARK_CD == "Sample")],na.rm=TRUE),
			BD_90.90 = BD9090(RESULT_VA[which(REMARK_CD == "Sample")]))

blanksummary <- join (blanksummary,summary,by="PARM_CD")
	
blanksummary <-blanksummary[with(blanksummary, order(PARM_SEQ_GRP_CD, PARM_CD)), ]
return(blanksummary)
}

