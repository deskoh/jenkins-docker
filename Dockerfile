FROM jenkins/jenkins:lts

USER root

RUN curl -sSL https://get.docker.com/ | sh

# Add `jenkins` user to `root` group to communicate with host's docker.
RUN usermod -aG root jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh  < /usr/share/jenkins/ref/plugins.txt

USER jenkins
