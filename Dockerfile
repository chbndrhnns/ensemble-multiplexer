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

FROM desktop as java 

RUN apt-get -qq update && \
    apt-get -qq install openjdk-17-jdk maven ant && \
    apt-get install -y apt-transport-https dirmngr gnupg ca-certificates curl rsync vim emacs libgbm-dev unzip && \
    rm -rf /var/lib/apt/lists/*

ENV GRADLE_VERSION=7.6
RUN curl --location https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip --output gradle.zip
RUN unzip -d /opt/gradle gradle.zip && rm gradle.zip

COPY upstream/distributed-ensemble/java-intellij/idea.conf /app/conf.d
COPY --chown=ensemble:ensemble upstream/distributed-ensemble/java-intellij/fluxbox/menu .fluxbox/menu

USER ensemble

ENV INTELLIJ_BUILD=2022.3
ENV INTELLIJ_BUILD_NR=223.7571.182
RUN curl --location https://download.jetbrains.com/idea/ideaIC-${INTELLIJ_BUILD}.tar.gz --output idea.tar.gz
RUN tar -xvf idea.tar.gz  && mv ./idea-IC-${INTELLIJ_BUILD_NR} ./idea && rm idea.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH=${PATH}:${JAVA_HOME}/bin:/opt/gradle/gradle-${GRADLE_VERSION}/bin
