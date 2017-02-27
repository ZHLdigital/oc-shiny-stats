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

VERSION=$(shell cat VERSION)
IMAGE=electures-registry.uni-muenster.de/oc-shiny-stats

all: build
build:
	docker build \
		-t ${IMAGE} -t ${IMAGE}:${VERSION} .
.PHONY: build
clean:
	-docker rmi ${IMAGE} ${IMAGE}:${VERSION}
.PHONY: clean
