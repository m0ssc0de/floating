FROM golang:1.14.4 AS builder

WORKDIR /go/src/github.com/slackhq/nebula

RUN git clone https://github.com/slackhq/nebula.git ./

RUN make

FROM alpine:3.12.0 AS builder2

RUN apk add cargo git

WORKDIR /src
COPY ./ ./
ENV RUSTFLAGS="-C target-feature=+crt-static"
RUN cargo build --release --target=x86_64-alpine-linux-musl


FROM alpine:3.12.0 AS nebula

RUN apk add --update libc6-compat

COPY --from=builder /go/src/github.com/slackhq/nebula/nebula /nebula
COPY --from=builder2 /src/target/x86_64-alpine-linux-musl/release/tunnels /tunnels

ENV PORT 6443

COPY ./run.sh /run.sh

CMD sh /run.sh