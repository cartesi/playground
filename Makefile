# Copyright 2020 Cartesi Pte. Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
#
#
.PHONY: build run push

TAG ?= devel
IMG_REPO ?= cartesi/playground
IMG ?= $(IMG_REPO):$(TAG)

build:
	docker build -t $(IMG) .

push:
	docker push $(IMG)

run:
	@docker run \
		 -e USER=$$(id -u -n) \
		 -e GROUP=$$(id -g -n) \
		 -e UID=$$(id -u) \
		 -e GID=$$(id -g) \
		 -v `pwd`:/home/$$(id -u -n) \
		 -it \
		 -h playground \
		 -w /home/$$(id -u -n) \
		 --rm $(IMG) /bin/bash

exec:
	docker exec \
		 -e USER=$$(id -u -n) \
		 -e GROUP=$$(id -g -n) \
		 -e UID=$$(id -u) \
		 -e GID=$$(id -g) \
         -u $$(id -u):$$(id -g) \
		 -it \
		 -w /home/$$(id -u -n) \
		$$(docker ps --filter "ancestor=$(IMG)" --format="{{.Names}}" | head -n 1) \
		bash
