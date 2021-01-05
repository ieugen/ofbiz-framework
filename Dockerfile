#
# Docker stage - build the app using gradle
#
ARG PG_JAR_VERSION=42.2.18
ARG MYSQL_JAR_VERSION=8.0.22

FROM gradle:6.5.1-jdk8 as builder

COPY . ofbiz

RUN cd ofbiz \
  && gradle clean pullAllPluginsSource build \
  && pwd

# Docker stage - copy and unpack the application
FROM adoptopenjdk:8-jre-hotspot as imgbuilder

ARG PG_JAR_VERSION
ARG MYSQL_JAR_VERSION

COPY --from=builder /home/gradle/ofbiz/build/distributions/ofbiz.tar /tmp/ofbiz.tar

RUN mkdir -p /opt/ofbiz \
	&& tar xf /tmp/ofbiz.tar --strip 1 -C /opt/ofbiz \
	&& rm /tmp/ofbiz.tar \
	&& ls -la /opt/ofbiz

RUN curl https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_JAR_VERSION}/postgresql-${PG_JAR_VERSION}.jar \
    --output /opt/ofbiz/lib/postgresql-${PG_JAR_VERSION}.jar \
    && curl https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_JAR_VERSION}/mysql-connector-java-${MYSQL_JAR_VERSION}.jar \
    --output /opt/ofbiz/lib/postgresql-${MYSQL_JAR_VERSION}.jar
#
# Docker final stage - copy the unpacked application
#
FROM adoptopenjdk:8-jre-hotspot

WORKDIR /opt/ofbiz
COPY --from=imgbuilder /opt/ofbiz .

CMD ["/opt/ofbiz/bin/ofbiz"]


