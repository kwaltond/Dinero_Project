QWsample <- read.delim("qwsample",header=FALSE)
QWresult <- read.delim("qwresult",header=FALSE,colClasses = c("character"))

QWresult[,1] <- as.numeric(QWresult[,1])



###Add DO comment

###Joe 9/23
QWresult[,18][which(QWresult[,2] == "00300" & 
                      QWresult[,1] >= 2 & 
                      QWresult[,1] <= 7)] <- "DO CALIBRATION (OR CHECK) @ 9/23/14 0700, CAL TEMP = 11.6C, BP = 537.0 mmHg; CHART VALUE = 7.7 mg/L; INITIAL VALUE = -- mg/L, ADJUSTED VALUE = 7.69 mg/L"
###Joe 9/24
QWresult[,18][which(QWresult[,2] == "00300" & 
                      QWresult[,1] >= 8 & 
                      QWresult[,1] <= 15)] <- "DO CALIBRATION (OR CHECK) @ 9/24/14 0700, CAL TEMP = 15.21C, BP = 531.5 mmHg; CHART VALUE = 6.98 mg/L; INITIAL VALUE = 6.98 mg/L, ADJUSTED VALUE = -- mg/L"
###Jenn 9/23
QWresult[,18][which(QWresult[,2] == "00300" & 
                      QWresult[,1] >= 16 & 
                      QWresult[,1] <= 22)] <- "DO CALIBRATION (OR CHECK) @ 9/23/14 0700, CAL TEMP = --C, BP = -- mmHg; CHART VALUE = -- mg/L; INITIAL VALUE = 8.07 mg/L, ADJUSTED VALUE = 7.72 mg/L"
###Jenn 9/24
QWresult[,18][which(QWresult[,2] == "00300" & 
                      QWresult[,1] >= 22 & 
                      QWresult[,1] <= 32)] <- "DO CALIBRATION (OR CHECK) @ 9/24/14 0700, CAL TEMP = 15.13C, BP = 530.9 mmHg; CHART VALUE = 6.98 mg/L; INITIAL VALUE = 6.93 mg/L, ADJUSTED VALUE = -- mg/L"


write.table(QWresult,file="qwresult_pcff10162014",sep ="\t",col.names=FALSE,row.names=FALSE,quote=FALSE)

