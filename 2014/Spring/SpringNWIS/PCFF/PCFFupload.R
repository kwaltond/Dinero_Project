QWsample <- read.table("qwsample",header=FALSE)
QWresult <- read.csv("qwresult.csv",header=FALSE,colClasses = c("character"))

QWresult[,1] <- as.numeric(QWresult[,1])
QWresult[,3] <- as.numeric(QWresult[,3])

SCvalues <- QWresult[,3][which(QWresult[,2] == "00095" & 
                                 QWresult[,1] >= 5 & 
                                 QWresult[,1] <= 13)]
##Calculate calibration line from end of day check y=mx+b
##std 1000 reads 830 and std 23 reads 22
##measured is x actual is y

m <- (1000-23)/(830-22)
b <- 1000-m*830

###Adjust Ethan's SC values
QWresult[,3][which(QWresult[,2] == "00095" & 
                     QWresult[,1] >= 5 & 
                     QWresult[,1] <= 13)] <- (SCvalues*m + b)
###Add result level comment
QWresult[,18][which(QWresult[,2] == "00095" & 
                     QWresult[,1] >= 5 & 
                     QWresult[,1] <= 13)] <- "SC cal at 23, corr w/ endday check. std 1000 reads 830,std 23 reads 22"


###Add DO comment

###Ethan 5/29
QWresult[,18][which(QWresult[,2] == "00300" & 
                      QWresult[,1] >= 5 & 
                      QWresult[,1] <= 13)] <- "DO CALIBRATION (OR CHECK) @ 5/29/14 0700, CAL TEMP = 16.88C, BP = 522.4 mmHg; CHART VALUE = 6.75 mg/L; INITIAL VALUE = 6.79 mg/L, ADJUSTED VALUE = -- mg/L"
###Ethan 5/30
QWresult[,18][which(QWresult[,2] == "00300" & 
                      QWresult[,1] >= 14 & 
                      QWresult[,1] <= 22)] <- "DO CALIBRATION (OR CHECK) @ 5/30/14 0700, CAL TEMP = 10.57C, BP = 539.9 mmHg; CHART VALUE = 7.80 mg/L; INITIAL VALUE = 6.31 mg/L, ADJUSTED VALUE = 7.91 mg/L"
###Joe 5/29
QWresult[,18][which(QWresult[,2] == "00300" & 
                      QWresult[,1] >= 23 & 
                      QWresult[,1] <= 30)] <- "DO CALIBRATION (OR CHECK) @ 5/29/14 0700, CAL TEMP = 18.3C, BP = 532.4 mmHg; CHART VALUE = 6.57 mg/L; INITIAL VALUE = 6.59 mg/L, ADJUSTED VALUE = 6.59 mg/L"
###Joe 5/30
QWresult[,18][which(QWresult[,2] == "00300" & 
                      QWresult[,1] >= 31 & 
                      QWresult[,1] <= 37)] <- "DO CALIBRATION (OR CHECK) @ 5/30/14 0700, CAL TEMP = 10.78C, BP = 539.6 mmHg; CHART VALUE = 7.87 mg/L; INITIAL VALUE = -- mg/L, ADJUSTED VALUE = 7.87 mg/L"


write.table(QWresult,file="qwresult_pcff08012014",sep ="\t",col.names=FALSE,row.names=FALSE,quote=FALSE)

