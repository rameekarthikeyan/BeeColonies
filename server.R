library(shiny)
library(maps)
library(mapproj)
library(plotly)
library(data.table)
library(dplyr)

dt1 <- as.data.table(read.csv("hcny_p01_t005.csv", skip = 8, nrows = 54, stringsAsFactors = FALSE, col.names = c("id", "u", "state", "initial", "maximum", "lost", "lost_percent", "added", "renovated", "renovated_percent"), blank.lines.skip = TRUE, na.strings = "NA"))
dt2 <- as.data.table(read.csv("hcny_p02_t001.csv", skip = 8, nrows = 54, stringsAsFactors = FALSE, col.names = c("id", "u", "state", "initial", "maximum", "lost", "lost_percent", "added", "renovated", "renovated_percent"), blank.lines.skip = TRUE, na.strings = "NA"))
dt3 <- as.data.table(read.csv("hcny_p03_t007.csv", skip = 8, nrows = 54, stringsAsFactors = FALSE, col.names = c("id", "u", "state", "initial", "maximum", "lost", "lost_percent", "added", "renovated", "renovated_percent"), blank.lines.skip = TRUE, na.strings = "NA"))
dt4 <- as.data.table(read.csv("hcny_p04_t008.csv", skip = 8, nrows = 54, stringsAsFactors = FALSE, col.names = c("id", "u", "state", "initial", "maximum", "lost", "lost_percent", "added", "renovated", "renovated_percent"), blank.lines.skip = TRUE, na.strings = "NA"))
dt5 <- as.data.table(read.csv("hcny_p05_t011.csv", skip = 8, nrows = 54, stringsAsFactors = FALSE, col.names = c("id", "u", "state", "initial", "maximum", "lost", "lost_percent", "added", "renovated", "renovated_percent"), blank.lines.skip = TRUE, na.strings = "NA"))
dt6 <- as.data.table(read.csv("hcny_p06_t002.csv", skip = 7, nrows = 54, stringsAsFactors = FALSE, col.names = c("id", "u","state", "reason_1", "reason_2", "reason_3", "reason_4", "reason_5", "reason_6"), blank.lines.skip = TRUE, na.strings = "NA"))
dt7 <- as.data.table(read.csv("hcny_p07_t013.csv", skip = 7, nrows = 54, stringsAsFactors = FALSE, col.names = c("id", "u","state", "reason_1", "reason_2", "reason_3", "reason_4", "reason_5", "reason_6"), blank.lines.skip = TRUE, na.strings = "NA"))
dt8 <- as.data.table(read.csv("hcny_p08_t009.csv", skip = 7, nrows = 54, stringsAsFactors = FALSE, col.names = c("id", "u","state", "reason_1", "reason_2", "reason_3", "reason_4", "reason_5", "reason_6"), blank.lines.skip = TRUE, na.strings = "NA"))
dt9 <- as.data.table(read.csv("hcny_p09_t010.csv", skip = 7, nrows = 54, stringsAsFactors = FALSE, col.names = c("id", "u","state", "reason_1", "reason_2", "reason_3", "reason_4", "reason_5", "reason_6"), blank.lines.skip = TRUE, na.strings = "NA"))
dt10 <- as.data.table(read.csv("hcny_p10_t012.csv", skip = 7, nrows = 54, stringsAsFactors = FALSE, col.names = c("id", "u","state", "reason_1", "reason_2", "reason_3", "reason_4", "reason_5", "reason_6"), blank.lines.skip = TRUE, na.strings = "NA"))

qrnames <- data.frame("num" = c(1:5), "range" = c("January to March of year 2016", "April to June of year 2016", "July to September of year 2016", "October to December of year 2016", "January to March of year 2017"))
dt <- lapply(list(dt1,dt2,dt3,dt4,dt5,dt6,dt7,dt8,dt9,dt10), na.omit)

ntdt <- list(dt[[1]], dt[[2]], dt[[3]], dt[[4]], dt[[5]])
xn <- lapply(ntdt, function(x) {x[46:47,]})
nndt <- lapply(ntdt, function(x) {x[1:45,]})
fn1x <- function(x) {
  x[, codes:=c("AL", "AZ", "AR", "CA", "CO", "CT", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY")]
}
newx <- lapply(nndt, fn1x)

rtdt <- list(dt[[6]], dt[[7]], dt[[8]], dt[[9]], dt[[10]])
rxn <- lapply(rtdt, function(x) {x[46:47,]})
rrdt <- lapply(rtdt, function(x) {x[1:45,]})
reasonx <- lapply(rrdt, fn1x)

shinyServer(
  function(input,output){
    rs <- reactive({as.data.table(newx[[input$slider1]])})
    reas <- reactive({as.data.table(reasonx[[input$slider1]])})
    g <- reactive({list(scope = 'usa', projections = list(type = 'albers usa'), showlakes = TRUE, lakecolor = toRGB("white"))})
    output$oradio1 <- renderText({input$radio1})
    output$otext1 <- renderText({((xn[[input$slider1]])[2,])$lost_percent})
    output$otext2 <- renderText({paste((rs()$state)[which.max(rs()$lost_percent)],max(rs()$lost_percent), sep = " ")})
    output$plotmap <- renderPlotly({plot_ly(rs()) %>%
        add_trace(z = ~lost_percent, locations = ~codes, color = ~lost_percent, colors = 'Reds', locationmode = 'USA-states', type = "choropleth", hoverinfo = "location+z") %>%
        colorbar(title = "Lost percentage") %>%
        add_trace(z = "Gray",locations = c("AK","DE","NH","NV","RI"), text = "No Data",locationmode = 'USA-states',type = "choropleth", showscale = FALSE, hoverinfo = "location+text") %>%
        #colorbar(title = "Lost percentage") %>%
        layout(title = paste("Percentage of Honey Bee colonies lost from ", qrnames[input$slider1, 2],sep = ""),geo = g())
      
    })
    

  })
