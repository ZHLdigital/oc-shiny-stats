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

oc_admin_call <- function(ID, endpoint) {
  if (endpoint == 'event') {
    part1 <- "/admin-ng/event/"
  } else if (endpoint == 'series') {
    part1 <- "/admin-ng/series/"
  } else {
    return('No endpoint chosen')
  }
  part2 <- ID
  part3 <- "/metadata.json"
  url <- paste(Sys.getenv('OC_ADMIN_URL'), part1, part2, part3, sep = "")
  digest <- "./functions/digest.sh"
  systemCommand <- paste(digest, url, sep = " ")
  system(systemCommand)
  lines <- system(systemCommand, intern = TRUE)
  return(lines)
}

missingSeriesID <- function(missing) {
  for (i in 1:nrow(missing)) {
    if (is.na(missing$seriesID[i])) {
      missing$seriesID[i] <- seriesID_AdminUI(missing$episodeID[i])
    }
  }
  missing
}

episodeTitle_AdminUI <- function(episodeID) {
  lines <- oc_admin_call(episodeID, 'event')
  if (!grepl('Cannot find an event with id', lines)) {
    episode_raw <- fromJSON(lines)
    title <- episode_raw[[1]]$fields[[1]]$value
  } else {
    title <- 'Event Deleted'
  }
  title
}

seriesID_AdminUI <- function(episodeID) {
  lines <- oc_admin_call(episodeID, 'event')
  if (!grepl('Cannot find an event with id', lines)) {
    episode_raw <- fromJSON(lines)
    seriesID <- episode_raw[[1]]$fields[[7]]$value
  } else {
    seriesID <- 'Series Deleted'
  }
  seriesID
}

seriesTitle_AdminUI <- function(seriesID) {
  if (seriesID == 'Series Deleted') {
    return('Series Deleted')
  } else {
    lines <- oc_admin_call(seriesID, 'series')
    series_raw <- fromJSON(lines)
    seriesTitle <- series_raw[[1]]$fields[[1]]$value
    seriesTitle
  }
}

seriesOrganizer_AdminUI <- function(seriesID) {
  lines <- oc_admin_call(seriesID, 'series')
  series_raw <- fromJSON(lines)
  seriesOrganizer <- series_raw[[1]]$fields[[7]]$value
  seriesOrganizer
}

episodeRecordingDate_AdminUI <- function(episodeID) {
  lines <- oc_admin_call(episodeID, 'event')
  if (!grepl('Cannot find an event with id', lines)) {
    episode_raw <- fromJSON(lines)
    recdate <- episode_raw[[1]]$fields[[10]]$value
  } else {
    recdate <- 'Event Deleted'
  }
  recdate
}
