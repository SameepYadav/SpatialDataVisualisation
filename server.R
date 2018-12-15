#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {

#Output for Tab 1(crime map)  
  districtFilter <- reactive({
    if (input$district=="All Districts"){
      districtFilterData<-crimeData
    } else{
      districtFilterData<-crimeData[crimeData$crimedistricts==input$district,]}
  })
  
  crimeFilter <- reactive({
    if (input$crimeType=="All Crimes"){
      crimeFilterData<-crimeData
    } else{
      crimeFilterData<-crimeData[crimeData$crimetype==input$crimeType,]}
  })
  
  dateFilter<-reactive({
    dateFilterData<-crimeData[crimeData$dates >= input$dateRange[1] & crimeData$dates<=input$dateRange[2],]
  
  })
  
  mapType<-reactive({
    input$mapType
  })

  
  output$Map <- renderLeaflet({
    
    if(mapType()=="Crime Map"){
    district_crime<-inner_join(districtFilter(),crimeFilter())
    district_crime_date<-inner_join(district_crime,dateFilter())
      assam_leaflet %>% 
      addMarkers(data = district_crime_date,~lng, ~lat,  
                 popup= popupTable(district_crime_date))
    }else if(mapType()=="Crime Choropleth"){
      crime_date<-inner_join(crimeFilter(),dateFilter())
      districtCount<-count(crime_date,vars=c("crimedistricts"))
      bins <- c(0,3,6,9, 12, 15, 18, 21, 24,27,30,Inf)
      pal <- colorBin("YlOrRd", domain = districtCount$freq, bins = bins)
      labels <- sprintf(
        "<strong>%s</strong><br/>%g Crimes ",
        districtCount$crimedistricts, districtCount$freq
      ) %>% lapply(htmltools::HTML)
      assam_leaflet %>% addPolygons(
        fillColor = ~pal(districtCount$freq),
        weight = 2,
        opacity = 1,
        dashArray = "3",
        color = "white",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          bringToFront = TRUE),
        label = labels) %>% 
        addLegend(pal = pal, values = ~freq, opacity = 0.7, title = NULL,
                  position = "bottomright") %>% setView(92.9376,26.2006, zoom = 6.5)
    } else {
      crime_date<-inner_join(crimeFilter(),dateFilter())
      assam_leaflet %>%
        addHeatmap(data= crime_date,lng=~lng, lat=~lat,
                   blur = 20, max = 0.05, radius = 15 ) %>% setView(92.9376,26.2006, zoom = 6.5) 
      
    }
      
      
      
    
    
       })
  
    
  
    
  
#End of Tab 1 (Crime Map)
  #######################

#Beg of Tab 2(Analytics)
  districtFilterAnalytics <- reactive({
    if (input$districtAnalytics=="All Districts"){
      districtFilterAnalytics<-crimeData
    } else{
      districtFilterAnalytics<-crimeData[crimeData$crimedistricts==input$districtAnalytics,]}
  })
  
  crimeFilterAnalytics <- reactive({
    if (input$crimeTypeAnalytics=="All Crimes"){
      crimeFilterAnalytics<-crimeData
    } else{
      crimeFilterAnalytics<-crimeData[crimeData$crimetype==input$crimeTypeAnalytics,]}
  })
  
  dateFilterAnalytics<-reactive({
    dateFilterAnalytics<-crimeData[crimeData$dates >= input$dateRangeAnalytics[1] & crimeData$dates<=input$dateRangeAnalytics[2],]
    
  })
  
  analyticsType<-reactive({
    input$analyticsType
  })
  
  
  
   output$analyticsPlot <- renderPlotly({
     # (1) Pie Plot   
     if(analyticsType()=="Crime Pie Chart"){
  district_date<-inner_join(districtFilterAnalytics(),dateFilterAnalytics())
  piecrimeCount<-count(district_date, vars=c("crimetype"))
  plot_ly(piecrimeCount, labels = ~crimetype, values=~freq,type = 'pie') %>% 
    layout(title = 'Crime - Pie chart ',showlegend=T) 
     }else if(analyticsType()=="Compare all districts")
     {
       crime_date<-inner_join(crimeFilterAnalytics(),dateFilterAnalytics())
       districtComparatorData<-count(crime_date,vars=c("crimedistricts","crimetype"))
       plot_ly(districtComparatorData, x = ~crimedistricts, y = ~freq, type = 'bar', 
               name = ~crimetype, color = ~crimetype) %>%
         layout(title="Compare all districts",xaxis=list(title='Districts'),
                yaxis =list(title='Number of Crimes'),barmode = 'stack',
                margin = list(b = 160), xaxis = list(tickangle = 45))
        } else{
       crime_date<-inner_join(crimeFilterAnalytics(),dateFilterAnalytics())
       crime_date_district<-inner_join(crime_date,districtFilterAnalytics())
       dateTrendCount<-count(crime_date_district,vars=c("dates"))
       dateTrend <- dateTrendCount$dates
       freqTrend <- dateTrendCount$freq
       plot_ly(x = ~dateTrend, y = ~freqTrend,type = 'scatter', mode = 'lines',line = list(color = 'red', width = 1)) %>% 
         layout(title = 'Crime Trend Visualisation',
                xaxis = list(title = 'Timeline'),
                yaxis = list (title = 'No. of crimes'))
       
     }
   })
 
    
  
  
    
  

      #End of Tab 2(Analytics)  

