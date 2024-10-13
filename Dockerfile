FROM golang:1.22.4-bullseye as build

# 构建
# git clone https://source.quilibrium.com/quilibrium/ceremonyclient.git
# cd ceremonyclient
# curl -o Dockerfile https://raw.githubusercontent.com/lushdog/quil-docker/main/Dockerfile
# docker build -f Dockerfile --build-arg NODE_VERSION=1.4.19 --build-arg MAX_KEY_ID=13 -t quilibrium -t quilibrium:1.4.19 .

ARG NODE_VERSION
ARG MAX_KEY_ID

ENV GOEXPERIMENT=arenas

WORKDIR /opt/ceremonyclient

COPY . .

RUN apt-get update && apt-get install -y curl grep
RUN files=$(curl https://releases.quilibrium.com/release | grep linux-amd64) && \
    new_release=false && \
    for file in $files; do \
        version=$(echo "$file" | cut -d '-' -f 2); \
        if ! test -f "./$file"; then \
            curl "https://releases.quilibrium.com/$file" > "$file"; \
            new_release=true; \
        fi; \
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
