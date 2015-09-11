FROM debian:jessie
MAINTAINER David Personette <dperson@dperson.com>

# Install logstash (skip logstash-contrib)
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export URL='http://download.elastic.co/logstash/logstash' && \
    export version='1.5.4' && \
    export sha1sum='c892b71a3902bfdb54827385ed2c26a14ad816dd' && \
    groupadd -r logstash && useradd -r -g logstash logstash && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl \
                openjdk-7-jre \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    curl -LOC- -s $URL/logstash-${version}.tar.gz && \
    sha1sum logstash-${version}.tar.gz | grep -q "$sha1sum" && \
    tar -xf logstash-${version}.tar.gz -C /tmp && \
    mv /tmp/logstash-* /opt/logstash && \
    mkdir /etc/logstash && \
    chown -Rh logstash. /etc/logstash /opt/logstash && \
    apt-get purge -qqy curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*
COPY logstash.conf /etc/logstash/
COPY logstash.sh /usr/bin/

EXPOSE 5140 5140/udp

VOLUME ["/run", "/tmp", "/var/cache", "/var/lib", "/var/log", "/var/tmp", \
            "/etc/logstash", "/opt/logstash"]

ENTRYPOINT ["logstash.sh"]
