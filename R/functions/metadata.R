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

oc_presentation_call <- function(episodeID) {
  eID <- episodeID
  part1 <- "/search/episode.json?id="
  url <- paste(Sys.getenv('OC_PRESENTATION_URL'), part1, eID, sep = "")
  digest <- "./functions/digest.sh"
  systemCommand <- paste(digest, url, sep = " ")
  lines <- system(systemCommand, intern = TRUE)
  episode_raw <- fromJSON(lines)
  return(episode_raw)
}

episodeTitle <- function(episodeID) {
  eID <- episodeID
  if (nchar(eID) != 36) {
    return(NA)
  } else {
    episode_raw <- oc_presentation_call(eID)
    if (episode_raw$`search-results`[3] == 0) {
      return(NA)
    } else {
      title <- episode_raw[[1]][[6]][[3]][[4]]
      title
    }
  }
}

episodeSeriesID <- function(episodeID) {
  eID <- episodeID
  if (nchar(eID) != 36) {
    return(NA)
  } else {
    episode_raw <- oc_presentation_call(eID)
    if (episode_raw$`search-results`[3] == 0) {
      return(NA)
    } else {
      seriesID <- episode_raw[[1]][[6]][[3]][[5]]
      seriesID
    }
  }
}

episodeSeriesTitle <- function(episodeID) {
  eID <- episodeID
  if (nchar(eID) != 36) {
    return(NA)
  } else {
    episode_raw <- oc_presentation_call(eID)
    if (episode_raw$`search-results`[3] == 0) {
      return(NA)
    } else {
      seriesTitle <- episode_raw[[1]][[6]][[3]][[6]]
      seriesTitle
    }
  }
}
