FROM golang:1.24 AS builder

WORKDIR /src/minio

RUN apt-get update && apt-get install -y make

COPY minio/ ./

RUN make build

FROM alpine:3

RUN apk add --no-cache ca-certificates

COPY --from=builder /src/minio/minio /usr/bin/minio

EXPOSE 9000 9001

ENTRYPOINT ["/usr/bin/minio"]
CMD ["server", "/data"]
