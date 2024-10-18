FROM golang:1.22.4-bullseye as build

WORKDIR /opt/node/

RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.9.1

FROM ubuntu:22.04

ENV GOEXPERIMENT=arenas

RUN apt-get update && apt-get install -y curl grep ca-certificates

WORKDIR /opt/node/

COPY ./node_file/ /usr/local/bin

COPY --from=build /go/bin/grpcurl /usr/local/bin

WORKDIR /root

ENTRYPOINT ["node"]
