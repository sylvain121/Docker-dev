# Minimal xfce desktop in a container 
# To build:
# 1) Install docker (http://docker.io)
# 2) Run:
# docker RUN -d <imageid>
#
# VERSION                0.3
# DOCKER-VERSION        1.3.2

FROM       ubuntu:xenial
MAINTAINER SYLVAIN121
ENV 	DEBIAN_FRONTEND=noninteractive
RUN 	   echo Europe/Paris | tee /etc/timezone
RUN        apt-get update && apt-get -y install software-properties-common tzdata 
RUN        DEBIAN_FRONTEND=noninteractive  apt-get update && apt-get upgrade -y 
RUN 	   dpkg-reconfigure --frontend noninteractive tzdata
RUN	   apt-get -y install xubuntu-desktop openssh-server xmonad suckless-tools sudo rxvt-unicode-256color terminator locate build-essential git-core whois bash-completion libappindicator1 libpango1.0-0

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && \
    apt-get -q -y upgrade && \
    apt-get install -y sudo curl wget locales && \
    rm -rf /var/lib/apt/lists/*
RUN locale-gen fr_FR.UTF-8
COPY ./default_locale /etc/default/locale
RUN chmod 0755 /etc/default/locale
ENV LC_ALL=fr_FR.UTF-8
ENV LANG=fr_FR.UTF-8
ENV LANGUAGE=fr_FR.UTF-8

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN	   /usr/sbin/usermod root --password $(mkpasswd GmleKko)
RUN	   /usr/sbin/useradd user -G sudo --password $(mkpasswd user) --create-home -s /bin/bash
WORKDIR	   /home/user/
RUN	   mkdir /home/src/
RUN	   chown -R user:user /home/src/
RUN  	   DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y chromium-browser 
WORKDIR    /root/
RUN 	   rm /etc/xdg/autostart/blueman.desktop

run        apt-get update && apt-get -y install software-properties-common 
run        DEBIAN_FRONTEND=noninteractive  apt-get update && apt-get install -y autoconf libtool pkg-config libx11-dev libxfixes-dev libssl-dev libpam0g-dev libtool flex bison gettext autoconf libxml-parser-perl libfuse-dev xsltproc libxrandr-dev  python-libxml2 nasm xserver-xorg-dev fuse pulseaudio alsa-utils libxfont1-dev
ADD	   module-xrdp-sink.so /usr/lib/pulse-8.0/modules/

WORKDIR    /root
RUN 	   git clone https://github.com/libjpeg-turbo/libjpeg-turbo.git
WORKDIR    /root/libjpeg-turbo
RUN  	   autoreconf -fiv
RUN 	   ./configure
RUN 	   make
RUN 	   make install

WORKDIR	   /root
RUN	   git clone https://github.com/neutrinolabs/xrdp.git
WORKDIR    /root/xrdp
RUN        git submodule init
RUN        git submodule update

WORKDIR    /root/xrdp/librfxcodec
RUN        ./bootstrap
RUN        ./configure
RUN        make

WORKDIR    /root/xrdp
RUN 	   ./bootstrap
RUN 	   ./configure --enable-rfxcodec --enable-fuse --enable-tjpeg --with-pic
RUN 	   make
RUN 	   make install

RUN sudo xrdp-keygen  xrdp auto 2048

WORKDIR    /root/
RUN  git clone https://github.com/neutrinolabs/xorgxrdp.git
WORKDIR    /root/xorgxrdp/
RUN 	   ./bootstrap 
RUN 	   ./configure 
RUN 	   make
RUN 	   make install

ADD	   xrdp.sh /etc/init.d/
ADD  	   xrdp.ini /etc/xrdp/
ADD	   run.sh /root/
EXPOSE	   22
EXPOSE     3389
CMD	   /root/run.sh





