IMAGE_NAME:=lcft
BUILD_DATE:=$(shell date -u +%Y%m%d)

build:	FORCE
	echo $(BUILD_DATE) > ./BUILD_DATE
	bash docker.sh build

tag:	build
	docker tag $(IMAGE_NAME) livcomp/$(IMAGE_NAME):latest
	docker tag $(IMAGE_NAME) livcomp/$(IMAGE_NAME):$(BUILD_DATE)

push:	tag
	docker push livcomp/$(IMAGE_NAME):latest
	docker push livcomp/$(IMAGE_NAME):$(BUILD_DATE)

.PHONY:	FORCE
