# vi:ft=zsh:fdm=marker

# exports {{{

export GOPATH=$HOME/dev
export ROBO_CONFIG=$GOPATH/src/github.com/segmentio/robofiles/development/robo.yml
export SEGMENT_TEAM=platform
export SEGMENT_USER=jeremy.larkin@segment.com

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegehxbxgxcxd
export LS_COLORS='di=01;36:ln=01;35:so=01;32:pi=01;33:ex=01;31:bd=34;46:cd=34;47:su=01;41:sg=01;46:tw=0;42:ow=0;43:'
export EDITOR=vim
export PATH=$HOME/opt/bin:/usr/local/sbin:$HOME/.cargo/bin::$PATH:$GOPATH/bin

# }}}
# completions {{{

fpath=($HOME/brew/share/zsh-completions /usr/local/share/zsh-completions $HOME/.zsh/completions $fpath)

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

zmodload -i zsh/complist

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# use ~/.ssh/known_hosts and ~/.ssh/config for hostname completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r ~/.ssh/config ] && _ssh_config=(${${${(@M)${(f)"$(<$HOME/.ssh/config)"}:#Host *}#Host }:#*[*?]*}) || _ssh_config=()
hosts=(
  "$_ssh_hosts[@]"
  "$_ssh_config[@]"
  `hostname`
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# Use caching so that commands like apt and dpkg complete are useable
mkdir -p ~/.zsh_cache
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh_cache/

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

autoload -U compinit
compinit -i -d "$HOME/.zsh_compdump"

# }}}
# aliases {{{

alias la='ls -lah'
alias ll='ls -lh'
alias grep="grep --color"
alias pstree="pstree -g 3"
alias clang-defs="clang -dM -E -x c /dev/null"
alias gcc-defs="gcc -dM -E -x c /dev/null"
alias robo="robo --config $ROBO_CONFIG"
alias tsh="tmk shell ~"
alias tls="tmux ls -F '#S: created #{t:session_created} in #{s|$HOME|~|:pane_current_path} #{?session_attached,[attached],}' 2>/dev/null"

function chpwd() {
	emulate -L zsh
	if [ -n $TMUX ]; then
		tmux refresh-client -S 2> /dev/null
	fi
}

function lt {
	tree -C "$@" | less -R
}

# usage: tm NAME/DIR
function tm {
	local dir="$PWD"
	local name="$1"
	if [ -z "$name" ]; then
		echo "usage: tm NAME/DIR"
		return 1
	fi
	if [ -d "$name" ]; then
		pushd "$name" >/dev/null
		dir=`pwd`
		popd >/dev/null
		name=`basename $dir`
	fi
	tmk $name $dir
}

function _tm {
	_alternative "session: :($(tmux ls -F '#S' 2> /dev/null))" "directory: :_dirs"
}

compdef _tm tm

# usage: tmk NAME DIR
function tmk {
	tmux new-session -d -s "$1" -c "$2" 2>/dev/null
	if [ -z $TMUX ]; then
		tmux attach-session -t $1
	else
		tmux switch-client -t $1
	fi
}

function _tmk {
	_arguments "1: :($(tmux ls -F '#S' 2> /dev/null))" "2: :_dirs"
}

compdef _tmk tmk

function len {
	echo -n $@ | wc -c
}

function show-colors {
	local text='gYw'
	echo -e "                 40m     41m     42m     43m     44m     45m     46m     47m";
	for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
           '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
           '  36m' '1;36m' '  37m' '1;37m'; do
		FG=${FGs// /}
		echo -en " $FGs \033[$FG  $text  "
		for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
			echo -en "$EINS \033[$FG\033[$BG  $text  \033[0m";
		done
		echo
	done
	echo
}

function fd {
	cd "$(find . -maxdepth 3 -type d 2>/dev/null | fzy)"
}

# }}}
# vi mode {{{

if [ -z $TMUX ]; then
	MACHINE_PROMPT="%m "
fi
VI_NORMAL_PROMPT="${MACHINE_PROMPT}%{%F{red}%B%}%#%{%f%b%} "
VI_INSERT_PROMPT="${MACHINE_PROMPT}%{%F{green}%B%}%#%{%f%b%} "

autoload -U edit-command-line

function zle-line-init zle-keymap-select {
	if [ $KEYMAP = "vicmd" ]; then
		PROMPT=$VI_NORMAL_PROMPT
	else
		PROMPT=$VI_INSERT_PROMPT
	fi
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N edit-command-line

bindkey -v
bindkey -M vicmd v edit-command-line

# }}}
# history {{{

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history hist_ignore_all_dups hist_reduce_blanks extended_history hist_ignore_space

# }}}
# prompt configuration {{{

autoload -U colors && colors
autoload -Uz vcs_info
autoload -U url-quote-magic

setopt autocd extendedglob nomatch
unsetopt beep notify

zle -N self-insert url-quote-magic

bindkey "^r" history-incremental-search-backward

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
if [ -z $TMUX ]; then
	zstyle ':vcs_info:*' actionformats "%{$fg[red]%}%b %{$fg[green]%}%a%{$reset_color%} %{$fg[magenta]%}%u%c"
	zstyle ':vcs_info:*' formats "%{$fg[green]%}%b%{$reset_color%} %{$fg[magenta]%}%u%c"
else
	zstyle ':vcs_info:*' actionformats "%{$fg[blue]%}%u%c %{$fg[red]%}%b %{$fg[white]%}%a%{$reset_color%}"
	zstyle ':vcs_info:*' formats "%{$fg[blue]%}%u%c %{$fg[white]%}%b%{$reset_color%}"
fi

function precmd {
	local estat=$?
	if [[ $estat -ne 0 ]]; then
		echo "${fg[green]}exit: ${fg[red]}${estat}${reset_color}"
	fi
	echo
	vcs_info
	if [ -z $TMUX ]; then
		echo -ne "\e]2;$PWD\a"
		print -rP "%{$fg[cyan]%}[%*] %{$fg[white]%}%~ ${vcs_info_msg_0_}"
	else
		RPROMPT=$vcs_info_msg_0_
	fi
	PROMPT=$VI_INSERT_PROMPT
}

# }}}

#if [ -e $HOME/.cargo/env ]; then
	#source $HOME/.cargo/env
#fi

if [ -z $TMUX ]; then
	tmux new-session -A -s shell -c $HOME
fi

