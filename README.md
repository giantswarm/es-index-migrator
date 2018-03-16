# es-index-migrator

Little tool to create aliases as a migration step from one index name scheme
to another.

## Use case

We are changing index names in our Elasticsearch/Fluend-or-bit/Kibana setup
from `fluentd-*` to `logs-*`.

## Configuration

Optional environment variables:

- `ELASTICSEARCH_ENDPOINT`: Elasticsearch base URL, default `http://elasticsearch:9200`
- `MIGRATOR_OLD_PREFIX`: Old prefix name to use, default: `fluentd-`
- `MIGRATOR_NEW_PREFIX`: New prefix name to use, default: `gslogs-`
