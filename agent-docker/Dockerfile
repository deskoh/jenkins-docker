FROM jenkins/jnlp-slave

USER root

# RUN curl -sSL https://get.docker.com/ | sh
ARG DOCKERVERSION=19.03.2
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN apt-get update && apt-get install -y --no-install-recommends curl

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update && apt-get install -y --no-install-recommends \
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

RUN if [[ -n $NPM_REGISTRY ]]; then npm config set registry $NPM_REGISTRY; fi \
  && if [[ -n $SASS_BINARY_SITE ]]; then npm config set SASS_BINARY_SITE $SASS_BINARY_SITE; fi \
  && if [[ -n $ELECTRON_MIRROR ]]; then npm config set ELECTRON_MIRROR $ELECTRON_MIRROR; fi

USER jenkins
