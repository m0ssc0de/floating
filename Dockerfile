FROM golang:1.14.4 AS builder

WORKDIR /go/src/github.com/slackhq/nebula

RUN git clone https://github.com/slackhq/nebula.git ./

RUN make

FROM alpine:3.12.0 AS builder2

RUN apk add cargo

WORKDIR /src
RUN git clone https://github.com/m0ssc0de/floating.git ./
RUN cargo build --release

FROM alpine:3.12.0 AS nebula

RUN apk add --update libc6-compat

COPY --from=builder /go/src/github.com/slackhq/nebula/nebula /nebula
COPY --from=builder2 /src/target/release/tunnels /tunnels

COPY ./run.sh /run.sh

CMD sh /run.sh