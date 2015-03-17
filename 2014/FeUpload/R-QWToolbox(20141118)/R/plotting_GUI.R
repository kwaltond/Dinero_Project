###Plotting Tab

tab1 <- gframe(container=nb, label = "Plotting",horizontal=FALSE) 
gbutton(text="Generate pdf book", container=tab1)#,handler = function(h,...){
  


gbutton(text="Generate flaged sample report", container=tab1)

########################
###Plot type panes
########################

###Timeseries plots
tab1C <- gframe("Plot types",container=tab1,expand=TRUE)  
tab1Ca <- gframe("Time plots",container=tab1C, horizontal = FALSE,expand=TRUE)  
timeplots <- gtable(items = tsplots,multiple=TRUE,container = tab1Ca, expand = TRUE, fill = TRUE,
                    handler = function(h,...) itsplot())

###Parameter Parameter plots
tab1Cb <- gframe("Parameter-Parameter plots",container=tab1C,horizontal = FALSE,expand = TRUE)  
parmplots <- gtable(items = ppplots,multiple=TRUE,container = tab1Cb, expand = TRUE, fill = TRUE,handler = function(h,...) iparmplot())

###Charge balance plots
tab1Cc <- gframe("Charge balance plots",container=tab1C,horizontal = FALSE,expand = TRUE)  
chargeplots <- gtable(items = cbplots,multiple=TRUE,container = tab1Cc, expand = TRUE, fill = TRUE)



