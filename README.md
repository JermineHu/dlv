# Used remote debug in dlv for golang

## Code

```
FROM golang:alpine as build_dlv

# set go mod proxy
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk add gcc musl-dev && \
    go env -w GOPROXY=https://goproxy.cn,direct && go get -v github.com/go-delve/delve/cmd/dlv && dlv version

FROM alpine:edge
ENV GOPATH="/go"
ENV GOMODCACHE="/go/pkg/mod"
ENV GOPROXY="https://goproxy.cn,direct"
WORKDIR /app
COPY --from=build_dlv /go/bin/dlv /bin
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk add go gcc g++ musl-dev && go version
```

## Usage

*For debug* 

```
podman run --privileged --rm  -it -v "$PWD":"/app" -v ~/podman/go:/go  -p 2345:2345 docker.io/jermine/dlv dlv debug --headless --listen=:2345 --api-version=2 --accept-multiclient  main.go
```

`-v "$PWD":"/app"` for set your go project workspace,`-v ~/podman/go:/go` for set cache in local when you building code.
