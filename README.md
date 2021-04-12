# docker-python-github-runners

## Introduction

The purpose of this project is to provide an array of reasonably secured github runner containers which allow testing of projects across a number of Python versions, including on Raspberry Pi OS (through binary emulation).

This doesn't try to solve problems of horizontal scalability, nor would it work in most cases outside of the key use case which is the ability to run Python scripts against a large number of Python versions, as well as Raspberry Pi platforms. This helps to ensure that the libraries and build steps are as widely tested as possible, so your distribution will "just work", out of the box.

Why this solution doesn't attempt to use platforms such as Kubernetes, Docker Swarm etc is simple - the security aspect of this approach focuses on isolation of components which requires not sharing an existing platform such as Kubernetes with trusted containers and not inadvertently providing lateral access to internal resources - read the Security section for more on this.

### Limitations

   * This approach does not work if you intend to use Container Actions within your GitHub Actions workflows. This would definitely be the wrong template to use for such a project as these workers are only intended for testing Python projects.

   * There's no functionality or thought put in to horizontal scalability for this runner template - this is beyond the scope of the project. 

   * There's no yum based container testing performed as the project this is used for doesn't have any yum distro build capability, it's mainly used for RPi based projects.

### Configuration

All configuration goes into the vars.txt file

## Security

There have been plenty of discussions about the Github Actions security model and the ability in many cases for arbitary code execution on 

This implementation takes as many steps as reasonable to solve the issue of self-hosting Github Runners:

   * It exclusively utilises Proxy communications for outbound access, using explicit allow ACLs for only the key domains and URLs required for Github Runner functionality, avoiding 

   * It practices isolation, by deploying docker containers inside an isolated host connected only to a Proxy Server and only through the Proxy Port.

## Raspbian Containers

In order to simulate running the target python script(s) on a Raspberry Pi, a number of containers which provide the Rasbperry Pi OS (formerly Raspbian) 

### Adding ARM binary compatibility support

The following steps will provide ARM binary compatibility. Note that due to an issue with QEMU 4.20 (see [here](https://bugs.launchpad.net/qemu/+bug/1882123) it is necessary to use an earlier version of QEMU:

```
wget http://archive.ubuntu.com/ubuntu/pool/universe/q/qemu/qemu-user-static_2.11+dfsg-1ubuntu7.36_amd64.deb

dpkg -i qemu-user-static_2.11+dfsg-1ubuntu7.36_amd64.deb

echo "qemu-user-static hold" | dpkg --set-selections
```

And then install binfmt support and register the ARM 

```
apt-get install binfmt-support

update-binfmts --enable qemu-arm
update-binfmts --display qemu-arm 
```
