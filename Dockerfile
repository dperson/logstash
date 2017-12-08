FROM debian:stretch
MAINTAINER David Personette <dperson@gmail.com>

# Install logstash (skip logstash-contrib)
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export url='https://artifacts.elastic.co/downloads/logstash' && \
    export version='6.0.1' && \
    export shasum='9077e9b00c3f9694c302ef051070579b0d092bca50a36d8b6b2473f' && \
    groupadd -r logstash && \
    useradd -c 'Logstash' -d /opt/logstash -g logstash -r logstash && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl \
                openjdk-8-jre procps libzmq5 \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    file="logstash-${version}.tar.gz" && \
    echo "downloading $file ..." && \
    curl -LOSs ${url}/$file && \
    sha512sum $file | grep -q "$shasum" || \
    { echo "expected $shasum, got $(sha512sum $file)"; exit 13; } && \
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