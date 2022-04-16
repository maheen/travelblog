#Written by Maheen Shermohammed

# This script graphs the cities I've traveled to in my year abroad,
# charts them on a world map, and exports that chart to chart-studio
# so I can embed it in my website.

#found a data set of cities from http://www.geonames.org/ (cities15000.zip)
#cleaned it up using the code below and saved relevant data to 
#a smaller file
# citiestbl <- read.delim("~/Documents/Travels/data/cities15000.txt",header = F)
# citiestbl <- citiestbl[c(1:3,5,6,9,10,15,16,18)]
# names(citiestbl) <- c("geonameid","name","asciiname","latitude","longitude","countrycode","cc2","population","elevation","timezone")
# write.csv(citiestbl,"~/Documents/Travels/data/cities15000_cleaned.csv",row.names = F)
citiestbl <- read.csv("~/Documents/Travels/data/cities15000_cleaned.csv",stringsAsFactors = F)

#Manually change the city I'm in now
curcity <- "Cusco"

#pull out the data for the cities I've traveled to
mycities <- c("Cairo","Aswan","Luxor","Nevşehir","Istanbul","Selçuk","Karachi",
              "Islamabad","Lahore","Dubai","Kyiv","Lviv","Atlanta","Paramus",
              "Bangkok","Chiang Mai","Chiang Rai","Krabi","Phnom Penh",
              "Siem Reap","Kampot","Mexico City","Oaxaca","Cancún",
              "Playa del Carmen","Cusco")
citiesplotdata <- subset(citiestbl,select = c(name,latitude,longitude,countrycode),name %in% mycities)

#add in the cities that exist in multiple countries
mulcities <- subset(citiestbl,select = c(name,latitude,longitude,countrycode),
       (name == "Valladolid" & countrycode == "MX") | 
         (name == "Mérida" & countrycode == "MX") | 
         (name == "Lima" & countrycode == "PE"))
citiesplotdata <- rbind(citiesplotdata,mulcities)

#manually add in the smaller cities that weren't in the database
smallcities <- data.frame(name = c("Skardu","Hunza","Koh Phi Phi","Koh Pha Ngan","Koh Tao","Kep"),
                         latitude = c(35.267388,36.31114437534064,7.740659015920495,9.677933020649514,10.084587412818292,10.486575137817916),
                         longitude = c(75.637957, 74.61577544868913, 98.77359019690073, 100.06743762574513, 99.82670648156872, 104.32097072574972),
                         countrycode = c("PK","PK","TH","TH","TH","KH"))
citiesplotdata <- rbind(citiesplotdata,smallcities)

#clean up some of the names
citiesplotdata$name[citiesplotdata$name=="Paramus"] <- "Glen Rock"
citiesplotdata$name[citiesplotdata$name=="Selçuk"] <- "Selçuk / Ephesus"
citiesplotdata$name[citiesplotdata$name=="Nevşehir"] <- "Nevşehir (Cappadocia)"

#make some indications of current city
curind <- which(citiesplotdata$name == curcity)
dotcolors <- rep("navy",nrow(citiesplotdata))
dotcolors[curind] <- "red"

#generate plot
library(leaflet)
citiesplotdata$name[curind] <- paste("Currently In:",citiesplotdata$name[curind])
mym <- leaflet(citiesplotdata) %>% addProviderTiles(providers$Esri) %>%
  addCircleMarkers(~longitude, ~latitude, 
                   label=~as.character(name),
                   labelOptions = labelOptions(textsize = "15px"),
                   #popup='<a href="https://wheredmanogo.rbind.io/category/egypt/">Egypt Posts</a>',
                   radius = 4,
                   color = dotcolors,
                   stroke = T, fillOpacity = 0.8) %>%
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom to Level 1",
    onClick=JS("function(btn, map){ map.setZoom(1); }")))
# mym

#save the map in .html format
library(htmlwidgets)
saveWidget(mym, file="~/Documents/Travels/data/travelblog/mymap.html")

#I used this tutorial to help me upload my plot to github pages
#and create an iframe command: 
#https://towardsdatascience.com/how-to-create-a-plotly-visualization-and-embed-it-on-websites-517c1a78568b

#This to use iframe to embed on Wordpress site: 
#https://www.wpbeginner.com/wp-tutorials/how-to-easily-embed-iframe-code-in-wordpress/

