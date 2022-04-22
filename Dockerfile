FROM golang:alpine as build_dlv

# 设置go mod 代理
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