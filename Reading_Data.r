## import libraries 
library(forecast)
library(lubridate)
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

## query last two year's data
result <- client$query('from(bucket: "RInfluxClient") |> range(start: -2y) |> drop(columns: ["_start", "_stop"])')

## check response
result[[1]][c("time", "_value")]

## create dataframe from the list of dataframes returned by influxDB client
df1 = data.frame()
for (r in result){
    sub_df = r[c("time", "_value")]
    print(sub_df)
    df1 = rbind(df1, sub_df)
}

## data preprocessing
## arrange data in ascending order based on time
df1 = df1[order(df1$time),]
## covert datetime to YYYY-MM-DD format
df1[['time']] <- as.POSIXct(strptime(df1[['time']], format='%Y-%m-%d'))
## rename column _value to Cases
colnames(df1)[2] <- "Cases"
## convert Cases column's double values to integer
df1$Cases <- as.integer(df1$Cases)

## crete time series data from input data 
mts <- ts(df1[c("_value")], start = decimal_date(ymd(df1[1, "time"])),
                                     frequency = 365.25 / 7)

## plot input data 
plot(mts, xlab ="Weekly Data",
      ylab ="Total Positive Cases",
      main ="COVID-19 Pandemic", 
      col.main ="darkgreen")

## fit model in the retrived data 
fit <- auto.arima(mts)

## make predcitions for next 5 days 
orecast(fit, 5)

## plot predictions
plot(forecast(fit, 5), xlab ="Weekly Data",
      ylab ="Total Positive Cases",
      main ="COVID-19 Pandemic", col.main ="darkgreen")

# saving the file 
dev.off()