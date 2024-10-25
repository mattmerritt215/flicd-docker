FROM debian:stable-slim

LABEL maintainer="114206060+mattmerritt215@users.noreply.github.com"

ARG PLATFORM_ARCH=aarch64
ENV PLATFORM_ARCH=${PLATFORM_ARCH}

ENV HCI_DEV=hci0
ENV PORT=9551
ENV DB_NAME=flicd.debian

RUN mkdir /data /tmp/fliclib /scripts
RUN apt-get update \
    && apt-get install -y \
    git \
    net-tools \
    && rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 https://github.com/50ButtonsEach/fliclib-linux-hci /tmp/fliclib \
    && cp /tmp/fliclib/bin/${PLATFORM_ARCH}/flicd /usr/local/bin \
    && chmod +x /usr/local/bin/flicd \
    && rm -rf /tmp/fliclib

ADD ./*.sh /scripts/
RUN chmod +x /scripts/entrypoint.sh /scripts/healthcheck.sh

WORKDIR /data

HEALTHCHECK --interval=30s --timeout=15s --start-period=5s --retries=3 CMD /scripts/healthcheck.sh

VOLUME [ "/data" ]
ENTRYPOINT [ "/scripts/entrypoint.sh" ]
