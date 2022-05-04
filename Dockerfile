# https://github.com/percona/percona-docker/blob/main/percona-xtrabackup-8.0/Dockerfile
FROM percona/percona-xtrabackup:8.0.28

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-version.html
# https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ENV AWSCLI_VERSION 2.6.1

RUN microdnf install unzip hostname \
  && microdnf clean all \
  && cd /root \
  && curl -o awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -f awscliv2.zip

COPY xtrabackup.sh /
COPY backup.sh /

CMD [ "/backup.sh" ]
