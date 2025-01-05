# https://github.com/percona/percona-docker/blob/main/percona-xtrabackup-8.0/Dockerfile
FROM percona/percona-xtrabackup:8.0.28

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-version.html
# https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ENV AWSCLI_VERSION=2.22.28

RUN microdnf install unzip hostname && \
  microdnf clean all && \
  curl -sSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip -o /tmp/awscliv2.zip && \
  unzip -q /tmp/awscliv2.zip -d /tmp && \
  /tmp/aws/install && \
  rm -rf /tmp/aws /tmp/awscliv2.zip

COPY xtrabackup.sh /
COPY backup.sh /

CMD ["/backup.sh"]
