FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

WORKDIR /root/workspace

COPY ./docker-scripts/ /root/docker-scripts/
RUN chmod +x /root/docker-scripts/*.sh

RUN /root/docker-scripts/1-switch-apt-mirror.sh
RUN /root/docker-scripts/2-install-apt-deps.sh
RUN /root/docker-scripts/3-setup-locale.sh
RUN /root/docker-scripts/4-setup-zsh.sh

ENV SHELL=/bin/zsh
CMD ["/bin/zsh"]
