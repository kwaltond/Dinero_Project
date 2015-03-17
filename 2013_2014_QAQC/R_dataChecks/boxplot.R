
reports <- .guiEnv$reports
new.threshold <- 2*60*60*24*365
#iparmbox.site.selection
iparmbox.plotparm <- "00945"
iparmbox.show.points <- FALSE
iparmbox.log.scale <- FALSE
	
	#medium.colors <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#D55E00")
	#names(medium.colors) <- c("WS ","WG ","WSQ","WGQ","OAQ")
	## Sets color to medium code name, not factor level, so its consistant between all plots regardles of number of medium codes in data
	#qual.shapes <- c(19,0,2,5)
	#names(qual.shapes) <- c("Sample","<",">","E")
	
maintitle <- "Replicate agreement boxplot"
ylabel <- "Relative percent difference"

plotdata <- subset(reports$repTable,PARM_CD%in%(iparmbox.plotparm))
plotdata$historic <- "Historic"
plotdata$historic[which(plotdata$Env_SAMPLE_START_DT >= (Sys.time()-new.threshold))] <- "New"

p1 <- ggplot(data=plotdata,aes(x=Env_PARM_NM,y=relPercent_diff, color=historic))
p1 <- p1 + geom_boxplot()
#p1 <- p1 + scale_colour_manual("Medium code",values = medium.colors)
#p1 <- p1 + scale_shape_manual("Qualifier code",values = qual.shapes)
p1 <- p1 + ylab(paste(ylabel,"\n")) + theme_USGS()
p1 <- p1 + theme(axis.text.x = element_text(angle = 90))
p1 <- p1 + scale_x_discrete("Analyte")
p1


