# docker-python-github-runners

## Introduction

The purpose of this project is to provide an array of reasonably secured github runner containers which allow testing of projects across a number of 

## Security

There have been plenty of discussions about the Github Actions security model and the ability in many cases for arbitary code execution on 

## Raspbian Containers

In order to simulate running the target python script(s) on a Raspberry Pi, a number of containers which provide the Rasbperry Pi OS (formerly Raspbian) 

### Adding ARM binary compatibility support

The following steps will provide ARM binary compatibility. Note that due to an issue with QEMU 4.20 (see [here](https://bugs.launchpad.net/qemu/+bug/1882123) it is necessary to use an earlier version of QEMU:

```
wget http://archive.ubuntu.com/ubuntu/pool/universe/q/qemu/qemu-user-static_2.11+dfsg-1ubuntu7.36_amd64.deb

dpkg -i qemu-user-static_2.11+dfsg-1ubuntu7.36_amd64.deb
```

And then install binfmt support and register the ARM 

```
apt-get install binfmt-support

update-binfmts --enable qemu-arm
update-binfmts --display qemu-arm 
```
