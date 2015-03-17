


tab3 <- gframe(container=nb, label = "DQI Codes")
tab3A <- gframe(container=tab3,horizontal=FALSE,expand=TRUE)
qacheck <- gcheckbox(text="QA passed?",container= tab3A)
qareport <- gcheckbox(text = "QA report filed?", container = tab3A)
labreport <- gcheckbox("lab reruns documented?",container = tab3A)
signfile <- gcheckbox("Sign and generate batch files?",checked=FALSE,container = tab3A)
signtog <- ggroup(container=tab3A,horizontal=FALSE)
visible(signtog) <- FALSE
lblX <- glabel("Name",container = signtog)
emp_name <- gedit(container = signtog,initial.msg = "first name, last name")
gbutton("Generate batch files and report", container = signtog)

addHandlerClicked(signfile, handler=function(h,...) {
  if(svalue(signfile))
    visible(signtog) <- TRUE
  else
    visible(signtog) <- FALSE
})
