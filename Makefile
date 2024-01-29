BIN := zj-cli
PKG = $(shell cat go.mod | grep "^module " | sed -e "s/module //g")
VERSION = v$(shell cat version/version)
COMMIT_SHA ?= $(shell git describe --always)

GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)
GOBUILD=CGO_ENABLED=0 go build -ldflags "-X ${PKG}/version.Version=${VERSION}+sha.${COMMIT_SHA}"
GOINSTALL=CGO_ENABLED=0 go install -ldflags "-X ${PKG}/version.Version=${VERSION}+sha.${COMMIT_SHA}"
GOBIN ?= $(shell go env GOPATH)/bin

MAIN_ROOT ?= .

.PHONY:echo
echo:
	@echo "PKG:${PKG}"
	@echo "VERSION:${VERSION}"
	@echo "COMMIT_SHA:${COMMIT_SHA}"
	@echo "GOOS:${GOOS}"
	@echo "GOARCH:${GOARCH}"
	@echo "GOBUILD:${GOBUILD}"
	@echo "GOINSTALL:${GOINSTALL}"
	@echo "GOBIN:${GOBIN}"

.PHONY:all
all: clean build

.PHONY:install
install: download
	$(GOINSTALL)

.PHONY:build
build:
	$(GOBUILD) -o $(BIN)

.PHONY: test
test: build
	go test -v ./...

.PHONY: show-version
show-version:
	@echo $(VERSION)  # silent echo

$(GOBIN)/gobump:
	go install github.com/x-motemen/gobump/cmd/gobump@latest

.PHONY:download
download:
	go mod download -x

.PHONY:clean
clean:
	rm -rf ./cmd/$(BIN)

.PHONY:upgrade
upgrade:
	go get -u ./...

.PHONY:tidy
tidy:
	go mod tidy

.PHONY:docker
docker:
	docker buildx build --push --progress plain --platform=${PLATFORM}	\
		--file=./Dockerfile \
		--tag=$(BIN):${VERSION} \
		.