#Beg of Tab 3 (Victim Data Analytics)

genderFilter<-reactive({
  if (input$gender=="Both"){
    genderFilter<-crimeData
  } else{
    genderFilter<-crimeData[crimeData$victim_gender==input$gender,]}
  
})

ageFilter<-reactive({
  if(input$age=="All age groups"){
    ageFilter<-crimeData
  }else if(input$age=="<18"){
    ageFilter<-crimeData[crimeData$victim_age<18,]
  }else if(input$age=="18-30"){
    ageFilter<-crimeData[crimeData$victim_age>18 & crimeData$victim_age<=30,]
  }else if(input$age=="30-45"){
    ageFilter<-crimeData[crimeData$victim_age>30 & crimeData$victim_age<=45,]
  }else if(input$age=="45>"){
    ageFilter<-crimeData[crimeData$victim_age>45,]
  }
  })
  
  
  victimdistrictFilterAnalytics <- reactive({
    if (input$victimdistrictAnalytics=="All Districts"){
      victimdistrictFilterAnalytics<-crimeData
    } else{
      victimdistrictFilterAnalytics<-crimeData[crimeData$crimedistricts==input$victimdistrictAnalytics,]}
  })
  
  
  victimcrimeFilterAnalytics <- reactive({
   if (input$victimcrimeTypeAnalytics=="All Crimes"){
    victimcrimeFilterAnalytics<-crimeData
  } else{
  victimcrimeFilterAnalytics<-crimeData[crimeData$crimetype==input$victimcrimeTypeAnalytics,]}
  })
  
  victimdateFilterAnalytics<-reactive({
    victimdateFilterAnalytics<-crimeData[crimeData$dates >= input$victimdateRangeAnalytics[1] & crimeData$dates<=input$victimdateRangeAnalytics[2],]
    
  })
  
  victimanalyticsType<-reactive({
    input$victimanalyticsType
  })
  
  
  age_gender<-reactive({
    inner_join(ageFilter(),genderFilter())
    
  })
  
  output$victimanalyticsPlot <- renderPlotly({
    # (1) Pie Plot   
    
    if(victimanalyticsType()=="Crime Pie Chart"){
      district_date<-inner_join(victimdistrictFilterAnalytics(),victimdateFilterAnalytics())
      district_date_age_gender<-inner_join(district_date,age_gender())
      piecrimeCount<-count(district_date_age_gender, vars=c("crimetype"))
      plot_ly(piecrimeCount, labels = ~crimetype, values=~freq,type = 'pie') %>% 
        layout(title = 'Crime - Pie chart ',showlegend=T) 
    }else if(victimanalyticsType()=="Compare all districts")
    {
      crime_date<-inner_join(victimcrimeFilterAnalytics(),victimdateFilterAnalytics())
      crime_date_age_gender<-inner_join(crime_date,age_gender())
      districtComparatorData<-count(crime_date_age_gender,vars=c("crimedistricts","crimetype"))
      plot_ly(districtComparatorData, x = ~crimedistricts, y = ~freq, type = 'bar', 
              name = ~crimetype, color = ~crimetype) %>%
        layout(title="Compare all districts",xaxis=list(title='Districts'),
               yaxis =list(title='Number of Crimes'),barmode = 'stack',
               margin = list(b = 160), xaxis = list(tickangle = 45))
    } else{
      crime_date<-inner_join(victimcrimeFilterAnalytics(),victimdateFilterAnalytics())
      crime_date_district<-inner_join(crime_date,victimdistrictFilterAnalytics())
      crime_date_district_age_gender<-inner_join(crime_date_district,age_gender())
      dateTrendCount<-count(crime_date_district_age_gender,vars=c("dates"))
      dateTrend <- dateTrendCount$dates
      freqTrend <- dateTrendCount$freq
      plot_ly(x = ~dateTrend, y = ~freqTrend,type = 'scatter', mode = 'lines',line = list(color = 'red', width = 1)) %>% 
        layout(title = 'Crime Trend Visualisation',
               xaxis = list(title = 'Timeline'),
               yaxis = list (title = 'No. of crimes'))
      
    }
  })
  
})
#End of Tab 3 (Victim Data Analytics)
  
  
  

