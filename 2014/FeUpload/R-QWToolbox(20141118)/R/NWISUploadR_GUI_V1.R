##################
####Upload Tab
##################

##############################
###Setup the main window frame
##############################
tab4 <- gframe(container=nb, label = "Non-NWQL data upload")
tab4A <- gframe("Batch file generator",container=tab4, horizontal = FALSE,expand=TRUE)

###User inputs for data files and output filenames
glabel("Data filename",container = tab4A)
lab.file <- gfilebrowse(container = tab4A,text = "Select lab data file...",quote = FALSE)


glabel("pcode filename",container = tab4A)
pcode.file <- gfilebrowse(container = tab4A,text = "Select pcode data file...",quote = FALSE)

glabel("QWresult filename",container = tab4A)
qwresult.name <- gedit(container = tab4A,initial.msg="filename including extension")
svalue(qwresult.name) <- "qwresult"

glabel("QWsample filename",container = tab4A)
qwsample.name <- gedit(container = tab4A,initial.msg="filename including extension")
svalue(qwsample.name) <- "qwsample"

###Checkbox for weahter or not to censor the data
do.censor <- gcheckbox("Check to censor data to reporting limit",checked=TRUE,container = tab4A)

#############################
###Setup qwsample type frames
#############################

###QWSample from NWIS
nwis.qwsample.frame <- gframe(container=tab4,horizontal=FALSE,use.scrollwindow = FALSE, expand=TRUE)
nwis.qwsample <- ggroup(container=nwis.qwsample.frame,horizontal=FALSE,use.scrollwindow = TRUE, expand=TRUE)

###QWSample from file
file.qwsample.frame <- gframe(container=tab4,horizontal=FALSE,use.scrollwindow = FALSE, expand=TRUE)
file.qwsample <- ggroup(container=file.qwsample.frame,horizontal=FALSE,use.scrollwindow = TRUE, expand=TRUE)

###Manual QWSample generator
man.qwsample.frame <- gframe(container=tab4,horizontal=FALSE,use.scrollwindow = FALSE, expand=TRUE)
man.qwsample <- ggroup(container=man.qwsample.frame,horizontal=FALSE,use.scrollwindow = TRUE, expand=TRUE)

###Set initial frame visbibilty to NWIS QWSample, hide others
visible(nwis.qwsample) <- TRUE
visible(file.qwsample) <- FALSE
visible(man.qwsample.frame) <- FALSE

###A radio button for selecting the type of QWSample file, this will show or hide the pains depending on selection
qwsample.method <- gradio(container =tab4A, c("Generate QWsample from NWIS (logged in samples only)",
                            "Generate QWSample from file",
                            "Generate QWsample manually"),
                          selected = 1, horizontal = FALSE,index=TRUE,
                          handler = function(h,...) {
                            if(svalue(qwsample.method, index=TRUE) == 1) {
                              visible(nwis.qwsample) <- TRUE
                              visible(file.qwsample) <- FALSE
                              visible(man.qwsample.frame) <- FALSE
                              } else if (svalue(qwsample.method,index=TRUE) == 2 ){
                                visible(nwis.qwsample) <- FALSE
                                visible(file.qwsample) <- TRUE
                                visible(man.qwsample.frame) <- FALSE
                              }else if (svalue(qwsample.method,index=TRUE) == 3 ){
                                visible(nwis.qwsample) <- FALSE
                                visible(file.qwsample) <- FALSE
                                visible(man.qwsample.frame) <- TRUE
                              }
                          })


########################################################################################
###All the inputs for the NWIS qw sample generator
############################################################################

glabel("Only for adding data\n to existing samples",container = nwis.qwsample)
glabel("Server name (DSN)",container = nwis.qwsample)
server <- gedit(container = nwis.qwsample,initial.msg="e.g. NWISCO")

###Button to execut upload function
nwis.batchfiles <- gbutton("Generate batch files", container = nwis.qwsample,
                           handler = function(h,...){
                             #Assign input values
                             
                             if (svalue(do.censor)){ ###Have to set the censor logical htis way because it does not read it as a logive using svalue method
                               censor <- TRUE
                             } else (censor <- FALSE)

                             
                             ###Execute function
                             nwisupload(qwsampletype = 1, ###This tells hte function which QWSample file to generate, it is different for each qwsample pane
                                        DSN = svalue(server),
                                        labfile = svalue(lab.file),
                                        pcodefile = svalue(pcode.file),
                                        qwsamplefile = svalue(qwsample.file),
                                        qwresultname = svalue(qwresult.name),
                                        qwsamplename = svalue(qwsample.name),
                                        censor = censor,
                                        agencycode = svalue(agency.code),
                                        labid = svalue(lab.id),
                                        projectcode = svalue(project.code),
                                        aquifercode = svalue(aquifer.code),
                                        analysisstatus = svalue(analysis.status),
                                        analysissource = svalue(analysis.source),
                                        hydrologiccond = svalue(hydrologic.cond),
                                        hydrologicevent = svalue(hydrologic.event),
                                        tissue = svalue(tissue.code),
                                        bodypart = svalue(body.part),
                                        labcomment = svalue(lab.comment),    
                                        fieldcomment = svalue(field.comment),
                                        timedatum = svalue(time.datum),
                                        datumreliability = svalue(datum.reliability),
                                        colagencycode = svalue(colagency.code)) 
                           }
)

