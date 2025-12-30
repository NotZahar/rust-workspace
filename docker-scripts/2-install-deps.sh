#!/bin/bash

set -eu

apt update
apt install -y locales
echo "en_US.UTF-8 UTF-8" >/etc/locale.gen
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

apt update
apt install -y \
	build-essential \
	gnupg2 \
	zsh \
	vim \
	cmake \
	git \
	curl \
	lsb-release \
	pkg-config \
	libssl-dev \
	libacl1-dev \
	libncurses5-dev \
	htop \
	libclang-dev \
	wget \
	python3-venv

# Shfmt
SHFMT_VERSION="v3.8.0"
wget -q "https://github.com/mvdan/sh/releases/download/${SHFMT_VERSION}/shfmt_${SHFMT_VERSION}_linux_amd64" -O /usr/local/bin/shfmt
chmod +x /usr/local/bin/shfmt

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
	RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup \
		RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup \
		sh -s -- -y
source "$HOME/.cargo/env"

# Cleanup
rm -rf /var/lib/apt/lists/*
