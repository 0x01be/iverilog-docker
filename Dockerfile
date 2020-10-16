FROM alpine as build

RUN apk add --no-cache --virtual iverilog-build-dependencies \
    git \
    build-base \
    autoconf \
    gperf \
    flex \
    bison

ENV IVERILOG_REVISION master
RUN git clone --depth 1 --branch ${IVERILOG_REVISION} git://github.com/steveicarus/iverilog.git /iverilog

WORKDIR /iverilog

RUN autoconf
RUN ./configure --prefix /opt/iverilog/
RUN make
RUN make install

FROM alpine

COPY --from=builder /opt/iverilog/ /opt/iverilog/

RUN apk add --no-cache --virtual iverilog-runtime-dependencies \
    libstdc++

RUN adduser -D -u 1000 iverilog

WORKDIR /workspace

RUN chown iverilog:iverilog /workspace

USER iverilog

ENV PATH $PATH:/opt/iverilog/bin/

CMD ["iverilog", "-h"]

