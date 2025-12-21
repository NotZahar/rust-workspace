#!/bin/bash

set -eu

APT_PACKAGES=(
	"locales"
	"build-essential"
	"gnupg"
	"gnupg2"
	"zsh"
	"vim"
	"cmake"
	"git"
	"curl"
	"lsb-release"
	"software-properties-common"
	"pkg-config"
	"libssl-dev"
	"libacl1-dev"
	"libncurses5-dev"
	"htop"
	"linux-tools-generic"
	"libclang-dev"
	"wget"
	"python3-venv"
)

apt update
for APT_PACKAGE in "${APT_PACKAGES[@]}"; do
	echo "Installing: $APT_PACKAGE"
	apt install -y "$APT_PACKAGE"
done

# Shfmt
curl -sS https://webinstall.dev/shfmt | bash

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
	RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup \
		RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup \
		sh -s -- -y
source "$HOME/.cargo/env"

# Cleanup
rm -rf /var/lib/apt/lists/*
