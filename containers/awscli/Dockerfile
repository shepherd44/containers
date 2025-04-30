ARG AWSCLI_VERSION
FROM amazon/aws-cli:${AWSCLI_VERSION}

ARG POSTGRES_VERSION

RUN amazon-linux-extras enable postgresql${POSTGRES_VERSION}
RUN yum install -y postgresql${POSTGRES_VERSION} gzip
