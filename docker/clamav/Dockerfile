FROM debian:buster-slim

# Debian Base to use.
ENV DEBIAN_VERSION buster

# initial install of av daemon.
RUN echo "deb http://http.debian.net/debian/ $DEBIAN_VERSION main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://http.debian.net/debian/ $DEBIAN_VERSION-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ $DEBIAN_VERSION/updates main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -qq \
        clamav-daemon \
        clamav-freshclam \
        libclamunrar9 \
        ca-certificates \
        netcat-openbsd \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    \
    mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav && \
    \
# av configuration update.
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf && \
    \
# initial update of av databases.
    freshclam

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh

# port provision.
EXPOSE 3310

RUN chown clamav:clamav /usr/local/bin/entrypoint.sh /etc/clamav /etc/clamav/clamd.conf /etc/clamav/freshclam.conf

USER clamav

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
