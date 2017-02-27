# Copyright 2017 The WWU eLectures Team All rights reserved.
#
# Licensed under the Educational Community License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
#
#     http://opensource.org/licenses/ECL-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

library('shiny')
library('reshape2')
library('dplyr')
library('RJSONIO')
library('ggplot2')
library('rmarkdown')

source('functions/range.R', local = TRUE)
source('functions/users.R', local = TRUE)
source('functions/metadata.R', local = TRUE)
source('functions/missing-metadata.R', local = TRUE)
source('functions/cleanandstore.R', local = TRUE)
source('functions/access-series.R', local = TRUE)
source('functions/access-series-episodes.R', local = TRUE)

# Define server logic required to draw the plot
shinyServer(function(input, output, session) {
  
  output$episodePlot <- renderPlot({
      p <- ggplot(subset(episodes_unique, episodeID %in% input$episodes & seriesID == subset(seriesTitles, ID == substr(paste(names(parseQueryString(session$clientData$url_search)), parseQueryString(session$clientData$url_search), sep = "=", collapse=", "), 8, 200))$ID), aes(x = date, y = counts, group = Episodes, color = Episodes)) +
        geom_line() +
        xlab("Date") +
        ylab("Hits") +
        scale_x_date(date_breaks = "1 week") +
        theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position="right") +
        xlim(input$dateRange) +
        ylim(c(0,max(subset(episodes_unique, seriesID == subset(seriesTitles, ID == substr(paste(names(parseQueryString(session$clientData$url_search)), parseQueryString(session$clientData$url_search), sep = "=", collapse=", "), 8, 200))$ID & date %in% input$dateRange[1]:input$dateRange[2])$counts)))
      
      if (input$recDates == TRUE) {
        p <- p + geom_vline(xintercept = as.numeric(as.Date(subset(episodeTitles, ID %in% input$episodes)$Date)), linetype = "longdash")
      }
      
      print(p)
  })

  output$episodesTable = renderDataTable({
    episodes_count <- subset(episodes_unique, date %in% input$dateRange[1]:input$dateRange[2])
    episodes_count <- subset(episodes_count, episodeID %in% input$episodes & seriesID == substr(paste(names(parseQueryString(session$clientData$url_search)), parseQueryString(session$clientData$url_search), sep = "=", collapse=", "), 8, 200))
    episodes_count <- aggregate(data = episodes_count, counts ~ Episodes, sum)
    colnames(episodes_count) <- c("Episodes", "Hits")
    episodes_count
  })
  
  output$episodesList = renderUI({
    list <- episodeIDs %in% subset(episodes_unique, seriesID == subset(seriesTitles, ID == substr(paste(names(parseQueryString(session$clientData$url_search)), parseQueryString(session$clientData$url_search), sep = "=", collapse=", "), 8, 200))$ID)$episodeID
    checkboxGroupInput("episodes", "Episodes to show:", episodeIDs[list], selected = episodeIDs[1:length(episodeIDs)])
  })
  
  output$queryText <- renderUI({
    title <- names(subset(series, series %in% substr(paste(names(parseQueryString(session$clientData$url_search)), parseQueryString(session$clientData$url_search), sep = "=", collapse=", "), 8, 200)))
    series <- paste("<h3>",title,"</h3>")
    HTML(series)
  })
  
  output$dateRange <- renderUI({
    startRange <- as.character(min(subset(episodes_unique, seriesID == subset(seriesTitles, ID == substr(paste(names(parseQueryString(session$clientData$url_search)), parseQueryString(session$clientData$url_search), sep = "=", collapse=", "), 8, 200))$ID)$date))
    endRange <- as.character(max(subset(episodes_unique, seriesID == subset(seriesTitles, ID == substr(paste(names(parseQueryString(session$clientData$url_search)), parseQueryString(session$clientData$url_search), sep = "=", collapse=", "), 8, 200))$ID)$date))
    dateRangeInput('dateRange',
                   label = paste('Available time frame:', startRange, 'till', endRange, sep = " "),
                   start = startRange, end = endRange
    )
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {'episodes.csv'},
    content = function(file) {
      write.csv(subset(episodes_unique, episodeID %in% input$episodes & date %in% input$dateRange[1]:input$dateRange[2] & seriesID == subset(seriesTitles, ID == substr(paste(names(parseQueryString(session$clientData$url_search)), parseQueryString(session$clientData$url_search), sep = "=", collapse=", "), 8, 200))$ID), file, row.names = FALSE)
    }
  )

  output$downloadReport = downloadHandler(
    filename = 'report.pdf',
    
    content = function(file) {
      out = render('report.Rmd', clean = TRUE)
      file.copy(out, file)
    },
    
    contentType = 'application/pdf'
  )
  
})
