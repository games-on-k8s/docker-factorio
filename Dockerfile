FROM ubuntu:16.04
MAINTAINER Greg Taylor <gtaylor@gc-taylor.com>

ARG factorio_version
ENV VERSION $factorio_version

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install python3 xz-utils -y && apt-get clean

WORKDIR /opt

COPY entrypoint.sh gen_config.py factorio.crt /opt/
ADD factorio_headless_x64_$VERSION.tar.xz /tmp/

VOLUME /opt/factorio/saves /opt/factorio/mods

EXPOSE 34197/udp
EXPOSE 27015/tcp

CMD ["./entrypoint.sh"]
