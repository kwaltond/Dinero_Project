library(QWToolbox)
templateExport()

dataUpload(qwsampletype=1,
					 labfile="labfile.csv",
					 pcodefile="pcodefile.csv",
					 qwsample.begin.date = "2013-01-01",
					 qwsample.end.date = "2014-12-31",
					 censor=FALSE)
