####################
# BASE IMAGE
####################
FROM ubuntu:16.04

MAINTAINER prc2k10@googlemail.com <prc2k10@googlemail.com>

####################
# INSTALLATIONS
####################
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
        curl \
        fuse \
        wget \
        ca-certificates && \
    update-ca-certificates && \
    apt-get install -y openssl && \
    sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

RUN wget http://packages.lizardfs.com/lizardfs.key && apt-key add lizardfs.key && \
    echo "deb http://packages.lizardfs.com/ubuntu/xenial xenial main" > /etc/apt/sources.list.d/lizardfs.list && \
    echo "deb-src http://packages.lizardfs.com/ubuntu/xenial xenial main" >> /etc/apt/sources.list.d/lizardfs.list

RUN apt-get -y update && apt-get -y install lizardfs-client

# S6 overlay
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

RUN \
    OVERLAY_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
    curl -o /tmp/s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-amd64.tar.gz" && \
    tar xfz  /tmp/s6-overlay.tar.gz -C /

ENV MOUNT=''

RUN mkdir /mnt/lizardfs

VOLUME /mnt/lizardfs

####################
# ENTRYPOINT
####################
ENTRYPOINT ["/init"]
