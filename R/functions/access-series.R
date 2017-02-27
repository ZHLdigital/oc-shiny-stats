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

access_series <- function(from, to, filterseries) {

episodes <- read.csv(file = 'data/episodes.csv', header = TRUE)
episodes$date <- as.Date(episodes$date, '%Y-%m-%d')
access_series <- episodes[,c(2:4)]

dates <- seq(as.Date(from), as.Date(to), "days")
row <- which(access_series$date %in% dates)
series <- access_series[which(access_series$date %in% dates),]

series$seriesID <- as.character(series$seriesID)
series$date <- as.character(series$date)

combi <- unique(series[,c('seriesID', 'date')])
counts <- apply(combi, MARGIN=1, FUN=function(x) 
  sum(series$total[ (series$seriesID %in% x) & (series$date %in% x)])
)

series_date <- data.frame(combi, counts)

series_date <- subset(series_date, seriesID == filterseries)

series_date['seriesTitle'] <- NA
for (i in 1:nrow(series_date)) {
  series_date$seriesTitle[i] <- subset(seriesTitles, ID == series_date$seriesID[i])[2]
}
series_date <- series_date[,2:4]
series_date$date <- as.Date(series_date$date)
series_date
}
