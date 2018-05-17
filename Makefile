VERSION = $(shell git describe --tags --always --first-parent)
IMAGE_EXISTS = $(shell docker images -q etcd-operator:$(VERSION) 2> /dev/null)

ifeq ($(IMAGE_EXISTS), "")
all: init clean build
else
all:
endif

build: build-exec build-image

build-exec:
	@echo "Building etcd operator"
	time ./hack/build/build

build-image:
	@echo "Building image"
	time docker build --tag "etcd-operator:$(VERSION)" -f hack/build/Dockerfile .
	docker tag "etcd-operator:$(VERSION)" "etcd-operator:latest"

clean:
	rm -rf _output

init:
	@echo "updating vendored dependencies"
	time ./hack/update_vendor.sh

.PHONY: all clean init build build-exec build-image
