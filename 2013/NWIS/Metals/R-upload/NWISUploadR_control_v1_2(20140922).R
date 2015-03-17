#########################################################
###########NWIS UploadeR v1.0############################
###########T. Joe Mills, USGS SCEP#######################
###########CO WSC, tmills@usgs.gov#######################
#########################################################

#########################################################
##########Requires some additional packages##############
##########install them and initialize here###############
library(plyr)
library(RODBC)
library(reshape2)
#########################################################
#########################################################
#########################################################


##########################################################
#############Read in your data############################
##########################################################
labfile <- "Labdata.csv"
pcodefile <- "pcodefile.csv"
DSN <- "NWISCO"
censor = TRUE
loggedin = FALSE
##########################################################
##########################################################
##########################################################
###For samples not logged in, manual QWsample inputs
agencycode <- "USGS"
labid <- NA
projectcode <- NA
aquifercode <- NA
analysisstatus <- "U"
analysissource <- NA
hydrologiccond <- "A"
hydrologicevent <- 9
tissue <- NA
bodypart <- NA
labcomment <- NA         
fieldcomment <- NA
timedatum <- NA
datumreliability <- NA 
colagencycode <- "USGS-BRD"
#####################################################################
############Run the function, censoring censors result to reporting
############limit and applies a "<" code, default is TRUE###########
####################################################################
nwisupload(DSN,
           labfile,
           pcodefile,
           censor,
           loggedin,
           agencycode,
           labid,
           projectcode,
           aquifercode,
           analysisstatus,
           analysissource,
           hydrologiccond,
           hydrologicevent,
           tissue,
           bodypart,
           labcomment,    
           fieldcomment,
           timedatum,
           datumreliability,
           colagencycode)
#####################################################################
#####################################################################
#####################################################################




