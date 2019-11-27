FROM jenkins/jnlp-slave

USER root

# RUN curl -sSL https://get.docker.com/ | sh
ARG DOCKERVERSION=19.03.5
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN apt-get update && apt-get install -y --no-install-recommends curl

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    socat \
    python-pip \
    ksh \
    # build tools
    maven \
    nodejs \
    build-essential \
    cppcheck \
    lynx \
    clang-tidy \
    # dyanmic testing tools
    valgrind \
    expect \
 && npm install -g npm@latest \
 && rm -rf /var/lib/apt/lists/* \
    /usr/include \
    /usr/share/man \
    /tmp/* \
    /root/.npm \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc \
    /usr/lib/node_modules/npm/html \
    > /dev/null 2>&1

RUN cd /opt \
   && wget -nv http://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/3.1.12/spotbugs-3.1.12.tgz \
   && tar xzf spotbugs-3.1.12.tgz \
   && rm spotbugs-3.1.12.tgz

RUN cd /opt \
   && wget -nv https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.19.0/pmd-bin-6.19.0.zip \
   && unzip -q pmd-bin-6.19.0.zip \
   && rm pmd-bin-6.19.0.zip

RUN pip install lizard

USER jenkins
