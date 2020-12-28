FROM jenkins/inbound-agent

USER root

# RUN curl -sSL https://get.docker.com/ | sh
ARG DOCKERVERSION=20.10.1
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN apt-get update && apt-get install -y --no-install-recommends curl

USER jenkins
