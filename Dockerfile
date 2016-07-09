FROM debian:jessie
MAINTAINER David Personette <dperson@gmail.com>

# Install logstash (skip logstash-contrib)
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export url='http://download.elastic.co/logstash/logstash' && \
    export version='2.3.4' && \
    export sha1sum='5fc3fc36752018c66a476068f2c1cc61e96b09cb' && \
    groupadd -r logstash && \
    useradd -c 'Logstash' -d /opt/logstash -g logstash -r logstash && \
    echo "deb http://httpredir.debian.org/debian jessie-backports main" \
                >>/etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl \
                openjdk-8-jre \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    echo "downloading logstash-${version}.tar.gz ..." && \
    curl -LOC- -s ${url}/logstash-${version}.tar.gz && \
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