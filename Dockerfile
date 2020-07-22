FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base \
    autoconf \
    gperf \
    flex \
    bison

RUN git clone git://github.com/steveicarus/iverilog.git /iverilog

WORKDIR /iverilog

RUN autoconf
RUN ./configure --prefix /opt/iverilog/
RUN make
RUN make install

FROM alpine:3.12.0

COPY --from=builder /opt/iverilog/ /opt/iverilog/

ENV PATH $PATH:/opt/iverilog/bin/
