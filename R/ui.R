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

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Opencast Video Usage"),
  
  uiOutput("queryText"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      uiOutput("dateRange"),
      
      checkboxInput("recDates", "Plot recording dates.", FALSE),
      
      uiOutput("episodesList"),
      
      downloadButton('downloadData', 'Download Data'),
      
      downloadButton('downloadReport', 'Download Report')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("episodePlot"),
      dataTableOutput("episodesTable")
    )
  )
))
