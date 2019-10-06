# Jenkins Agent with Docker Build Support

This Jenkins Agent image connects to the Jenkins master. For more information, see [here](https://wiki.jenkins.io/display/JENKINS/Distributed+builds#Distributedbuilds-Agenttomasterconnections).

## Quick Start

> Note: `/home/jenkins/agent` and `/home/jenkins/.jenkins` are exposed as volumes.

Configure Jenkins master by adding a worker node to Jenkins with the following example parameters. Refer to guide [here](https://wiki.jenkins.io/display/JENKINS/Step+by+step+guide+to+set+up+master+and+agent+machines+on+Windows) for screenshots.

> Note: By default JNLP connects using port 50000 and has to be exposed.

* Name: `worker1`
* Remote root directory: `/var/jenkins`
* Labels: `docker` (optional label to denote worker supports docker builds. See [here](https://jenkins.io/doc/book/pipeline/docker/#specifying-a-docker-label).)
* Launch method: `Launch agent by connecting it to the master`

### Connect to Jenkins Master on existing Docker network

If Jenkins master container is on existing docker network e.g. `jenkins-docker_default` (Default `docker-compose` network),

```sh
# Assuming jenkins is reacheable from `jenkins-docker_default` network at http://jenkins:8080 with above example parameters.

# Linux
docker run -d --name=jenkins-agent --network jenkins-docker_default \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/data/worker:/var/jenkins \
  deskoh/jenkins-agent-docker -url http://jenkins:8080 <secret> worker1

# Windows
docker run -d --name=jenkins-agent --network jenkins-docker_default ^
  -v /var/run/docker.sock:/var/run/docker.sock ^
  -v %cd%/data/worker:/var/jenkins ^
  deskoh/jenkins-agent-docker -url http://jenkins:8080 <secret> worker1
```

### Connect to Jenkins Master accessible from host

```sh
# Assuming jenkins is reacheable from host at http://jenkins:8080 with above example parameters.

# Linux
docker run -d --name=jenkins-agent \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/data/worker:/var/jenkins \
  deskoh/jenkins-agent-docker -url http://jenkins:8080 <secret> worker1

# Windows
docker run -d --name=jenkins-agent ^
  -v /var/run/docker.sock:/var/run/docker.sock ^
  -v %cd%/data/worker:/var/jenkins ^
  deskoh/jenkins-agent-docker -url http://jenkins:8080 <secret> worker1
```

### Adding existing Jenkins Master to a Docker network

```sh
# Creates a bridge network `jenkins-net`
docker network create --driver bridge jenkins-net

# Connects Jenkins master named `jenkins` to `jenkins-net`
docker network connect jenkins-net jenkins

docker run --network jenkins-net \
  -v $(pwd)/data/worker:<remote root dir>
  deskoh/jenkins-agent-docker -url http://jenkins:8080 <secret> <worker name>
```

## Reference

* [Networking with standalone containers](https://docs.docker.com/network/network-tutorial-standalone/)
* [docker-jnlp-slave](https://github.com/jenkinsci/docker-jnlp-slave/)
