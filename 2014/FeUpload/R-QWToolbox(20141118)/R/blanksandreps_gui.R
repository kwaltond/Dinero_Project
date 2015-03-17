tab2sub <- gframe(container=nb, label = "Replicates and Blanks",horizontal = FALSE)
gbutton(text="Generate pdf book", container=tab2sub)
tab2 <- gframe(container = tab2sub,expand=TRUE)


tab2A <- gframe("Replicate and blank plots",container=tab2,expand=TRUE)  
chargeplots <- gtable(items = repblnkplots,multiple=TRUE,container = tab2A, expand = TRUE, fill = TRUE)

tab2B <- gframe("Replicate and blank tables",container=tab2,expand=TRUE)  
chargeplots <- gtable(items = repblnktables,multiple=TRUE,container = tab2B, expand = TRUE, fill = TRUE)
