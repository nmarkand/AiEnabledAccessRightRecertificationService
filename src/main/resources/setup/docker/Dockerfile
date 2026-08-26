FROM confluentinc/cp-server-connect:7.5.0

USER root

# Directly download and extract the Debezium PostgreSQL connector plugin
RUN mkdir -p /usr/share/java \
    && curl -sL https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.5.0.Final/debezium-connector-postgres-2.5.0.Final-plugin.tar.gz -o /tmp/debezium-postgres.tar.gz \
    && tar -xzf /tmp/debezium-postgres.tar.gz -C /usr/share/java/ \
    && rm /tmp/debezium-postgres.tar.gz

USER appuser