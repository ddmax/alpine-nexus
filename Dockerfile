FROM alpine:3.3

ENV SONATYPE_WORK /sonatype-work
ENV NEXUS_VERSION 2.12.1-01

ENV JAVA_HOME /opt/java
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 74
ENV JAVA_VERSION_BUILD 02

ENV NEXUS_PORT 80
ENV RUN_AS_USER root

RUN apk add --no-cache curl tar \
  openjdk8-jre

# Install Nexus
RUN mkdir -p /opt/sonatype/nexus \
    && mkdir -p ${SONATYPE_WORK} \
    && curl -sfL "https://download.sonatype.com/nexus/oss/nexus-${NEXUS_VERSION}-bundle.tar.gz" \
    | tar xz -C /opt/sonatype/nexus --strip-components=1

# Configuration
RUN sed -i "s#8081#${NEXUS_PORT}#g" /opt/sonatype/nexus/conf/nexus.properties

VOLUME ${SONATYPE_WORK}
EXPOSE ${NEXUS_PORT}

WORKDIR /opt/sonatype/nexus
ENV CONTEXT_PATH /
ENV MAX_HEAP 768m
ENV MIN_HEAP 256m
ENV JAVA_OPTS -server -Djava.net.preferIPv4Stack=true
ENV LAUNCHER_CONF ./conf/jetty.xml ./conf/jetty-requestlog.xml
CMD java -Dnexus-work=${SONATYPE_WORK} -Dnexus-webapp-context-path=${CONTEXT_PATH} \
  -Xms${MIN_HEAP} -Xmx${MAX_HEAP} \
  -cp 'conf/:lib/*' \
  ${JAVA_OPTS} \
  org.sonatype.nexus.bootstrap.Launcher ${LAUNCHER_CONF}
