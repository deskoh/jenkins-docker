jjFROM ubuntu:19.10

ARG VERSION=3.35
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}
LABEL Description="This is a base image, which provides the Jenkins agent executable (agent.jar)" Vendor="Jenkins project" Version="${VERSION}"

ARG AGENT_WORKDIR=/home/${user}/agent

RUN apt-get update && apt-get install -y \
  git-lfs curl wget > /dev/null 2>&1
RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

# Install docker CLI only
# RUN curl -sSL https://get.docker.com/ | sh
ARG DOCKERVERSION=19.03.5
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Asia/Singapore /etc/localtime

# Additional build and dev tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    socat \
    python-pip \    
    ksh \
    # build tools
    build-essential \
    maven nodejs \
    cppcheck \
    lynx \
    clang-format clang-tidy clang-tools clang clangd \
    libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 \
    liblldb-dev libllvm-ocaml-dev libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm python-clang \
    # dyanmic testing tools
    valgrind \
    expect \
 > /dev/null 2>&1 \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && npm install -g npm@latest \
 && rm -rf /var/lib/apt/lists/* \
    /usr/share/man \
    /tmp/* \
    /root/.npm \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/docs
    # /usr/lib/node_modules/npm/html

RUN cd /opt \
   && wget -nv http://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/3.1.12/spotbugs-3.1.12.tgz \
   && tar xzf spotbugs-3.1.12.tgz \
   && rm spotbugs-3.1.12.tgz

RUN cd /opt \
   && wget -nv https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.19.0/pmd-bin-6.19.0.zip \
   && unzip -q pmd-bin-6.19.0.zip \
   && rm pmd-bin-6.19.0.zip

RUN pip install lizard

# End install

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}
