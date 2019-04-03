#---required!!
library(shiny)
library(maps)
library(ggplot2)


#---get boundary data for all US states
states<-map_data("county")
#---define state names
state.names<-unique(states$region)

#---create server function
function(
  #---arguments... always input/output??
  input,
  output
  ){
	
  #---input, ever given??
  
  #---take note if...
  random.county<-eventReactive(input$draw.county, {
    #---define a data frame based on the selected state
    dat<-subset(states,region==input$state)
    #---what county names are in selected state?
    county.names<-unique(dat$subregion)
    #---pick a county at random
    sample(county.names,1)
  })
  
  #---take note if...
  dat<-eventReactive(input$draw.county, {
    #---define a data frame based on the selected state
    dat<-subset(states,region==input$state)
    #---create identifier vector for random county
    county1<-dat$subregion==random.county()
    #---add identifier to data frame; output!!
    data.frame(dat,county1)
  })
  
  output$graph<-
    renderPlot(
      {
        #---what data to map, from what state???
        #dat<-subset(states,region==input$state)
        
        #---ggplot!!
        ggplot(
          #---data = subsetted state boundary data
          data=dat(),
          #---aesthetics!
          aes(
            #--long & lat
            x=long,
            y=lat,
            #---grouped by county
            group=subregion
          )
        )+
          #---geometry!!
          geom_polygon(
            #---define color and fill
            color="black",
            #---aesthetic: fill based on county identifier
            aes(fill=county1)
          )+
          #---customize fill colors
          scale_fill_manual(
            values=(
              c(
                "TRUE"="red",
                "FALSE"="grey79"
              )
            ),
            guide=FALSE
          )+
          #---labels!!!
          labs(
            #---no x & y labels
            x=NULL,
            y=NULL
          )+
          #---get rid of coordinate numbers (breaks) on x and y axes
          scale_x_continuous(breaks=NULL)+
          scale_y_continuous(breaks=NULL)+
          #---fix aspect ratio!!
          coord_fixed()+
          
          #---display state outline? Y/N?
          if(input$display.countyname) ggtitle(random.county()) else NULL
        
        
      }
    )
	}
