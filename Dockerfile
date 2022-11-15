FROM golang:alpine as builder

RUN apk --no-cache add git

WORKDIR /go/src/github.com/go/e7book/
COPY . .
RUN go env -w GOPROXY="https://goproxy.cn, direct"
RUN go env -w GO111MODULE=on
RUN go get -d -v github.com/go-sql-driver/mysql

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app app.go

FROM alpine:latest as prod

RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=builder /go/src/github.com/go/e7book/app .

CMD ["./app"]