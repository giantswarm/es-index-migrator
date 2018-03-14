#!/bin/bash

# Creating aliases for indizes based on a name pattern,
# like it's common in ELK/EFK setups

# Fail when using unset variables
set -u

# Exit in case of error
set -e

# Number of days to expect indices for
num_days=16

# Date format used in our index pattern
format="+%Y.%m.%d"

oldprefix="fluentd"

newprefix="logs"

# Check env variable
if [ "${ELASTICSEARCH_ENDPOINT}" == "" ]; then
  echo "ERROR: Environment variable ELASTICSEARCH_ENDPOINT is not set. Exiting."
  exit 1
fi

# Returns "200" if the index or alias exists, "404" otherwise
function check_index_or_alias_exists {
  INDEX=$1
  RESPONSE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${ELASTICSEARCH_ENDPOINT}/${INDEX})
  echo $RESPONSE_STATUS
}

# Wait for Elasticsearch to become available
OKAY="unset"
curl -s --head "${ELASTICSEARCH_ENDPOINT}"|grep -q "HTTP/1.1 200"
OKAY=$?
while [ "$OKAY" != "0" ]; do
  echo "Waiting for Elasticsearch to become available"
  sleep 10
  curl -s --head "${ELASTICSEARCH_ENDPOINT}"|grep -q "HTTP/1.1 200"
  OKAY=$?
done

COUNTER=0
while [  $COUNTER -lt $num_days ]; do
  mydate=$(date ${format} -d "NOW - ${COUNTER} days") || { echo 'date command failed' ; exit 1; }

  INDEX="${oldprefix}-${mydate}"
  ALIAS="${newprefix}-${mydate}"

  INDEX_EXISTS=$(check_index_or_alias_exists $INDEX)
  ALIAS_EXISTS=$(check_index_or_alias_exists $ALIAS)

  if [[ $INDEX_EXISTS == "200" && $ALIAS_EXISTS == "404" ]]; then
    # Create alias
    echo "Setting alias ${INDEX} pointing to index ${ALIAS}"
    RESPONSE=$(curl -s -XPUT "${ELASTICSEARCH_ENDPOINT}/${INDEX}/_alias/{${ALIAS}}") || { echo "Creating alias failed"}
  else
    echo "Skipping alias ${ALIAS}. Either it already exists, or index ${INDEX} does not exist."
  fi

  let COUNTER=COUNTER+1
done
