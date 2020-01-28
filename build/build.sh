#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

echo "APP_VERSION: $APP_VERSION"
echo ""
if [ -z "${OS:-}" ]; then
	echo "OS must be set"
	exit 1
fi

if [ -z "${ARCH:-}" ]; then
	echo "ARCH must be set"
	exit 1
fi

if [ -z "${VERSION:-}" ]; then
	echo "VERSION must be set"
	exit 1
fi


export CGO_ENABLED=0
export GOARCH="${ARCH}"
export GOOS="${OS}"
export GO111MODULE=on
export GOFLAGS="-mod=vendor"

#go mod vendor && \
#go install \ 
#	-installsuffix "static" \
#	-ldflags "-X $(go list -m)/pkg/version.Version=${VERSION}" \
#	./...
#
#-ldflags "-X $(go list -m)/pkg/version.Version=${VERSION}"  \

#    -ldflags "-X $(go list -m)/pkg/version.Version=${VERSION}"  \
go mod vendor

go install                                                      \
    -installsuffix "static"                                     \
    -ldflags "$APP_VERSION"  \
    ./...

echo "OS:${OS}"
echo "AR:${ARCH}"
echo "V:${VERSION}"

