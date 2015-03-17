library(QWToolbox)

###2013 FAs
dataUpload(qwsampletype = 1,
					 DSN= "NWISCO",
					 env.db = "01",
					 qa.db = "02",
					 pcodefile = "pcodefile.csv",
					 labfile = "2013_FA_labfile.csv",
					 qwresultname = "2013_FA_qwresult",
					 qwsamplename = "2013_FA_qwsample",
					 qwsample.begin.date = "2013-01-01",
					 qwsample.end.date = "2014-12-31",
					 censor=TRUE)

###2013 RAs
dataUpload(qwsampletype = 1,
					 DSN= "NWISCO",
					 env.db = "01",
					 qa.db = "02",
					 pcodefile = "pcodefile.csv",
					 labfile = "2013_RA_labfile.csv",
					 qwresultname = "2013_RA_qwresult",
					 qwsamplename = "2013_RA_qwsample",
					 qwsample.begin.date = "2013-01-01",
					 qwsample.end.date = "2014-12-31",
					 censor=TRUE)

###2014 FAs
dataUpload(qwsampletype = 1,
					 DSN= "NWISCO",
					 env.db = "01",
					 qa.db = "02",
					 pcodefile = "pcodefile.csv",
					 labfile = "2014_FA_labfile.csv",
					 qwresultname = "2014_FA_qwresult",
					 qwsamplename = "2014_FA_qwsample",
					 qwsample.begin.date = "2013-01-01",
					 qwsample.end.date = "2014-12-31",
					 censor=TRUE)

###2014 RAs
dataUpload(qwsampletype = 1,
					 DSN= "NWISCO",
					 env.db = "01",
					 qa.db = "02",
					 pcodefile = "pcodefile.csv",
					 labfile = "2014_RA_labfile.csv",
					 qwresultname = "2014_RA_qwresult",
					 qwsamplename = "2014_RA_qwsample",
					 qwsample.begin.date = "2013-01-01",
					 qwsample.end.date = "2014-12-31",
					 censor=TRUE)


