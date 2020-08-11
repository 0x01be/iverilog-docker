FROM alpine as builder

RUN apk add --no-cache --virtual iverilog-build-dependencies \
    git \
    build-base \
    autoconf \
    gperf \
    flex \
    bison

RUN git clone --depth 1 git://github.com/steveicarus/iverilog.git /iverilog

WORKDIR /iverilog

RUN autoconf
RUN ./configure --prefix /opt/iverilog/
RUN make
RUN make install

FROM alpine

COPY --from=builder /opt/iverilog/ /opt/iverilog/

ENV PATH $PATH:/opt/iverilog/bin/

VOLUME /workspace
WORKDIR /workspace

