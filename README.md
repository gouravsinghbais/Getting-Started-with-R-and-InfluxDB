# Getting-Started-with-R-and-InfluxDB

To install the InfluxDB client library for R which can be downloaded using the following line of code:
```
install.packages("influxdbclient")
```
If you install it on R studio other dependencies will be downloaded along with the base library, but if in case dependencies are not downloaded you can download them using the following line of code:
```
install.packages(c("httr", "bit64", "nanotime", "plyr"))
```
# Making a Connection

Parameters that must be known to make DB connection are:
 - **Token:** Access token that you have generated using the console, you can log in to the influxDb dashboard and copy the same.
 - **Bucket:** This requires the name of the bucket on which you would be working. You can choose the initial bucket or create a new one using the dashboard.
 - **Organisation:** Organisation that you have named during the initial setup of the influx DB.
Since this connection would be made locally the connection script would look like this:
```
## import the client library
library(influxdbclient)
# parameters needed to make connection to Database
token = "Paste Your Token Here"
org = "my-org"
bucket = "RInfluxClient"
## make connection to the influxDB bucket
client <- InfluxDBClient$new(url = "http://localhost:8086",
                             token = token,
                             org = org)
```



# Inserting Data 

*To store the Covid-19 data in InfluxDB using the write method you need to make sure that your timestamp column (Date) is in POSIXct format.*

```
## convert date column to POSIXct
data[['Date']] <- as.POSIXct(strptime(data[['Date']], format='%Y-%m-%d'))
## write data in influxDB
response <- client$write(data, bucket = "RInfluxClient", precision = "us",
                          measurementCol = "Cases",
                          tagCols = c("Region", "Country"),
                          fieldCols = c("Cases"),
                          timeCol = "Date")
```
The response from the write() function is either NULL, True or the error. To debug the write() function and check how the data is being written in the DB you can assign object = 'lp'.

## Using Data

To query the data from database you can use the following lines of code:

```
result <- client$query('from(bucket: "RInfluxClient") |> range(start: -2y) |> drop(columns: ["_start", "_stop"])')
```


To explore InfluxDB in detail you can refer the following [link](https://docs.influxdata.com/influxdb/v2.0/).

