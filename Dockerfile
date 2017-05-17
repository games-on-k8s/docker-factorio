FROM ubuntu:16.04
MAINTAINER Greg Taylor <gtaylor@gc-taylor.com>

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y python3 && apt-get clean

WORKDIR /opt

ARG factorio_version
ENV VERSION $factorio_version

COPY entrypoint.sh gen_config.py factorio.crt /opt/
COPY factorio_headless_x64_$VERSION.tar.gz /tmp/factorio_headless.tar.gz

VOLUME /opt/factorio/saves /opt/factorio/mods

RUN tar xzf /tmp/factorio_headless.tar.gz && \
    rm /tmp/factorio_headless.tar.gz

EXPOSE 34197/udp
EXPOSE 27015/tcp

CMD ["./entrypoint.sh"]
