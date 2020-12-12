FROM 0x01be/base as build

ENV REVISION=master
WORKDIR /iverilog
RUN apk add --no-cache --virtual iverilog-build-dependencies \
    git \
    build-base \
    autoconf \
    gperf \
    flex \
    bison &&\
    git clone --depth 1 --branch ${REVISION} git://github.com/steveicarus/iverilog.git /iverilog &&\
    autoconf &&\
    ./configure --prefix /opt/iverilog/ &&\
     make
RUN make install

FROM 0x01be/base

COPY --from=build /opt/iverilog/ /opt/iverilog/

WORKDIR /workspace

RUN apk add --no-cache --virtual iverilog-runtime-dependencies \
    libstdc++ &&\
    adduser -D -u 1000 iverilog &&\
    chown iverilog:iverilog /workspace

USER iverilog
ENV PATH=${PATH}:/opt/iverilog/bin/

