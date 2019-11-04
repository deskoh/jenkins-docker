FROM jenkins/jnlp-slave

USER root

# RUN curl -sSL https://get.docker.com/ | sh
ARG DOCKERVERSION=19.03.2
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN apt-get update && apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update && apt-get install -y \
    git \
    maven \
    nodejs \
 && npm install -g npm@latest \
 && rm -rf /var/lib/apt/lists/* \
    /usr/include \
    /usr/share/man \
    /tmp/* \
    /root/.npm \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc \
    /usr/lib/node_modules/npm/html

USER jenkins
