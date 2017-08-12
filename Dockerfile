FROM debian:stretch
MAINTAINER David Personette <dperson@gmail.com>

# Install logstash (skip logstash-contrib)
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export url='https://artifacts.elastic.co/downloads/logstash' && \
    export version='5.5.1' && \
    export sha1sum='2cd1cdc1c01f7e7af3919221668e9ec2547070be' && \
    groupadd -r logstash && \
    useradd -c 'Logstash' -d /opt/logstash -g logstash -r logstash && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl \
                openjdk-8-jre procps libzmq5 \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    file="logstash-${version}.tar.gz" && \
    echo "downloading $file ..." && \
    curl -LOSs ${url}/$file && \
    sha1sum $file | grep -q "$sha1sum" || \
    { echo "expected $sha1sum, got $(sha1sum $file)"; exit 13; } && \
    tar -xf $file -C /tmp && \
    mv /tmp/logstash-* /opt/logstash && \
    ln -s /usr/lib/*/libzmq.so.5 /usr/local/lib/libzmq.so && \
    chown -Rh logstash. /opt/logstash && \
    apt-get purge -qqy curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* $file
COPY logstash.conf /opt/logstash/config/
COPY logstash.sh /usr/bin/

EXPOSE 5140 5140/udp

VOLUME ["/opt/logstash"]

ENTRYPOINT ["logstash.sh"]