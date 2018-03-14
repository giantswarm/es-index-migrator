# es-index-migrator

Little tool to create aliases as a migration step from one index name scheme
to another.

## Use case

We are changing index names in our Elasticsearch/Fluend-or-bit/Kibana setup
from `fluentd-*` to `logs-*`.

## Configuration

Required environment variables:

- `ELASTICSEARCH_ENDPOINT`: e. g. `http://elasticsearch:9200`
