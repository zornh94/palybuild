#Compile
BIN := playbuild
GOOS := ${if ${GOOS},${GOOS},${shell go env GOOS}}
ARCH := ${if ${GOARCH},${GOARCH},${shell go env GOARCH}}
SRC_DIRS := cmd pkg
VERSION ?= ${shell git describe --tags --always --dirty}
OUTBIN = bin/${GOOS}_${ARCH}/playbuild
OUT_APP_CLI = bin/${GOOS}_${ARCH}/cli
OUT_APP_HTTP = bin/${GOOS}_${ARCH}/httpserver

GO_VER = "$(shell govvv -flags)"

#Image
IMG_BASE ?= golang:1.13-alpine
IMG_BUILD ?= gct.io/distroless/static

#Container
REGISTRY ?= docker.pkg.github.com
IMG ?= ${REGISTRY}/${BIN} 
TAG ?= ${VERSION}_${GOOS}_${ARCH}

#private 
TOKEN = 092cc3105bdabe42b97ebff166ae04ed4c1d210b



OUTDIR := bin/$(GOOS)_$(ARCH) \
	.go/bin/$(GOOS)_$(ARCH) \
	.go/cache

build: bin/$(GOOS)_$(ARCH)/$(BIN) 

$(OUTBIN): .go/$(OUTBIN).stamp
	@echo "____________________________"
	@true

.PHONY: .go/$(OUTBIN).stamp 
.go/$(OUTBIN).stamp: $(OUTDIR)
	@echo "建置${BIN} image"
	@docker run \
	-i \
	--rm \
	-u $$(id -u):$$(id -g)  \
	-v $$(pwd):/src \
	-w /src \
	-v $$(pwd)/.go/bin/${GOOS}_${ARCH}:/go/bin  \
	-v $$(pwd)/.go/bin/${GOOS}_${ARCH}:/go/bin/${GOOS}_${ARCH}  \
	-v $$(pwd)/.go/cache:/.cache \
	--env HTTP_PROXY=${HTTP_PROXY} \
	--env HTTPS_PROXY=${HTTPS_PROXY} \
	--env APP_VERSION=${GO_VER}      \
	${IMG_BASE} 		\
	/bin/sh -c "            \
	 ARCH=$(ARCH)		\
 	 OS=$(GOOS)		\
	 VERSION=$(VERSION)	\
	 ./build/build.sh	\
	 "
	@if ! cmp -s $@ $(OUTBIN); then \
		mv $@ $(OUTBIN); \
		date > $@; \
	fi  
	@[ -f .go/$(OUT_APP_CLI) ] && mv .go/$(OUT_APP_CLI) $(OUT_APP_CLI)
	@[ -f .go/$(OUT_APP_HTTP) ] && mv .go/$(OUT_APP_HTTP) $(OUT_APP_HTTP) 

${OUTDIR}:
	@echo $@
	@mkdir -p $@
	@echo "$@ created"
	

.PHONY: ii 
ii:
	@echo "建置${BIN} image"
	@docker run \
	-d \
	-it \
	--rm \
	-u $$(id -u):$$(id -g)  \
	-v $$(pwd):/src \
	-w /src \
	-v $$(pwd)/.go/bin/${GOOS}_${ARCH}:/go/bin  \
	-v $$(pwd)/.go/bin/${GOOS}_${ARCH}:/go/bin/${GOOS}_${ARCH}  \
	-v $$(pwd)/.go/cache:/.cache \
	--env HTTP_PROXY=${HTTP_PROXY} \
	--env HTTPS_PROXY=${HTTPS_PROXY} \
	${IMG_BASE} 		\
	/bin/sh -c  " \
	sleep 10000 \
	"
