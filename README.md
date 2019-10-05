# Jenkins with Docker Build support

Jenkins container supporting docker build using host.

## Usage

```sh
# Linux
docker run --name jenkins --restart=always -d -v $(pwd)/jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock --name jenkins  deskoh/jenkins-docker

# Windows
docker run --name jenkins --restart=always -d -v %cd%/jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock --name jenkins  deskoh/jenkins-docker

# Stop / Start / Restart
docker stop jenkins
docker start jenkins
docker restart jenkins
```

See [official documentation](https://github.com/jenkinsci/docker/blob/master/README.md) for notes on using `bind mount` for Jenkins home directory.

## Included Plugins

The following opiniated set of recommended plugins is included:

* [Blue Ocean](https://plugins.jenkins.io/blueocean)
* [Cobertura](https://plugins.jenkins.io/cobertura)
* [JUnit](https://plugins.jenkins.io/junit)
* [Prometheus metrics](https://plugins.jenkins.io/prometheus)
* [Warnings Next Generation](https://github.com/jenkinsci/warnings-ng-plugin)
* Default Jenkins recommended plugins referenced [here](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/resources/jenkins/install/platform-plugins.json).

## Viewing Logs

```sh
# Tail logs
docker logs -f --tail 0 jenkins
```

## How it Works

The Docker daemon listens on the `/var/run/docker.sock` Unix socket by default and is volume mounted to the Jenkins container. This allows the host Docker to run any Docker commands within the Jenkins container.

The `jenkins` user (`uid 1000`) needs belong to the same group (usually `root`)as `/var/run/docker.sock` on the host container to communicate with the host Docker daemon. See [here](https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf) for more information.

```bash
# To see the owner name and group of `/var/run/docker.sock` on host
$ docker exec jenkins ls -l /var/run/docker.sock
srw-rw---- 1 root root 0 Sep 27 00:26 /var/run/docker.sock

# To verify Jenkins user belongs to the same group
$ docker exec jenkins id
uid=1000(jenkins) gid=1000(jenkins) groups=1000(jenkins),0(root)

```

## Project-based Matrix Authorization Strategy

Authenticated Users to be granted _Overall-Read_ permissions to be able to login and view projects.

## More Information
[Official Jenkins Docker image documentation](https://github.com/jenkinsci/docker/blob/master/README.md)
