FROM openjdk:8u111-jre-alpine

MAINTAINER rastydnb

RUN apk -U add bash

ENV ES_VERSION=5.2.2

ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION.tar.gz /tmp/es.tgz
RUN cd /usr/share && \
  tar xf /tmp/es.tgz && \
  rm /tmp/es.tgz

EXPOSE 9200 9300

HEALTHCHECK --timeout=5s CMD wget -q -O - http://$HOSTNAME:9200/_cat/health

ENV ES_HOME=/usr/share/elasticsearch-$ES_VERSION \
    DEFAULT_ES_USER=elasticsearch \
    ES_JAVA_OPTS="-Xms1g -Xmx1g"

RUN adduser -S -s /bin/sh $DEFAULT_ES_USER

VOLUME ["/data","/conf"]

WORKDIR $ES_HOME

COPY java.policy /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/
COPY start /start
COPY log4j2.properties $ES_HOME/config/
RUN  bin/elasticsearch-plugin install x-pack

CMD ["/start"]