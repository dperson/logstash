FROM debian:jessie
MAINTAINER David Personette <dperson@dperson.com>

# Install logstash (skip logstash-contrib)
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-key adv --keyserver pgp.mit.edu --recv-keys D27D666CD88E42B4 && \
    echo -n "deb http://packages.elasticsearch.org/logstash/1.4/debian " >> \
                /etc/apt/sources.list && \
    echo -n "stable main" >> /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends logstash \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*
COPY logstash.conf /etc/logstash/
COPY logstash.sh /usr/bin/

EXPOSE 5000 5000/udp

ENTRYPOINT ["logstash.sh"]
