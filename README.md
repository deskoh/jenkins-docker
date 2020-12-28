# Jenkins with Docker Build support

[![Get your own image badge on microbadger.com](https://images.microbadger.com/badges/image/deskoh/jenkins-docker.svg)](https://microbadger.com/images/deskoh/jenkins-docker)

Jenkins container supporting docker build using host's docker daemon (Docker-in-Docker).

## Usage

```sh
# Linux
docker run --name jenkins -p 8080:8080 -p 50000:50000 --restart=always \
  --group-add `stat -c %g /var/run/docker.sock` \
  -v $(pwd)/jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  deskoh/jenkins-docker

# Windows
docker run --name jenkins -p 8080:8080 -p 50000:50000 --restart=always ^
  --group-add 0 ^
  -v %cd%/jenkins_home:/var/jenkins_home ^
  -v /var/run/docker.sock:/var/run/docker.sock ^
  deskoh/jenkins-docker

# Stop / Start / Restart
docker stop jenkins
docker start jenkins
docker restart jenkins
```

> Jenkins default password will be in console output (`stdout`). Alternatively run
>
> ```sh
> docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`
> ```

See [official documentation](https://github.com/jenkinsci/docker/blob/master/README.md) for notes on using `bind mount` for Jenkins home directory.

## Image Variants

The image variants differs by the plugins included.

### `latest`

The following opiniated set of plugins is included:

* Jenkins recommended plugins referenced [here](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/resources/jenkins/install/platform-plugins.json).
* [Blue Ocean](https://plugins.jenkins.io/blueocean)
* [Cobertura](https://plugins.jenkins.io/cobertura)
* [Cpptest](https://plugins.jenkins.io/cpptest/)
* [Docker](https://plugins.jenkins.io/docker-plugin)
* [File System SCM](https://plugins.jenkins.io/filesystem_scm)
* [Fortify](https://plugins.jenkins.io/fortify)
* [Git Parameter](https://plugins.jenkins.io/git-parameter)
* [GitLab](https://plugins.jenkins.io/gitlab-plugin)
* [HTTP Request](https://plugins.jenkins.io/http_request/)
* [JUnit](https://plugins.jenkins.io/junit)
* [Kubernetes CLI](https://plugins.jenkins.io/kubernetes-cli)
* [Kubernetes Credentials](https://plugins.jenkins.io/kubernetes-credentials)
* [Pipeline: Multibranch](https://plugins.jenkins.io/workflow-multibranch)
* [Prometheus metrics](https://plugins.jenkins.io/prometheus)
* [RocketChat Notifier](https://plugins.jenkins.io/rocketchatnotifier/)
* [Templating Engine](https://plugins.jenkins.io/templating-engine/)
* [Warnings Next Generation](https://github.com/jenkinsci/warnings-ng-plugin)
* [xUnit](https://plugins.jenkins.io/xUnit)

### `plugins`

Only Jenkins recommended plugins referenced [here](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/resources/jenkins/install/platform-plugins.json) are included.

### `base`

No plugins are included.

## Viewing Logs

```sh
# Tail logs
docker logs -f --tail 0 jenkins
```

## How it Works

The container is running Docker-in-Docker (DIND).

The Docker daemon listens on the `/var/run/docker.sock` Unix socket by default and is volume mounted to the Jenkins container. This allows the host Docker to run any Docker commands within the Jenkins container.

The `jenkins` user (`uid 1000`) needs belong to the same group (usually `root`) as `/var/run/docker.sock` on the host container to communicate with the host Docker daemon. See [here](https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf) for more information on `uid` and `gid`. To see the group permission for `/var/run/docker.dock`:

```sh
# Linux: See group permission for `/var/run/docker.dock`
$ stat -c %g /var/run/docker.sock
982

# Windows: See group permission for `/var/run/docker.dock` (on Moby Linux VM)
> docker run -it --rm -v /var/run:/var/run busybox stat -c %g /var/run/docker.sock
0
```

One way to achieve this is to add `RUN usermod -aG root jenkins` to the `Dockerfile`. The recommended way is to add `jenkins` uesr to the necessary group during runtime using `--group-add` parameter.

See this [blog post](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/) for more details on DIND.

## Adding Build Agent Nodes

See [agent-docker](https://github.com/deskoh/jenkins-docker/tree/master/agent-docker) for more details on adding build agents.

```sh
# Assuming Jenkins master is on default `jenkins-docker_default` network
docker run --network jenkins-docker_default \
  -v $(pwd)/data/worker:<remote root dir>
  deskoh/jenkins-agent-docker -url http://jenkins:8080 <secret> <worker name>
```

## Grafana / Prometheus Monitoring

Using [docker-compose.yml](https://raw.githubusercontent.com/deskoh/jenkins-docker/master/docker-compose.yml).

```sh
# Default grafana user/password: admin/admin

# Linux only
docker-compose up -d

# Stop running containers
docker-compose stop

# Remove running containers
docker-compose rm
```

* Grafana: [http://localhost:3000](http://localhost:3000) (Default user: `admin` / password: `admin`)
  * Jenkins Grafana Dashboard: [https://grafana.com/grafana/dashboards/9524](https://grafana.com/grafana/dashboards/9524)
* Prometheus: [http://localhost:9090](http://localhost:9090)

## Jenkins JVM Tuning

```sh
# Get PID of Jenkins
> docker exec jenkins-docker_jenkins_1 jcmd
7 /usr/share/jenkins/jenkins.war

# Dump Jenkins JVM properties
> docker exec jenkins-docker_jenkins_1 jcmd 7 VM.system_properties
> docker exec jenkins-docker_jenkins_1 jcmd 7 VM.flags
```

## Project-based Matrix Authorization Strategy

Authenticated Users to be granted _Overall-Read_ permissions to be able to login and view projects.

## References

* [Official Jenkins Docker image documentation](https://github.com/jenkinsci/docker/blob/master/README.md)

* [Jenkins Pipeline Syntax](https://jenkins.io/doc/book/pipeline/syntax)
