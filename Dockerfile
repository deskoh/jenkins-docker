FROM jenkins/jenkins:lts

USER root

# RUN curl -sSL https://get.docker.com/ | sh
ARG DOCKERVERSION=19.03.2
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

# Add `jenkins` user to `root` group to communicate with host's docker.
RUN usermod -aG root jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh  < /usr/share/jenkins/ref/plugins.txt

USER jenkins
