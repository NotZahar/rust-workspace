FROM ubuntu:25.10

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    SHELL=/bin/zsh

WORKDIR /root/workspace

COPY ./container-scripts/1-switch-apt-mirror.sh /root/container-scripts/
RUN chmod +x /root/container-scripts/1-switch-apt-mirror.sh && \
    /root/container-scripts/1-switch-apt-mirror.sh

COPY ./container-scripts/2-install-deps.sh /root/container-scripts/
RUN chmod +x /root/container-scripts/2-install-deps.sh && \
    /root/container-scripts/2-install-deps.sh

COPY ./container-scripts/3-setup-zsh.sh /root/container-scripts/
RUN chmod +x /root/container-scripts/3-setup-zsh.sh && \
    /root/container-scripts/3-setup-zsh.sh

CMD ["/bin/zsh"]
