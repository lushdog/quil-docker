FROM golang:1.22.4-bullseye as build

WORKDIR /opt/node

COPY . .

RUN apt-get update && apt-get install -y curl grep

RUN curl -o fetch.sh https://raw.githubusercontent.com/lushdog/quil-docker/refs/heads/main/fetch.sh && chmod +x fetch.sh && ./fetch.sh

RUN chmod +x node

WORKDIR /opt/node

RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.9.1

FROM ubuntu:22.04

ENV GOEXPERIMENT=arenas

COPY --from=build /opt/node /usr/local/bin
COPY --from=build /opt/node.dgst /usr/local/bin
COPY --from=build /opt/node.dgst.sig.* /usr/local/bin

COPY --from=build /opt/qclient /usr/local/bin
COPY --from=build /opt/qclient.dgst /usr/local/bin
COPY --from=build /opt/qclient.dgst.sig.* /usr/local/bin

COPY --from=build /go/bin/grpcurl /usr/local/bin

WORKDIR /root

ENTRYPOINT ["node"]
