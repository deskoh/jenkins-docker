FROM ubuntu:19.10

ARG VERSION=3.35
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}
LABEL Description="This is a base image, which provides the Jenkins agent executable (agent.jar)" Vendor="Jenkins project" Version="${VERSION}"

ARG AGENT_WORKDIR=/home/${user}/agent

# Install utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
     ca-certificates curl netbase wget unzip > /dev/null 2>&1 \
  && rm -rf /var/lib/apt/lists/*

# Install source control utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
     bzr git git-lfs openssh-client subversion > /dev/null 2>&1 \
  && rm -rf /var/lib/apt/lists/*

# Install jdk and java build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
     openjdk-8-jdk maven gradle > /dev/null 2>&1 \
  && rm -rf /var/lib/apt/lists/*

RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

# RUN curl -sSL https://get.docker.com/ | sh
# Install docker CLI only
ARG DOCKERVERSION=20.10.1
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

ENV DEBIAN_FRONTEND=noninteractive

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install -y --no-install-recommends nodejs  > /dev/null 2>&1 \
  && npm install -g npm@latest \
  && rm -rf /var/lib/apt/lists/* \
    /root/.npm \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/docs

# Install static anaylsis tools
RUN cd /opt \
   && wget -nv https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/4.1.4/spotbugs-4.1.4.tgz \
   && tar xzf spotbugs-4.1.4.tgz \
   && rm spotbugs-4.1.4.tgz \
   && wget -nv https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.30.0/pmd-bin-6.30.0.zip \
   && unzip -q pmd-bin-6.30.0.zip \
   && rm pmd-bin-6.30.0.zip \
   && rm -rf /var/lib/apt/lists/*

# Additional build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    socat \
    python-pip \
    ksh \
    # build tools
    build-essential \
    g++ \
    cppcheck \
    lynx \
    clang-format clang-tidy clang-tools clang clangd \
    libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 \
    liblldb-dev libllvm-ocaml-dev libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm python-clang \
    # dyanmic testing tools
    valgrind \
    expect \
 > /dev/null 2>&1 \
 && pip install lizard \
 && rm -rf /var/lib/apt/lists/* \
    /usr/share/man \
    /tmp/*

# End install

# # Configure tzdata
# RUN ln -fs /usr/share/zoneinfo/Asia/Singapore /etc/localtime \
#     && dpkg-reconfigure --frontend noninteractive tzdata

COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

ENTRYPOINT ["jenkins-agent"]
