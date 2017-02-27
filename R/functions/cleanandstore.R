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

store <- function(date) {
  existing <- read.csv(file = 'data/episodes.csv', header = TRUE, stringsAsFactors = FALSE)
  new <- dfEpisodeDate(date)
  episodes <- rbind(existing, new)
  episodes <- missingSeriesID(episodes)
  write.csv(episodes, file = 'data/episodes.csv', na='NA', row.names = FALSE)
}

dfEpisodeDate <- function(getDate) {

  filterdates <- getDate
  
  total <- viewsDateRange(getDate, getDate)
  studenthits <- data.frame(lapply(total, as.character), stringsAsFactors = FALSE)
  
  studentviews <- data.frame(matrix(NA, nrow = nrow(studenthits), ncol = 4))
  colnames(studentviews) <- c("id", "episodeID", "sessionID", "date")
  
  for (i in 1:nrow(studentviews)) {
    studentviews$id[i] <- studenthits$id[i]
    studentviews$episodeID[i] <- studenthits$mediapackageId[i]
    studentviews$sessionID[i] <- studenthits$sessionId[i]
    studentviews$date[i] <- studenthits$created[i]
  }
  
  studentviews <- subset(studentviews, nchar(episodeID) == 36)
  
  episodes <- unique(studentviews$episodeID)
  episodesbydate <- data.frame(matrix(NA, nrow = length(episodes), ncol = 4))
  colnames(episodesbydate) <- c("episodeID", "seriesID", "date", "total")
  
  for (i in 1:length(episodes)) {
    episodesbydate$episodeID[i] <- episodes[i]
    episodesbydate$seriesID[i] <- episodeSeriesID(episodes[i])
    episodesbydate$date[i] <- substr(studentviews$date[i], start=1, stop=10)
    subset <- subset(studentviews, episodeID == episodes[i])
    episodesbydate$total[i] <- length(subset$sessionID)
  }
  episodesbydate
}