#################################################################
###All the inputs for the File qw sample generator
#################################################################

glabel("This tab is for uploading\n data with a user-generated\n qwsample file.\n\n This can be direct output from\n NWIS-QWData or user supplied.\n It must be tab-delimeted\n with no header.\n\nFilename of tab-delimeted\n QWsample file, including\n extenstion if applicable",container = file.qwsample)
#glabel("filename of tab-delimeted\n QWsample file, including\n extenstion if applicable",container = file.qwsample)
qwsample.file <- gfilebrowse(container = file.qwsample,text = "qwsample file...",quote = FALSE)
###Button to execute upload function
file.batchfiles <- gbutton("Generate batch files", container = file.qwsample,
                           handler = function(h,...){
                             #Assign input values
                             
                             if (svalue(do.censor)){ ###Have to set the censor logical htis way because it does not read it as a logive using svalue method
                               censor <- TRUE
                             } else (censor <- FALSE)

                             
                             ###Execute function
                             nwisupload(qwsampletype = 2,###This tells hte function which QWSample file to generate, it is different for each qwsample pane
                                        DSN = svalue(server),
                                        labfile = svalue(lab.file),
                                        pcodefile = svalue(pcode.file),
                                        qwsamplefile = svalue(qwsample.file),
                                        qwresultname = svalue(qwresult.name),
                                        qwsamplename = svalue(qwsample.name),
                                        censor = censor,
                                        agencycode = svalue(agency.code),
                                        labid = svalue(lab.id),
                                        projectcode = svalue(project.code),
                                        aquifercode = svalue(aquifer.code),
                                        analysisstatus = svalue(analysis.status),
                                        analysissource = svalue(analysis.source),
                                        hydrologiccond = svalue(hydrologic.cond),
                                        hydrologicevent = svalue(hydrologic.event),
                                        tissue = svalue(tissue.code),
                                        bodypart = svalue(body.part),
                                        labcomment = svalue(lab.comment),    
                                        fieldcomment = svalue(field.comment),
                                        timedatum = svalue(time.datum),
                                        datumreliability = svalue(datum.reliability),
                                        colagencycode = svalue(colagency.code)) 
                           }
)

#######################################################################################
###All the inputs for the manual qwsample generator
######################################################################################

glabel("Agency code",container = man.qwsample )
agency.code <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Labratory ID",container = man.qwsample )
lab.id <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Project code",container = man.qwsample )
project.code <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Aquifer code",container = man.qwsample )
aquifer.code <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Analysis status",container = man.qwsample )
analysis.status <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Analysis source",container = man.qwsample )
analysis.source <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Hydrologic condition",container = man.qwsample )
hydrologic.cond <- gedit(container = man.qwsample,initial.msg="default is A")
svalue(hydrologic.cond) <- "A"

glabel("Hydrologic event",container = man.qwsample )
hydrologic.event <- gedit(container = man.qwsample,initial.msg="default is 9")
svalue(hydrologic.event) <- "9"

glabel("Tissue",container = man.qwsample )
tissue.code <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Body part",container = man.qwsample )
body.part <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Lab comment",container = man.qwsample )
lab.comment <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Field comment",container = man.qwsample )
field.comment <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Time datum",container = man.qwsample )
time.datum <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Datum reliability",container = man.qwsample )
datum.reliability <- gedit(container = man.qwsample,initial.msg="default is blank")

glabel("Collecting agency code",container = man.qwsample )
colagency.code <- gedit(container = man.qwsample,initial.msg="default is USGS")
svalue(colagency.code) <- "USGS"


man.batchfiles <- gbutton("Generate batch files", container = man.qwsample,
                          handler = function(h,...){
                            #Assign input values
                            
                            if (svalue(do.censor)){ ###Have to set the censor logical htis way because it does not read it as a logive using svalue method
                              censor <- TRUE
                            } else (censor <- FALSE)
  
                            ###Execute function
                            nwisupload(qwsampletype = 3,###This tells hte function which QWSample file to generate, it is different for each qwsample pane
                                       DSN = svalue(server),
                                       labfile = svalue(lab.file),
                                       pcodefile = svalue(pcode.file),
                                       qwsamplefile = svalue(qwsample.file),
                                       qwresultname = svalue(qwresult.name),
                                       qwsamplename = svalue(qwsample.name),
                                       censor = censor,
                                       agencycode = svalue(agency.code),
                                       labid = svalue(lab.id),
                                       projectcode = svalue(project.code),
                                       aquifercode = svalue(aquifer.code),
                                       analysisstatus = svalue(analysis.status),
                                       analysissource = svalue(analysis.source),
                                       hydrologiccond = svalue(hydrologic.cond),
                                       hydrologicevent = svalue(hydrologic.event),
                                       tissue = svalue(tissue.code),
                                       bodypart = svalue(body.part),
                                       labcomment = svalue(lab.comment),    
                                       fieldcomment = svalue(field.comment),
                                       timedatum = svalue(time.datum),
                                       datumreliability = svalue(datum.reliability),
                                       colagencycode = svalue(colagency.code)) 
                          }
)
