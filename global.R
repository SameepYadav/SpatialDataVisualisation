library(tidyr)  # loads dplyr, tidyr, ggplot2 packages
library(dplyr)
library(plyr)       # for aggregate
library(ggplot2)
library(gridExtra)  # plotting multiple plots together
library(sf)         # simple features package - vector
library(raster)     # raster
library(plotly)     # makes ggplot objects interactive
library(mapview)    # quick interactive viewing of spatial objects
library(leaflet)
library(leaflet.extras) #For heatmaps
library(gdtools)
#library(dbplyr)
#library(RPostgreSQL)

# Open up a database connection.

#pg = dbDriver("PostgreSQL")

#con = dbConnect(pg, user = 'node_user', password = "eztoforget",
 #               host="35.200.168.215", port=5432, dbname="satark_db")

#data <- dbSendQuery(con, 'SELECT dates, crimetype, crimedistricts, lat, lng,
 #                   victim_age, victim_gender FROM crimes;')
#crimeData <- dbFetch(data,n=-1)

#Synthesizing Random Data
#crimeData<-as.data.frame(data)
crimeData<-read.csv("assamcrimedata.csv")
#colnames(crimeData)<-c("dates","crimetype","crimedistricts","dates","lat","lng")
crimeData$dates<-as.Date(crimeData$dates)

#Generating Random coordinates for Assam
#lat <- runif(446, 26.0000, 27.0000)
#lng <-runif(446,90.0000,95.5000)

#Replacing london coordinates dates with Assam dates
crime_names<-as.character(unique(crimeData$crimetype))
crime_names<-c("All Crimes",crime_names)

#Generating random dates and replacing with london dates


#Generating random districts for crime data
assam <- geojsonio::geojson_read("2011_Dist.json",
                                 what = "sp") 

assamTibble<-as_tibble(assam)
assamDistricts<-as.character(assamTibble$DISTRICT)
selectAssamDistricts<-c("All Districts",assamDistricts)

#Preparing Assam Shape File
assam <- geojsonio::geojson_read("2011_Dist.json",
                                 what = "sp")

assam_leaflet<-leaflet(assam) %>% addTiles() %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "black", weight = 2,
                                                  bringToFront = TRUE))




