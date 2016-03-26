FROM alpine:3.3

ENV SONATYPE_WORK /sonatype-work
ENV NEXUS_VERSION 2.12.1-01

ENV JAVA_HOME /opt/java
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 77
ENV JAVA_VERSION_BUILD 02

RUN apk add --no-cache curl tar

# Install Oracle JRE
RUN mkdir -p /opt \
  && curl --fail --silent --location --retry 3 \
  --header "Cookie: oraclelicense=accept-securebackup-cookie; " \
  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/server-jre-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz \
  | gunzip \
  | tar -x -C /opt \
  && ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME}

# Install Nexus
RUN mkdir -p /opt/sonatype/nexus \
    && curl -sfL "https://download.sonatype.com/nexus/oss/nexus-${NEXUS_VERSION}-bundle.tar.gz" \
    | tar xz -C /opt/sonatype/nexus --strip-components=1


RUN useradd -r -u 200 -m -c "nexus role account" -d ${SONATYPE_WORK} -s /bin/false nexus

VOLUME ${SONATYPE_WORK}


CMD nexus start
