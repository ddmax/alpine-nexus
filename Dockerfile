FROM alpine:3.3

ENV NEXUS_VERSION=2.12.1-01 \
    PATH=$PATH:/opt/nexus/bin

RUN apk add --no-cache curl tar openjdk8-jre && \
    mkdir -p /opt/nexus && \
    curl -sL "https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-${NEXUS_VERSION}-bundle.tar.gz" | tar xz -C /opt/nexus --strip-components=1

EXPOSE 8081

VOLUME /opt/nexus/data

CMD nexus run
