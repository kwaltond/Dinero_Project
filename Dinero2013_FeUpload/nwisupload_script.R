library(QWToolbox)

###Export templates for lab file and pcodefile
templateExport()

###Run the NWIS upload function
nwisupload(qwsampletype = 1,
					 DSN = "NWISCO",
					 env.db = "01",
					 qa.db = "02",
					 labfile = "labfile.csv",
					 pcodefile = "pcodefile.csv",
					 qwsample.begin.date = "2013-01-01",
					 qwsample.end.date = "2013-12-31",
					 censor=TRUE)