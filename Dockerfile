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

FROM rocker/shiny:latest
MAINTAINER WWU eLectures team <electures.dev@uni-muenster.de>

RUN  R -e "install.packages('reshape2', repos='http://cran.rstudio.com/')" \
  && R -e "install.packages('dplyr', repos='http://cran.rstudio.com/')" \
  && R -e "install.packages('RJSONIO', repos='http://cran.rstudio.com/')" \
  && R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"

RUN apt-get update && apt-get install -y -q curl texlive-base texlive texlive-fonts-extra \
  && apt-get clean \
  && rm -rf /tmp/* /var/tmp/*  \
  && rm -rf /var/lib/apt/lists/*

ADD R/ /srv/shiny-server/

# fix permissions
RUN chown shiny:shiny -R /srv/shiny-server

# This volume will hold the .csv files containing the data
VOLUME /srv/shiny-server/data

WORKDIR /srv/shiny-server

EXPOSE 3838
HEALTHCHECK CMD curl --fail http://localhost:3838/ || exit 1

