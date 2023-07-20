# How to use dockerfiles to build SLAM project

## Build Base environment
`base.dockerfile`<br>
Base environment is a docker image that contains pre-built 3rd party libraries which are required to run SLAM.

slam:base 라는 Docker 이미지를 생성

Docker 를 사용해서 thirdparty 등을 사전에 빌드<br>
코드만 컨테이너를 생성해서 빌드

To build Base environment, use the command below:

```bash
sudo docker build \
--no-cache \
--progress=tty \
--force-rm \
-f base.dockerfile \
-t slam:base .
```

## Build SLAM modules
`build.dockerfile`<br>
thirdparty를 담고있는 Docker image로부터 갱신된 코드를 빌드

To build SLAM modules, use the command below:

```bash
sudo docker build \
--no-cache \
--progress=tty \
--force-rm \
-f build.dockerfile \
-t slam:modules .
```

---

# How to use X11 forwarding for docker development
```
xhost +
```