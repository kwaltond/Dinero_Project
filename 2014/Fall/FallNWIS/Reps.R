Rep.data <- subset(Tables$PlotTable, MEDIUM_CD == "WSQ" | MEDIUM_CD == "WGQ")
Env.data <- subset(Tables$PlotTable, MEDIUM_CD == "WS " | MEDIUM_CD == "WG ")

Rep.data$UID <- paste(Rep.data$SITE_NO,Rep.data$SAMPLE_START_DT)
Env.data$UID <- paste(Env.data$SITE_NO,Env.data$SAMPLE_START_DT)

test <- join(Rep.data, Env.data, by = "UID")
