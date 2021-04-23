FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VERSION="3.4.10"
ENV PYTHON_VERSION=${PYTHON_VERSION}
ARG RUNNER_VERSION="2.278.0"
ARG http_proxy="http://1.2.3.4"
ENV http_proxy=${http_proxy}
ARG https_proxy="http://1.2.3.4"
ENV https_proxy=${https_proxy}

RUN apt-get update -y && apt-get upgrade -y 

# Create a docker user, add them to sudoers
RUN useradd -m docker
RUN useradd -U -m pi

# Install build prerequisites for Python
RUN apt-get install -y build-essential curl git jq libbz2-dev libffi-dev libncurses5-dev libreadline-dev libsqlite3-dev llvm lsb-release make sudo wget xz-utils zlib1g-dev

# Add docker user to sudoers
RUN adduser docker sudo

# Allow keeping the proxy environment variables
RUN echo 'Defaults  env_keep += "http_proxy"' >> /etc/sudoers
RUN echo 'Defaults  env_keep += "https_proxy"' >> /etc/sudoers
RUN echo 'Defaults  env_keep += "HTTP_PROXY"' >> /etc/sudoers
RUN echo 'Defaults  env_keep += "HTTPS_PROXY"' >> /etc/sudoers

# Limit sudo commands to a handful of commands needed for build
RUN echo '%sudo ALL=(ALL) NOPASSWD: /usr/bin/apt-get' >> /etc/sudoers
RUN echo '%sudo ALL=(ALL) NOPASSWD: /bin/chmod' >> /etc/sudoers
RUN echo '%sudo ALL=(ALL) NOPASSWD: /bin/chown' >> /etc/sudoers
RUN echo '%sudo ALL=(ALL) NOPASSWD: /bin/cp' >> /etc/sudoers
RUN echo '%sudo ALL=(ALL) NOPASSWD: /bin/mkdir' >> /etc/sudoers
RUN echo '%sudo ALL=(ALL) NOPASSWD: /home/docker/.pyenv/shims/python3' >> /etc/sudoers
RUN echo '%sudo ALL=(ALL) NOPASSWD: /usr/sbin/lighty-enable-mod' >> /etc/sudoers
RUN echo '%sudo ALL=(ALL) NOPASSWD: /usr/sbin/service' >> /etc/sudoers
RUN echo '%sudo ALL=(ALL) NOPASSWD: /usr/sbin/usermod' >> /etc/sudoers

# Install older libssl version (for Python 3.4/3.5)
RUN wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.6_amd64.deb -O /tmp/libssl.deb
RUN wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0-dev_1.0.2n-1ubuntu5.6_amd64.deb -O /tmp/libssl-dev.deb
RUN dpkg -i /tmp/libssl.deb /tmp/libssl-dev.deb
RUN rm /tmp/libssl.deb /tmp/libssl-dev.deb

# Clean up package cache
RUN apt-get -y clean
RUN apt-get -y autoremove

# Change home directory to docker user
WORKDIR /home/docker
USER docker

# Download and unzip the github actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Install some additional dependencies (as root)
USER root
RUN /home/docker/actions-runner/bin/installdependencies.sh
RUN echo Acquire::http::proxy \"${http_proxy}\"\; >> /etc/apt/apt.conf.d/00proxy
RUN echo Acquire::https::proxy \"${https_proxy}\"\; >> /etc/apt/apt.conf.d/00proxy
USER docker

# Install Python version manager
RUN git clone https://github.com/pyenv/pyenv.git /home/docker/.pyenv

ENV HOME /home/docker
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Install specified python version
RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION
RUN pyenv rehash

ADD info.py /home/docker/info.py
ADD start.sh /home/docker/start.sh

# Start script
ENTRYPOINT ["/home/docker/start.sh"]
