library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  navbarPage("SATARK",
             
    #Begin first tab 
    tabPanel("Crime Map",
             
             sidebarPanel(
               selectInput(inputId="mapType", label="Map Type",
                           choices=c("Crime Map","Crime Choropleth","Heat Map"), selected = "Crime Maps"),
               
               selectInput(inputId="district", label="District",
                           choices=selectAssamDistricts, selected = "All Districts"),
               
               selectInput(inputId="crimeType", label="Crime Type",
                           choices=crime_names,selected="All Crimes"),
               dateRangeInput('dateRange',
                              label = 'Date Range',
                              start = Sys.Date() -365, end = Sys.Date(),
                              min = Sys.Date() - 700, max = Sys.Date(),
                              separator = " to ", format = "dd/mm/yy",
                              startview = 'year', weekstart = 1)),     
             
        mainPanel(
        leafletOutput("Map")
                 )
  
),
#End of first tab (Crime Type)

#Begin of 2nd tab (Analytics)
        tabPanel("Analytics",
                 sidebarPanel(
                   
                   radioButtons(inputId="analyticsType", label="Analyse Crime",
                                choices = list("Crime Pie Chart", "Crime Trend Plot",
                                               "Compare all districts" ),selected = "Crime Pie Chart"),
                 
                   selectInput(inputId="districtAnalytics", label="District",
                               choices=selectAssamDistricts, selected = "All Districts"),
                   
                   selectInput(inputId="crimeTypeAnalytics", label="Crime Type",
                               choices=crime_names,selected="All Crimes"),
                   
                  dateRangeInput('dateRangeAnalytics',
                                  label = 'Date Range',
                                  start = Sys.Date() -365, end = Sys.Date(),
                                  min = Sys.Date() - 700, max = Sys.Date(),
                                  separator = " to ", format = "dd/mm/yy",
                                  startview = 'year', weekstart = 1)
                  ),
                 
                 mainPanel(
                   plotlyOutput("analyticsPlot")
                 )
                 
  ),

#End of second tab(Analytics)

#Begin of third tab (Predpol)
        tabPanel("Victim Data Analysis",
                 sidebarPanel(
                   selectInput(inputId="gender", label="Gender",
                               choices=c("Male"="M","Female"="F","Both"), selected="Both"),
                   
                   selectInput(inputId="age", label="Age", choices=c("<18","18-30","30-45","45>","All age groups")),
                              
                   
                   radioButtons(inputId="victimanalyticsType", label="Analyse Victim Data",
                                choices = list("Crime Pie Chart", "Crime Trend Plot",
                                               "Compare all districts" ),selected = "Crime Pie Chart"),
                   selectInput(inputId="victimdistrictAnalytics", label="District",
                               choices=selectAssamDistricts, selected = "All Districts"),
                   
                   selectInput(inputId="victimcrimeTypeAnalytics", label="Crime Type",
                               choices=crime_names,selected="All Crimes"),
                   
                   dateRangeInput('victimdateRangeAnalytics',
                                  label = 'Date Range',
                                  start = Sys.Date() -365, end = Sys.Date(),
                                  min = Sys.Date() - 700, max = Sys.Date(),
                                  separator = " to ", format = "dd/mm/yy",
                                  startview = 'year', weekstart = 1)
                   
                   
                   
                    ),
                 
                 
        
                 mainPanel(
                   plotlyOutput("victimanalyticsPlot")
                 )
                 
                 
                 
                 )
#End of third tab (Victim Data Analysis)
                 
    )#Navbar

))#ui
