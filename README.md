[![logo](http://logstash.net/images/logstash.png)](http://logstash.net/)

# Logstash

Logstash docker container

# What is Logstash?

logstash is a tool for managing events and logs. You can use it to collect logs,
parse them, and store them for later use (like, for searching). Speaking of
searching, logstash comes with a web interface for searching and drilling into
all of your logs.

# How to use this image

When started Logstash container will listen on ports 5000 and 5000/udp.

## Hosting a Logstash instance

    sudo docker run -d dperson/logstash

## Configuration

    sudo docker run -it --rm dperson/logstash -h

    Usage: logstash.sh [-opt] [command]
    Options (fields in '[]' are optional, '<>' are required):
        -h          This help
        -t ""       Configure timezone
                    possible arg: "[timezone]" - zoneinfo timezone for container

    The 'command' (if provided and valid) will be run instead of logstash

ENVIROMENT VARIABLES (only available with `docker run`)

 * `TIMEZONE` - As above, set a zoneinfo timezone, IE `EST5EDT`

## Examples

Any of the commands can be run at creation with `docker run` or later with
`docker exec logstash.sh` (as of version 1.3 of docker).

    sudo docker run -p 5000:5000 -p 5000:5000/udp -d dperson/logstash -T EST5EDT

Will get you the same settings as

    sudo docker run --name log -p 5000:5000 -p 5000:5000/udp -d dperson/logstash
    sudo docker exec log logstash.sh -T EST5EDT ls -AlF /etc/localtime
    sudo docker restart log

## Complex configuration

[Example configs](http://www.logstash.net/)

If you wish to adapt the default configuration, use something like the following
to copy it from a running container:

    sudo docker cp log:/etc/logstash /some/path

You can use the modified configuration with:

    sudo docker run --name es -p 5000:5000 -p 5000:5000/udp \
                -v /some/path:/etc/logstash:ro \
                -d dperson/logstash

# User Feedback

## Issues

If you have any problems with or questions about this image, please contact me
through a [GitHub issue](https://github.com/dperson/logstash/issues).
