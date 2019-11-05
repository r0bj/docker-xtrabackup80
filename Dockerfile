FROM ubuntu:18.04

ENV XTRABACKUP_VERSION 8.0.7-1.bionic
ENV S3CMD_VERSION 2.0.2

RUN apt-get update \
  && apt-get install -y wget curl lsb-release gnupg pigz python3-setuptools \
  && wget -q https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb \
  && dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb \
  && rm -f percona-release_latest.$(lsb_release -sc)_all.deb \
  && percona-release setup ps80 \
  && apt-get install -y percona-xtrabackup-80=$XTRABACKUP_VERSION \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_VERSION}/s3cmd-${S3CMD_VERSION}.tar.gz \
  && tar xvpzf s3cmd-${S3CMD_VERSION}.tar.gz \
  && rm -f s3cmd-${S3CMD_VERSION}.tar.gz \
  && cd s3cmd-${S3CMD_VERSION} \
  && python3 setup.py install \
  && cd .. \
  && rm -rf s3cmd-${S3CMD_VERSION}

COPY xtrabackup.sh /
COPY backup.sh /

CMD [ "/backup.sh" ]
