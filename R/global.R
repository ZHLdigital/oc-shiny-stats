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

source('functions/range.R', local = TRUE)
source('functions/users.R', local = TRUE)
source('functions/metadata.R', local = TRUE)
source('functions/missing-metadata.R', local = TRUE)
source('functions/cleanandstore.R', local = TRUE)
source('functions/access-series.R', local = TRUE)
source('functions/access-series-episodes.R', local = TRUE)

secondline <- system("head -n 2 data/episodes.csv | tail -n 1", intern = TRUE)
from <- substr(strsplit(secondline, split = ',')[[1]][3], 2, 11)
lastline <- system("awk 'END {print}' data/episodes.csv", intern = TRUE)
last <- substr(strsplit(lastline, split = ',')[[1]][3], 2, 11)
to <- last

episodeTitles <- read.csv(file = 'data/episodetitles.csv', header = TRUE, stringsAsFactors = FALSE)
episodeTitles <- subset(episodeTitles, Title != "Event Deleted")
episodeTitles$Date <- as.Date(episodeTitles$Date)

seriesTitles <- read.csv(file = 'data/seriestitles.csv', header = TRUE, stringsAsFactors = FALSE)
seriesTitles <- subset(seriesTitles, Title != "Series Deleted")
seriesTitles <- subset(seriesTitles, Title != "Testaufnahmen")
series <- seriesTitles$ID
names(series) <- seriesTitles$Title

episodes_unique <- access_series_episodes(from, to)
colnames(episodes_unique) <- c("episodeID", "seriesID", "date", "counts", "Episodes")
episodes_unique$Episodes <- as.character(episodes_unique$Episodes)
episodes_unique <- subset(episodes_unique, Episodes != "character(0)")
episodeIDs <- unique(episodes_unique$episodeID)
names <- c(1:length(episodeIDs))
for (i in 1:length(episodeIDs)) {
  sub <- subset(episodes_unique, episodeID == episodeIDs[i])
  names[i] <- unique(sub$Episodes)
}
names(episodeIDs) <- names
episodeIDs <- episodeIDs[order(names(episodeIDs))]
dates <- c(1:length(episodeIDs))
for (i in 1:length(episodeIDs)) {
  dates[i] <- subset(episodeTitles, ID == episodeIDs[i])$Date
}
dates <- as.Date(dates, origin="1970-01-01")
