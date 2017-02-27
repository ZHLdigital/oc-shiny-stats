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

userActions <- function(day, type = 'VIEWS') {

  var_type <- type
  var_day <- day
  part1 <- "/usertracking/actions.json?type="
  part2 <- "&day="
  part3 <- "&limit=1000000000&offset=0"
  url <- paste(Sys.getenv('OC_ADMIN_URL'), part1, var_type, part2, var_day, part3, sep = "")
  
  actions_raw <- fromJSON(url)
  actions_tmp <- actions_raw[['actions']]
  actions <- actions_tmp[['action']]
  
  for (i in 1:length(actions)) {
    
    session <- actions[[i]][[3]]
    actions[[i]][[3]] <- session[2]
    
  }
  
  df_actions <- do.call(rbind.data.frame, actions)
  return(df_actions)
}

filterActions <- function(day) {
  actions <- userActions(day)
  
  df_subset <- data.frame(actions)
  return(df_subset)
  
}

viewsDateRange <- function(from, to) {
  dates <- seq(as.Date(from), as.Date(to), "days")
  dates <- format(as.Date(dates, format="%d/%m/%Y"),"%Y%m%d")
  actions <- data.frame()
  
  for (i in 1:length(dates)) { 
    actions <- rbind(actions, filterActions(dates[i]))
  }
  
  return(actions)
}
