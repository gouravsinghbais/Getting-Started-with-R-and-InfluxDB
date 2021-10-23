## import library
library(influxdbclient)

## specify the token generated in influxDB dashboard
token = "token-string"
## organisation name 
org = "my-org"
## bucket name 
bucket = "RInfluxClient"

## connect to influxDB local client
client <- InfluxDBClient$new(url = "http://localhost:8086",
                              token = token,
                              org = org)

## read the csv file containing Covid-19 data 
data<-read.csv("/Users/gouravbais/Downloads/covid_data.csv")

## convert date from string to POSIXct
data[['Date']] <- as.POSIXct(strptime(data[['Date']], format='%Y-%m-%d'))

## write data in infuxDB 
response <- client$write(data, bucket = "RInfluxClient", precision = "us",
                          measurementCol = "Cases",
                          tagCols = c("Region", "Country"),
                          fieldCols = c("Cases"),
                          timeCol = "Date")

## print response 
print(response)