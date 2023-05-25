FROM theasp/novnc:latest as desktop

COPY upstream/distributed-ensemble/desktop-base/x11vnc.conf /app/conf.d
COPY upstream/distributed-ensemble/desktop-base/fluxbox/init /etc/X11/fluxbox/init

RUN useradd ensemble -s /bin/bash  -m -k /etc/skel

ENV HOME /home/ensemble

WORKDIR /home/ensemble
USER ensemble

RUN git config --global user.email "ensemble@noreply.github.com" &&\
    git config --global user.name "ensemble" 

ENV DISPLAY_WIDTH=1920
ENV DISPLAY_HEIGHT=1080
ENV RUN_XTERM=yes

EXPOSE 8080
USER root
