FROM alpine
MAINTAINER David Personette <dperson@gmail.com>

# Install logstash (skip logstash-contrib)
RUN export url='https://artifacts.elastic.co/downloads/logstash' && \
    export version='7.3.1' && \
    export shasum='b44a8557b7bcd5221823abad81facb184c531b1c4eb127b96e872e1' && \
    apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl libzmq openjdk11-jre-headless \
                shadow tini tzdata && \
    addgroup -S logstash && \
    adduser -S -D -H -h /opt/logstash -s /sbin/nologin -G logstash \
                -g 'Logstash User' logstash && \
    file="logstash-${version}.tar.gz" && \
    echo "downloading $file ..." && \
    curl -LOSs ${url}/$file && \
    sha512sum $file | grep -q "$shasum" || \
    { echo "expected $shasum, got $(sha512sum $file)"; exit 13; } && \
    tar -xf $file -C /tmp && \
    mv /tmp/logstash-* /opt/logstash && \
    ln -s /usr/lib/*/libzmq.so.5 /usr/local/lib/libzmq.so && \
    chown -Rh logstash. /opt/logstash && \
    rm -rf /tmp/* $file
COPY logstash.conf /opt/logstash/config/
COPY logstash.sh /usr/bin/

EXPOSE 5140 5140/udp

#HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
#             CMD curl -Lk 'https://localhost/index.html'

VOLUME ["/opt/logstash"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/logstash.sh"]