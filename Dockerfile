FROM debian:jessie
MAINTAINER CodeGlitch0

ENV TOR_NICKNAME=Tor4 \
    TERM=xterm \
    DEST=127.0.0.1:8080

RUN groupadd -r debian-tor && useradd -r -d /var/lib/tor -m -s /bin/false -g debian-tor debian-tor

COPY ./config/tor-apt-sources.list /etc/apt/sources.list.d/

RUN gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 && \
    gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add - && \
    apt-get update && \
    apt-get install -y pwgen && \
    apt-get install -y tor deb.torproject.org-keyring && \
    apt-get clean && rm -r /var/lib/apt/lists/*

RUN mkdir -p /data/tor && \
    chown -R debian-tor:debian-tor /data/tor && \
    chmod 700 /data/tor

COPY ./config/torrc /etc/tor/torrc

COPY ./scripts/ /usr/local/bin/

VOLUME /data/tor

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]

CMD ["tor", "-f", "/etc/tor/torrc"]
