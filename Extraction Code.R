#Install 'weatherData' package
install.packages('weatherData')

#Run 'weatherData' package
require('weatherData')

#Extract all weather data for DCA
DCAall <- getWeatherForDate("DCA", start_date="2011-01-01",
                       end_date = "2012-12-31",
                       opt_detailed = FALSE,
                       opt_all_columns = TRUE)

#Extract weather data for DCA in 2011
#!Info: DCA is Ronald Reagan Washington National Airport
#!Info: 'custom_columns' are selected variables
DCA11 <- getWeatherForDate("DCA", start_date="2011-01-01",
                            end_date = "2011-12-31",
                            opt_custom_columns=TRUE,
                            custom_columns=c(2,4,9,12,15,18,20,21,22))

#Extract weather data for DCA in 2012
#!Note: It wasn't possible to do >1 year at a time. Reason unknown.
DCA12 <- getWeatherForDate("DCA", start_date="2012-01-01",
                            end_date = "2012-12-31",
                            opt_custom_columns=TRUE,
                            custom_columns=c(2,4,9,12,15,18,20,21,22))

#Combine DCA11 and DCA12 datasets                          
DCA1112 <- rbind(DCA11,DCA12) 

#Export 'DCA1112' dataset to CSV File
write.csv(DCA1112, file = "file:///C:/Users/Jeffrey/Documents/School/Fall 2016/STAT 4210 Applied Regression/Final Project/DCA1112.csv")

#List all weather events
table(DCA1112$Events)
