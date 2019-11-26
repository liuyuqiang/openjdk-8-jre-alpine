FROM alpine:3.10.3

LABEL maintainer="liuyuqiang <yuqiangliu@outlook.com>"

#Default to UTF-8 file.encoding
ENV LANG=C.UTF-8

ENV TIMEZONE Asia/Shanghai
ENV TZ=Asia/Shanghai
RUN sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories && apk add -U tzdata && ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo "${TIMEZONE}" > /etc/timezone

RUN apk add fontconfig && apk add --update ttf-dejavu && fc-cache --force

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ lrzsz && \
    # DEPENDENCY TO ALLOW USERS TO RUN crontab
    apk add --no-cache --update busybox-suid

RUN echo @testing http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    echo /etc/apk/respositories && \
    apk update && apk upgrade &&\
    apk add --no-cache \
    bash \
    openssh-client \
    wget \
    supervisor \
    curl \
    git \
    python \
    python-dev \
    py-pip && \
    pip install -U pip && \
    apk del gcc musl-dev linux-headers python-dev

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
RUN { \
        echo '#!/bin/sh'; \
        echo 'set -e'; \
        echo; \
        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home
RUN apk add --no-cache openjdk8 && [ "$JAVA_HOME" = "$(docker-java-home)" ]