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
  axis.text.x = element_text (size = 12, vjust = -0.25, colour = "black",family="serif"),# change the axis label font attributes
  axis.text.y = element_text (size = 12, hjust = 1, colour = "black",family="serif"), # change the axis label font attributes
  axis.ticks = element_line (colour = "black", size = 0.5), # sets the thickness and colour of axis ticks
  axis.ticks.length = unit(-0.25 , "cm"), # -ve length = inside ticks
  axis.ticks.margin = unit(0.5, "cm") # margin between the ticks and the text
)}


Data <- qw.data$PlotTable
######Plotting
ts.plotr <- function(Data)
{
  ###get parameter names
  measparms <- unique(Data$PARM_CD)
  numparms <- length(measparms)
  sites <- unique(Data$SITE_NO)
  numsites <- length(sites)
  plotlist <- list()
  
  for (k in 1:numsites)
  {
    SiteData <- subset(Data, SITE_NO == sites[k])
    filename <- unique(SiteData$STATION_NM)
    
    #pdf(width = 11, height = 8.5,file=filename)
    for (i in 1:numparms)
    {
      
      Plotdata <- subset(SiteData, PARM_CD == measparms[i])
      ylabel <- str_wrap(unique(Plotdata$PARM_DS), width = 75)
      maintitle <- str_wrap(unique(Plotdata$STATION_NM), width = 75)
      
      if (length(Plotdata$RESULT_VA) > 1)
      {
        p1 <- ggplot(Plotdata,  aes(SAMPLE_START_DT, RESULT_VA, shape = REMARK_CD, color = MEDIUM_CD)) + 
          geom_point(size = 3) + scale_shape_manual("Qualifier", labels = c("Sample", "<",">","E"), values = c(19,0,2,4)) +
          scale_color_manual("Medium code", labels = c("WS", "WSQ","WG","WGQ"), values = c("dodgerblue3","chartreuse4","coral","coral1")) +
          xlab("Date") + 
          ylab(paste(ylabel,"\n")) +
          theme_USGS() + ggtitle(maintitle)
        numplots <- length(plotlist) # count number of plots in list to make sure it does not override existing plots
        plotlist[[numplots+1]] <- p1 #store plots in list
 
      } else{}
    }
    
    #dev.off()
    
  }
  
  return(plotlist)
}

tsplots <- ts.plotr(qw.data$PlotTable)
