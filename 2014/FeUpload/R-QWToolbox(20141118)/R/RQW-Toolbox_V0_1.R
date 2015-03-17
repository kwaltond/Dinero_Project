

source("R/widgetfunctions.r")
source("R/plottypes.r")
source("R/preferences.r")
source("R/libraries.r")
source("R/NWISUploadRV1_4(20141118).r")
source("R/NWIS_PullR(20141113).r")

##################
###Main window
##################

w <- gwindow("Toolkit example")
visible(w) <- FALSE #Hide the GUI until its fully built

###Toolbar setup
tbl <- list()
tbl$Save <- list(icon="save",handler = function(...) print("save"))
tbl$Open <- list(icon="open",handler = function(...) print("open"))
tbl$New <- list(icon="new",handler = function(...) print("new"))
tbl$Quit <- list(icon="close",handler = function(...) print("quit"))
tb <- gtoolbar(tbl, container=w)

###Notebook
nb <- gnotebook(container=w)

###################
###Data import Tab
###################

source("R/Dataimport_GUI.R")

###################
###Plotting tab
###################
source("R/plotting_GUI.R")
###################
###Blanks and reps tab
###################


###################
###DQI Tab
###################



#####################
###Data Upload tab
#####################
source("R/NWISUploadR_GUI_V1.r")


visible(w) <- TRUE
