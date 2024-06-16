FROM golang:1.22.4-bullseye as build

ARG NODE_VERSION
ARG MAX_KEY_ID

ENV GOEXPERIMENT=arenas

WORKDIR /opt/ceremonyclient

COPY . .

# 需要将代码的node文件夹复制到quil-docker文件夹内构建

RUN cp "node/node-${NODE_VERSION}-linux-amd64" "node/node"
RUN cp "node/node-${NODE_VERSION}-linux-amd64.dgst" "node/node.dgst"
RUN for i in $(seq 1 ${MAX_KEY_ID}); do \
      if [ -f node/node-${NODE_VERSION}-linux-amd64.dgst.sig.${i} ]; then \
        cp "node/node-${NODE_VERSION}-linux-amd64.dgst.sig.${i}" "node/node.dgst.sig.${i}"; \
      fi \
    done

WORKDIR /opt/ceremonyclient/client

RUN go build -o qclient ./main.go

RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.9.1

FROM ubuntu:22.04

ENV GOEXPERIMENT=arenas

COPY --from=build /opt/ceremonyclient/node/node /usr/local/bin
COPY --from=build /opt/ceremonyclient/node/node.dgst /usr/local/bin
COPY --from=build /opt/ceremonyclient/node/node.dgst.sig.* /usr/local/bin

COPY --from=build /opt/ceremonyclient/client/qclient /usr/local/bin

COPY --from=build /go/bin/grpcurl /usr/local/bin

WORKDIR /root

ENTRYPOINT ["node"]
