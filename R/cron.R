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

library('reshape2')
library('RJSONIO')

source('functions/range.R', local = TRUE)
source('functions/users.R', local = TRUE)
source('functions/metadata.R', local = TRUE)
source('functions/missing-metadata.R', local = TRUE)
source('functions/cleanandstore.R', local = TRUE)

# Get and save new episodes
lastline <- system("awk 'END {print}' data/episodes.csv", intern = TRUE)
last <- substr(strsplit(lastline, split = ',')[[1]][3], 2, 11)
from <- as.Date(last) + 1
to <- Sys.Date() - 1
if (from - 1 != to) {
  dates <- seq(as.Date(from), as.Date(to), "days")
  filterdates <- format(as.Date(dates, format="%d/%m/%Y"),"%Y-%m-%d")
  
  for (i in 1:length(filterdates)) {
    store(filterdates[i])
  }
}

episodes <- read.csv(file = 'data/episodes.csv', header = TRUE, stringsAsFactors = FALSE)

# Get and save new episode titles
episodeTitles <- read.csv(file = 'data/episodetitles.csv', header = TRUE, stringsAsFactors = FALSE)
allepisodes <- unique(episodes$episodeID)
savedepisodes <- unique(episodeTitles$ID)
episodestoadd <- subset(allepisodes, !(allepisodes %in% savedepisodes))

if (length(episodestoadd) > 0) {
  new <- data.frame(matrix(NA, nrow = length(episodestoadd), ncol = 3))
  colnames(new) <- c("ID", "Title", "Date")
  for (i in 1:length(episodestoadd)) {
    new$ID[i] <- episodestoadd[i]
    new$Title[i] <- episodeTitle_AdminUI(episodestoadd[i])
    new$Date[i] <- episodeRecordingDate_AdminUI(episodestoadd[i])
  }
  eTitles <- rbind(episodeTitles, new)
  write.csv(eTitles, file = 'data/episodetitles.csv', na='NA', row.names = FALSE)
}

# Get and save new series
seriesTitles <- read.csv(file = 'data/seriestitles.csv', header = TRUE, stringsAsFactors = FALSE)
allseries <- unique(episodes$seriesID)
savedseries <- unique(seriesTitles$ID)
seriestoadd <- subset(allseries, !(allseries %in% savedseries))

if (length(seriestoadd) > 0) {
  newseries <- data.frame(matrix(NA, nrow = length(seriestoadd), ncol = 2))
  colnames(newseries) <- c("ID", "Title")
  for (i in 1:length(seriestoadd)) {
    newseries$ID[i] <- seriestoadd[i]
    newseries$Title[i] <- seriesTitle_AdminUI(seriestoadd[i])
  }
  sTitles <- rbind(seriesTitles, newseries)
  write.csv(sTitles, file = 'data/seriestitles.csv', na='NA', row.names = FALSE)
}
