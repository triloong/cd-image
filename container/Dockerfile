FROM debian:trixie

RUN apt-get update && apt-get install -y --no-install-recommends debian-cd mtools dosfstools procmail

RUN --mount=type=bind,target=/media ( cd /usr/share/debian-cd && patch -p1) < /media/apt-selection.patch

USER 1000:1000
