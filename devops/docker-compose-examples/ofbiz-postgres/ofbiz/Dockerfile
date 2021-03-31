FROM ofbiz:latest

ARG PG_JAR_VERSION=42.2.18

# Install database drivers
RUN mkdir -p /opt/ofbiz/lib-extra && \
    mkdir -p /opt/ofbiz/config && \
    curl https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_JAR_VERSION}/postgresql-${PG_JAR_VERSION}.jar \
    --output /opt/ofbiz/lib-extra/postgresql-${PG_JAR_VERSION}.jar