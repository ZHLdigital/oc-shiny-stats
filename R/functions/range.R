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

importRange <- function(from, to) {
  
  start <- from
  end <- to
  part1 <- "/usertracking/report.json?from="
  part2 <- "&to="
  part3 <- "&limit=10000000&offset=0"
  url <- paste(Sys.getenv('OC_ADMIN_URL'), part1, start, part2, end, part3, sep = "")
  
  range_raw <- fromJSON(url)
  range <- range_raw[['report']]
  return(range)
}

viewsRange <- function(from, to) {
  
  range <- importRange(from, to)
  views <- range[['views']]
  print(views)
}

episodesViewsRange <- function(from, to) {
  
  range <- importRange(from, to)
  episodes_raw <- range[['report-item']]
  episodes <- do.call(rbind.data.frame, episodes_raw)
  return(episodes)
}
