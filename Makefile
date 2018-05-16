all: init clean build

build: build-exec build-image

build-exec:
	@echo "Building etcd operator"
	time ./hack/build/build

build-image:
	@echo "Building docker file"
	time docker build --tag "etcd-operator:test" -f hack/build/Dockerfile .

clean:
	rm -rf _output

init:
	@echo "updating vendored dependencies"
	time ./hack/update_vendor.sh

.PHONY: all clean init build build-exec build-image
