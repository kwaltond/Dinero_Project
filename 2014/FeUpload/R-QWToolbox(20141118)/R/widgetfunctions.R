###Widget functions

theme_USGS <-  function(base_size = 12){theme(
  plot.title = element_text (vjust = 3, size = 16,family="serif"), # plot title attrib.
  plot.margin = unit (c(8, 4, 8, 4), "lines"), # plot margins
  panel.border = element_rect (colour = "black", fill = F), # axis colour = black
  #panel.grid.major = element_blank (), # remove major grid
  panel.grid.minor = element_blank (), # remove minor grid
  panel.background = element_rect (fill = "white"), # background colour
  legend.background = element_rect (fill = "white"), # background colour
  #legend.justification=c(0, 0), # lock point for legend
  #legend.position = c(0, 1), # put the legend INSIDE the plot area, use = "none" to turn off
  legend.key = element_blank (), # switch off the rectangle around symbols in the legend
  legend.title = element_blank (), # switch off the legend title
  legend.text = element_text (size = 12), # sets the attributes of the legend text
  axis.title.x = element_text (vjust = -2, size = 14,family="serif"), # change the axis title
  axis.title.y = element_text (vjust = -0.1, angle = 90, size = 14,family="serif"), # change the axis title
  axis.text.x = element_text (size = 12, angle = 90,vjust = -0.25, colour = "black",family="serif"),# change the axis label font attributes
  axis.text.y = element_text (size = 12, hjust = 1, colour = "black",family="serif"), # change the axis label font attributes
  axis.ticks = element_line (colour = "black", size = 0.5), # sets the thickness and colour of axis ticks
  axis.ticks.length = unit(-0.25 , "cm"), # -ve length = inside ticks
  axis.ticks.margin = unit(0.5, "cm") # margin between the ticks and the text
)}


###Interactive parameter parameter plot
iparmplot <- function() {
  ## Set up main group
  mainGroup <- ggroup(container=gwindow("Interactive plot example"))
  
  visible(mainGroup) <- FALSE

  vargroup <- gframe("Parameters",container=mainGroup,expand=TRUE)
  x <- gtable(items = pcodes,multiple=FALSE,container = vargroup, expand = TRUE, fill = TRUE,index=TRUE)
  y <- gtable(items = pcodes,multiple=FALSE,container = vargroup, expand = TRUE, fill = TRUE,index=TRUE)
  addHandlerClicked(x,handler = function(h,...) {
    do.call("plot",list(mtcars[,svalue(x,index=TRUE)],mtcars[,svalue(y,index=TRUE)],ylab=svalue(y),xlab=svalue(x)))
    })
  addHandlerClicked(y,handler = function(h,...) {
    do.call("plot",list(mtcars[,svalue(x,index=TRUE)],mtcars[,svalue(y,index=TRUE)],ylab=svalue(y),xlab=svalue(x)))
  })
  
  rightGroup <- ggroup(horizontal=FALSE, container=mainGroup)
  ggraphics(container=rightGroup)
  
  gbutton(text="Flag samples", container = rightGroup,handler = function(h,...) {
    identify(mtcars[,svalue(x,index=TRUE)],mtcars[,svalue(y,index=TRUE)],labels=c("X"),par(col="red"))
  })
  visible(mainGroup) <- TRUE
  }




###Fancy ITS plot function
itsplot <- function() {
  
  ## Set up main group
  mainGroup <- ggroup(container=gwindow("Interactive plot example"))
  
  visible(mainGroup) <- FALSE
  
  
  maintitle <- str_wrap(unique(qw.data$PlotTable$STATION_NM), width = 25)
  ## Sets color to medium code name, not factor level, so its consistant between all plots regardles of number of medium codes in data
  medium.colors <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442")
  #names(medium.colors) <- levels(factor(qw.data$PlotTable$MEDIUM_CD))
  names(medium.colors) <- c("WS ","WG ","WSQ","WGQ","OAQ")
  ## Sets color to medium code name, not factor level, so its consistant between all plots regardles of number of medium codes in data
  qual.shapes <- c(19,0,2,5)
  names(qual.shapes) <- c("Sample","<",">","E")
  

  ## The variable browser widget
  vargroup <- gframe("Parameters",container=mainGroup,expand=FALSE)
  analyte <- gtable(items = unique(qw.data$PlotTable$PARM_CD),multiple=FALSE,container = vargroup, expand = TRUE, fill = TRUE)
  addHandlerClicked(analyte,handler = function(h,...) {
    ylabel <- do.call("str_wrap",list(string=unique(qw.data$PlotTable$PARM_DS[which(qw.data$PlotTable$PARM_CD==svalue(analyte))]), width = 25))
    p1 <- do.call("ggplot",list(data=subset(qw.data$PlotTable,PARM_CD==svalue(analyte)),aes(x=SAMPLE_START_DT,y=RESULT_VA,shape = REMARK_CD, color = MEDIUM_CD)))
    p1 <- p1 + geom_point(size=3)
    p1 <- p1 + ylab(paste(ylabel,"\n")) + xlab("Date")
    p1 <- p1 + scale_colour_manual("Medium code",values = medium.colors)
    p1 <- p1 + scale_shape_manual("Medium code",values = qual.shapes)
    #p1 <- p1 + scale_shape_manual("Qualifier", labels = c("<",">","E","Sample"), values = c(19,0,2,4)) +
    #  scale_color_manual("Medium code", labels = c("OAQ","WG ", "WGQ","WS ","WSQ"), values = c("dodgerblue3","chartreuse4","coral","coral1"))
    p1 <- p1 + theme_USGS() + ggtitle(maintitle)
    
    print(p1)                      
  })
  
  
  
  
  
  
  rightGroup <- ggroup(horizontal=FALSE, container=mainGroup, expand = TRUE)
  ggraphics(container=rightGroup, expand = TRUE)
  
  visible(mainGroup) <- TRUE
  
}



changeState <- function(addcont,tocont) {
  if(state) {
    hideGroup()
    svalue(icon) <- rightArrow
    } else {
      expandGroup()
      svalue(icon) <- downArrow
      }
  state <<- !state
  }