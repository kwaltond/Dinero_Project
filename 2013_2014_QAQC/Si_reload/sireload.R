library(QWToolbox)

dataUpload(qwsampletype = 1,
					 labfile="2014_RA_labfile_si.csv",
					 pcodefile="pcodefile_si.csv",
					 qwsample.begin.date = "2014-01-01",
					 qwsample.end.date = "2015-01-01",censor=TRUE)
