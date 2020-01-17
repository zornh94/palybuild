#FROM golang:alpine as builder

#set necessary environment variables
#ENV GO111MODULE=on

# Install git and certificates
#RUN apk --no-cache add tzdata zip ca-certificates git

# Make repository path
#RUN mkdir -p /go/src/github.com/zornh94/palybuild
#WORKDIR /go/src/github.com/zornh94/palybuild

# Install deps
#RUN go get -u -v github.com/ahmetb/govvv && \
#	go get -u -v github.com/gorilla/mux

# Copy all project files
#ADD . .

#WORKDIR /build
#COPY go.mod .
#COPY go.sum .
#RUN go mod download

#RUN go get -u -v github.com/ahmetb/govvv && \
#	go get -u -v github.com/gorilla/mux
#COPY . .
# Generate a binary
#RUN env GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -ldflags "$(govvv -flags)" -o app


# Second (final) stage, base image is scratch
#FROM scratch
# Copy statically linked binary
#COPY --from=builder /go/src/github.com/zornh94/palybuild/app /app
# Copy SSL certificates, eventhough we don't need it for this example
# but if you decide to talk to HTTPS sites, you'll need this, you'll thank me later.
#COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

#COPY --from=builder /build/app /app
#EXPOSE 8000
#ENTRYPOINT [ "/app" ]

FROM golang:alpine as builder

WORKDIR /build

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

COPY go.mod .
COPY go.sum .
RUN go mod download 


COPY . .

#RUN env CGO_ENABLED=0 GOOS=linux GOARCH=amd64  go build -a  -ldflags "$(govvv -flags)" -o app .
RUN go build -o app .



FROM scratch
COPY --from=builder /build/app /
ENTRYPOINT ["/app"] 

