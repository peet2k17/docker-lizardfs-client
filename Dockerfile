FROM ubuntu:xenial

MAINTAINER prc2k10 <prc2k10@googlemail.com>

RUN apt-get -y update && apt-get -y install wget && \
    wget http://packages.lizardfs.com/lizardfs.key && apt-key add lizardfs.key && \
    echo "deb http://packages.lizardfs.com/ubuntu/xenial xenial main" > /etc/apt/sources.list.d/lizardfs.list && \
    echo "deb-src http://packages.lizardfs.com/ubuntu/xenial xenial main" >> /etc/apt/sources.list.d/lizardfs.list && \
    apt-get -y update && apt-get -y install lizardfs-client

ENV MOUNT=''

RUN mkdir /mnt/lizardfs

CMD [ "mfsmount /mnt/lizardfs" ]
