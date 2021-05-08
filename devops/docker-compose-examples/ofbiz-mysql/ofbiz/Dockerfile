FROM ofbiz:latest

ARG MYSQL_JAR_VERSION=8.0.22

# Install database drivers
RUN mkdir -p /opt/ofbiz/lib-extra && \
    mkdir -p /opt/ofbiz/config && \
    curl https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_JAR_VERSION}/mysql-connector-java-${MYSQL_JAR_VERSION}.jar \
    --output /opt/ofbiz/lib-extra/postgresql-${MYSQL_JAR_VERSION}.jar