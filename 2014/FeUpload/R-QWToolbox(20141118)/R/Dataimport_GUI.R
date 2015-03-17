##################
####Data import Tab
##################
#nb <- gwindow()
##############################
###Setup the main window frame
##############################
outerdatatab <- gframe(container=nb,horizontal=FALSE, label = "Data import")
datatab <- gframe("Discrete QW Data",container=outerdatatab,expand=TRUE) 
date.frame <- gframe(container=outerdatatab,expand=FALSE)
server.frame <- gframe(container=outerdatatab,expand=FALSE)
########################
###Universal inputs
########################

###Date inputs
glabel("Begin date",container = date.frame)
begindate <- gcalendar(text = "yyyy-mm-dd", format = "%Y-%m-%d", handler=NULL, 
                       action=NULL, container = date.frame) 
glabel("End date",container = date.frame)
enddate <- gcalendar(text = "yyyy-mm-dd", format = "%Y-%m-%d", handler=NULL, 
                     action=NULL, container = date.frame)
###Server inputs
glabel("NWIS server\nname",container = server.frame)
dlserver.name <- gedit(container = server.frame,initial.msg = "e.g. NWISCO") 

glabel("Environmental database\nnumber",container = server.frame)
env.db.num <- gedit(container = server.frame,initial.msg = "e.g. 01") 

glabel("QA database\nnumber",container = server.frame)
qa.db.num <- gedit(container = server.frame,initial.msg = "e.g. 02") 

gbutton(text="Import data", container=outerdatatab,handler = function(h,...){
            if(svalue(siteid.method, index=TRUE) == 1)
               {
                STAIDS <- svalue(sitenumber)
                } else if(svalue(siteid.method, index=TRUE) == 2)
                {
                  STAIDS <- svalue(favsites)
                } else if(svalue(siteid.method, index=TRUE) == 2)
                {
                  STAIDS <- as.character(scan(svalue(ID.file)))
                }
            if(svalue(pcode.method, index=TRUE) == 1)
            {
              parm.group.check <- TRUE
              if(svalue(parm.group,index=TRUE) != 1)
              {
              dl.parms <- nwis.parm.groups[svalue(parm.group,index=TRUE)]
              } else {dl.parms <- "All"}
            } else if(svalue(pcode.method, index=TRUE) == 2)
            {
              dl.parms <- svalue(favpcodes)
              parm.group.check <- FALSE
            } else if(svalue(pcode.method, index=TRUE) == 3)
            {
              dl.parms <- scan(svalue(parmfile),what="character")
              parm.group.check <- FALSE
            }
            
            qw.data <<-NWISPullR(DSN = svalue(dlserver.name),
                      env.db = svalue(env.db.num),
                      qa.db = svalue(qa.db.num),
                      STAIDS = STAIDS,
                      dl.parms = dl.parms,
                      parm.group.check = parm.group.check)
            
            
              }
              )
###################
###Site info pane
###################
datatabA <- gframe("Site info",container=datatab, horizontal = FALSE,expand=TRUE) 

###A radio button for selecting the type of site input, this will show or hide the pains depending on selection
siteid.method <- gradio(container =datatabA, c("Single site ID",
                                               "Favorite site list",
                                               "Site IDs from file"),
                        selected = 1, horizontal = FALSE,index=TRUE,
                        handler = function(h,...) {
                          if(svalue(siteid.method, index=TRUE) == 1) {
                            visible(num.frame) <- TRUE
                            visible(fsite.frame) <- FALSE
                            visible(IDfile.frame) <- FALSE
                          } else if (svalue(siteid.method,index=TRUE) == 2 ){
                            visible(num.frame) <- FALSE
                            visible(fsite.frame) <- TRUE
                            visible(IDfile.frame) <- FALSE
                          } else if (svalue(siteid.method,index=TRUE) == 3 ){
                            visible(num.frame) <- FALSE
                            visible(fsite.frame) <- FALSE
                            visible(IDfile.frame) <- TRUE
                          }
                          
                        })

###Input for 1 site
num.frame <- gframe("Single site input",container=datatabA, horizontal = FALSE,expand=FALSE)
glabel("Site number",container = num.frame)
sitenumber <- gedit(container = num.frame) 

###Input for multiple sites using an editable "favorites" table

fsite.frame <- gframe("Favorite sites",container=datatabA, horizontal = FALSE,expand=TRUE)

###Fav sites gtable, this uses input from a csv file containing site ids (pcodes) to populate the table. 
###When "saving preferences"save preferences", the favsites gtable will need to be written to a csv file that is then loaded up when "open preferences" is used

###Button for editing favorites  table
gbutton("Edit favorites",horizontal = FALSE,container=fsite.frame, 
        handler =  function(h,...) {
          popwin <- gwindow("Edit favorites")
          edit.sites <- gdf(container = popwin, items=siteIDs,expand=TRUE) ###gdf editor for pcodes table object. This must be 
          gbutton("Update table",horizontal = FALSE,container=popwin, 
                  handler =  function(h,...) {
                    delete(fsite.frame,favsites)
                    siteIDs <<- as.character(edit.sites[,1])
                    favsites <<- gtable(items = siteIDs,multiple=TRUE,container = fsite.frame, expand = TRUE, fill = TRUE)
                    dispose(popwin) 
                  }
          )
        }
)

