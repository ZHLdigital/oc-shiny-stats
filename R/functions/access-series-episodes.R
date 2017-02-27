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

access_series_episodes <- function(from, to) {

episodes <- read.csv(file = 'data/episodes.csv', header = TRUE)
episodes$date <- as.Date(episodes$date, '%Y-%m-%d')

dates <- seq(as.Date(from), as.Date(to), "days")
row <- which(episodes$date %in% dates)
episodes_dates <- episodes[which(episodes$date %in% dates),]

episodes_dates$episodeID <- as.character(episodes_dates$episodeID)
episodes_dates$date <- as.character(episodes_dates$date)

combi <- unique(episodes_dates[,c('episodeID', 'seriesID','date')])
counts <- apply(combi, MARGIN=1, FUN=function(x) 
  sum(episodes_dates$total[ (episodes_dates$episodeID %in% x) & (episodes_dates$date %in% x)])
)

episodes_unique <- data.frame(combi, counts)

episodes_unique['episodeTitle'] <- NA
for (i in 1:nrow(episodes_unique)) {
  episodes_unique$episodeTitle[i] <- subset(episodeTitles, ID == episodes_unique$episodeID[i])[2]
}
episodes_unique$date <- as.Date(episodes_unique$date)

episodes_unique
}
 
