#########################################################
###########NWIS UploadeR v1.0############################
###########T. Joe Mills, USGS SCEP#######################
###########CO WSC, tmills@usgs.gov#######################
#########################################################

##########################################################
#############Read in your data############################
##########################################################
datapath <- "C:/Users/Public/Documents/USGS/Dinero/RNWIS/Exampleupload/LabData.csv"
pcodepath <-"C:/Users/Public/Documents/USGS/Dinero/RNWIS/Exampleupload/pcodedata.csv"
qwsamplepath <-"C:/Users/Public/Documents/USGS/Dinero/RNWIS/Exampleupload/qwsample"
outputpath <-"C:/Users/Public/Documents/USGS/Dinero/RNWIS/Exampleupload/output"
##########################################################
##########################################################
##########################################################

#####################################################################
############Run the function, censoring censors result to reporting
############limit and applies a "<" code, default is TRUE###########
####################################################################
nwisupload(datapath,pcodepath,qwsamplepath,outputpath,censor = TRUE)
#####################################################################
#####################################################################
#####################################################################