###The favorites gtable
favsites <- gtable(items = siteIDs,multiple=TRUE,container = fsite.frame, expand = TRUE, fill = TRUE)

###Input for multiple sites from a CSV file

IDfile.frame <- gframe("Site IDs from file",container=datatabA, horizontal = FALSE,expand=FALSE)
glabel("Site ID file",container = IDfile.frame)
ID.file <- gfilebrowse(container = IDfile.frame,text = "Select site ID file...",quote = FALSE)



###Set initial frame visbibilty to NWIS QWSample, hide others
visible(num.frame) <- TRUE
visible(fsite.frame) <- FALSE
visible(IDfile.frame) <- FALSE




########################
###Parameters pane
########################

datatabB <- gframe("Parameter info",container=datatab, horizontal = FALSE,expand=TRUE) 

pcode.method <- gradio(container =datatabB, c("NWIS parameter groups",
                                               "Favorite pcode list",
                                               "pcodes from file"),
                        selected = 1, horizontal = FALSE,index=TRUE,
                        handler = function(h,...) {
                          if(svalue(pcode.method, index=TRUE) == 1) {
                            visible(parm.group.frame) <- TRUE
                            visible(fpcode.frame) <- FALSE
                            visible(pfile.frame) <- FALSE
                          } else if (svalue(pcode.method,index=TRUE) == 2 ){
                            visible(parm.group.frame) <- FALSE
                            visible(fpcode.frame) <- TRUE
                            visible(pfile.frame) <- FALSE
                          } else if (svalue(pcode.method,index=TRUE) == 3 ){
                            visible(parm.group.frame) <- FALSE
                            visible(fpcode.frame) <- FALSE
                            visible(pfile.frame) <- TRUE
                          }
                          
                        })


###Select paramaters by NWIS pcode group
parm.group.frame <- gframe("NWIS parameter groups",container=datatabB, horizontal = FALSE,expand=FALSE)
glabel("Parameter groups",container = parm.group.frame )

###Engish parameter groups, indexed so do not change order
parm.group <- gcombobox(c("All" , "physical", "cations", "anions", "nutrients",
                     "microbiological", "biological", "metals", "nonmetals", "pesticides",
                     "pcbs" ,"other organics" ,"radio chemicals", "stable isotopes", "sediment",
                     "population/community"), container=parm.group.frame)

###NWIS Parameter group codes, these are indexed the same as above so do not change order
nwis.parm.groups <- c("INF", "PHY", "INM", "INN", "NUT", "MBI", "BIO", "IMM", "IMN", "TOX",
  "OPE", "OPC", "OOT", "RAD", "XXX", "SED", "POP")

###Input for multiple pcodes using an editable "favorites" table

fpcode.frame <- gframe("Favorite pcodes",container=datatabB, horizontal = FALSE,expand=TRUE)

###Fav pcodes gtable, this uses input from a csv file containing site ids (pcodes) to populate the table. 
###When "saving preferences"save preferences", the favpcodes gtable will need to be written to a csv file that is then loaded up when "open preferences" is used

###Button for editing favorites  table
gbutton("Edit favorites",horizontal = FALSE,container=fpcode.frame, 
        handler =  function(h,...) {
          popwin <- gwindow("Edit favorites")
          edit.pcodes <- gdf(container = popwin, items=pcodes,expand=TRUE) ###gdf editor for pcodes table object. This must be 
          gbutton("Update table",horizontal = FALSE,container=popwin, 
                  handler =  function(h,...) {
                    delete(fpcode.frame,favpcodes)
                    pcodes <<- as.character(edit.pcodes[,1])
                    favpcodes <<- gtable(items = pcodes,multiple=TRUE,container = fpcode.frame, expand = TRUE, fill = TRUE)
                    dispose(popwin) 
                  }
          )
        }
)

###The favorites gtable
favpcodes <- gtable(items = pcodes,multiple=TRUE,container = fpcode.frame, expand = TRUE, fill = TRUE)


###Read in pcodes from a file
pfile.frame <- gframe("Read pcodes from file",container=datatabB, horizontal = FALSE,expand=FALSE)
glabel("parameter code file",container = pfile.frame )
parmfile <- gfilebrowse(container = pfile.frame,text = "Select pcode file...",quote = FALSE)



###Set initial frame visbibilty to NWIS QWSample, hide others
visible(parm.group.frame) <- TRUE
visible(pfile.frame) <- FALSE
visible(fpcode.frame) <- FALSE


########################
###Non-NWIS data import, not included in version 1.0
########################

#datatabC <- gframe("Non-NWIS data import",container=datatab, horizontal = FALSE,expand=TRUE)  
#glabel("Import non-NWIS data file \n see documentation for file format",container = datatabC)
#nonnwisfile <- gedit(container = datatabC,initial.msg = "filename including csv extension")
#gbutton(text="Import non-NWIS data", container=datatabC)

