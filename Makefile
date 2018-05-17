VERSION = $(shell git describe --tags --always --first-parent)

all: init clean build

build: build-exec build-image

build-exec:
	@echo "Building etcd operator"
	time ./hack/build/build

build-image:
	@if [ "$$(docker images -q etcd-operator:$(VERSION) 2> /dev/null)" == "" ]; then \
		echo "building image!"; \
		time docker build --tag "etcd-operator:$(VERSION)" -f hack/build/Dockerfile . ; \
		docker tag "etcd-operator:$(VERSION)" "etcd-operator:latest" ; \
	else \
		echo "Building docker file not necessary as etcd-operator:$(VERSION) already exists." ; \
	fi
clean:
	rm -rf _output

init:
	@echo "updating vendored dependencies"
	time ./hack/update_vendor.sh

.PHONY: all clean init build build-exec build-image
