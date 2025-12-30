#!/bin/bash

set -eu

RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh) || true

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [[ -d ~/.oh-my-zsh ]]; then
	if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
		git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
			~/.oh-my-zsh/custom/plugins/zsh-autosuggestions 2>/dev/null
	fi

	if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
		git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting \
			~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 2>/dev/null
	fi
fi

cat >>~/.zshrc <<'EOF'

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export ZSH="/root/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  colored-man-pages
)

[[ -f $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%F{red}%b%f)'
zstyle ':vcs_info:*'  enable git

setopt PROMPT_SUBST
PROMPT='%F{green}%n@${HOSTNAME}%f:%F{blue}%~%f${vcs_info_msg_0_}$ '

export TERM=xterm-256color CLICOLOR=1
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias grep='grep --color=auto'

HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY APPEND_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt AUTO_CD CORRECT EXTENDED_GLOB

EOF
