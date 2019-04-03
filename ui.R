#---required
library(shiny)
library(maps)
library(ggplot2)

#---get boundary data for all US states
states<-map_data("county")
#---define state names
state.names<-unique(states$region)


#---define drop down menu with states.
state.menu<-
  #---drop down menu!!
  selectInput(
    #--variable created by menu
    "state",
    #---caption
    "Which state to draw counties from?",
    #---choices
    state.names
  )

#---define action button to display new state
action.drawcounty<-
  #---action button!!
  actionButton(
    #---variable created by button
    "draw.county",
    #---caption
    "Click to draw a new county from your selected state."
  )

#----define check box to display county name
checkbox.countyname<-
  #---to create a button
  checkboxInput(
    #---variable create by button
    "display.countyname",
    #---prompt
    "Click to display county name"
  )


#---define object on shiny web page
shinyUI(
  #---uh... this makes it dynamic??
	fluidPage(
	  
	  #---title!
		title="Counties of the USA",
		
		#---select layout with sidebar & main panel
		sidebarLayout(
		  
		  #---define sidebar contents
			sidebarPanel(
			  #---drop down with state names
			  state.menu,
			  #---action button to draw new state
			  action.drawcounty,
				#---checkbox to reveal state outline
				checkbox.countyname
				),
			
			#---define main panel contents
			mainPanel(
			  #---plot the graph created by the server!!
				plotOutput("graph")
				)
			)
		)
	)
