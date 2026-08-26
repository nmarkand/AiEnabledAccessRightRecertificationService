curl -X POST http://localhost:8083/connectors \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "iam-postgres-connector",
    "config": {
      "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
      "tasks.max": "1",
      "database.hostname": "postgres",
      "database.port": "5432",
      "database.user": "postgres",
      "database.password": "password123",
      "database.dbname": "vectordb",
      "database.sslmode": "disable",
      "topic.prefix": "iam_cdc",
      "plugin.name": "pgoutput",
      "table.include.list": "iam_data.employees",
      "key.converter": "io.confluent.connect.avro.AvroConverter",
      "value.converter": "io.confluent.connect.avro.AvroConverter",
      "key.converter.schema.registry.url": "http://schema-registry:8081",
      "value.converter.schema.registry.url": "http://schema-registry:8081",
      "transforms": "renameSchema",
      "transforms.renameSchema.type": "org.apache.kafka.connect.transforms.SetSchemaMetadata$Value",
      "transforms.renameSchema.schema.name": "com.ai.poc.kafka.dto.EmployeeCdcEvent"
    }
  }'