FROM debian:stretch
MAINTAINER David Personette <dperson@gmail.com>

# Install logstash (skip logstash-contrib)
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export url='https://artifacts.elastic.co/downloads/logstash' && \
    export version='5.3.1' && \
    export sha1sum='86cd570471c55e26d24cf434a50ac5aeaf554fb8' && \
    groupadd -r logstash && \
    useradd -c 'Logstash' -d /opt/logstash -g logstash -r logstash && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl \
                openjdk-8-jre procps \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    echo "downloading logstash-${version}.tar.gz ..." && \
    curl -LOSs ${url}/logstash-${version}.tar.gz && \
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

VOLUME ["/etc/logstash", "/opt/logstash"]

ENTRYPOINT ["logstash.sh"]