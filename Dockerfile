FROM golang:1.22.4-bullseye as build

WORKDIR /opt/node/

RUN apt-get update && apt-get install -y curl grep ca-certificates

RUN curl -o fetch.sh https://raw.githubusercontent.com/lushdog/quil-docker/refs/heads/main/fetch.sh && chmod +x fetch.sh && ./fetch.sh

RUN chmod +x node

RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.9.1


FROM ubuntu:22.04

ENV GOEXPERIMENT=arenas

RUN apt-get update && apt-get install -y ca-certificates

COPY --from=build /opt/node/node /usr/local/bin
COPY --from=build /opt/node/node.dgst /usr/local/bin
COPY --from=build /opt/node/node.dgst.sig.* /usr/local/bin

COPY --from=build /opt/node/qclient /usr/local/bin
COPY --from=build /opt/node/qclient.dgst /usr/local/bin
COPY --from=build /opt/node/qclient.dgst.sig.* /usr/local/bin

COPY --from=build /go/bin/grpcurl /usr/local/bin

WORKDIR /root

ENTRYPOINT ["node"]
