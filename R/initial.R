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

dir.create('data')

# Get and save new episodes
from <- '2017-02-04'
to <- '2017-02-06'

dates <- seq(as.Date(from), as.Date(to), "days")
filterdates <- format(as.Date(dates, format="%d/%m/%Y"),"%Y-%m-%d")

episodes <- data.frame("episodeID"=character(),"seriesID"=character(),"date"=character(),"total"=integer())
for (i in 1:length(filterdates)) {
  new <- dfEpisodeDate(filterdates[i])
  episodes <- rbind(episodes, new)
  episodes <- missingSeriesID(episodes)
  write.csv(episodes, file = 'data/episodes.csv', na='NA', row.names = FALSE)
}

episodes <- read.csv(file = 'data/episodes.csv', header = TRUE, stringsAsFactors = FALSE)

# Get and save new episode titles
episodeTitles <- data.frame("ID"=character(),"Title"=character(),"Date"=character())
episodestoadd <- unique(episodes$episodeID)

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
seriesTitles <- data.frame("ID"=character(),"Title"=character())
seriestoadd <- unique(episodes$seriesID)

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
