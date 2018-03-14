FROM debian:jessie

RUN apt-get update -q \
 && apt-get install -y --no-install-recommends -q curl \
 && rm -rf /var/lib/apt/lists/*

ADD migrate.sh /migrate.sh

ENTRYPOINT ["/migrate.sh"]
