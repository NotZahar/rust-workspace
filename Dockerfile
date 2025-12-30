FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    SHELL=/bin/zsh

WORKDIR /root/workspace

COPY ./docker-scripts/ /root/docker-scripts/
RUN chmod +x /root/docker-scripts/*.sh

RUN /root/docker-scripts/1-switch-apt-mirror.sh
RUN /root/docker-scripts/2-install-deps.sh
RUN /root/docker-scripts/3-setup-zsh.sh

RUN echo "source ~/.config/envman/PATH.env" >> ~/.zshrc

CMD ["/bin/zsh"]
