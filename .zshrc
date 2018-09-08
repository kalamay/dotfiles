# vi:ft=zsh

# Exports {{{

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegehxbxgxcxd
export LS_COLORS='di=01;36:ln=01;35:so=01;32:pi=01;33:ex=01;31:bd=34;46:cd=34;47:su=01;41:sg=01;46:tw=0;42:ow=0;43:'
export EDITOR=vim
export PATH=$HOME/opt/sbin:$HOME/opt/bin:/usr/local/sbin:$PATH
export HOMEBOX=sjc1-b4-8

# }}}
# Aliases {{{

alias la='ls -lah'
alias ll='ls -lh'
alias lt='tree | less'
alias grep="grep --color"
alias pstree="pstree -g 3"
alias clang-defs="clang -dM -E -x c /dev/null"
alias gcc-defs="gcc -dM -E -x c /dev/null"
alias ixurl='curl -I -u "badger:" -H "Fastly-Debug: 1" -H "X-Imgix-Caller: fastly-9b9e60c2"'
alias pt='tail -f /data/log/painter/painter.stderr.log | grep --colour=always " [45]\d\d "'
alias ansible-playbook="ansible-playbook --vault-password-file ${HOME}/.vault_pass.txt"
alias ducks="du -cks output_queue/* | sort -rn | head"
alias bat="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep --color=never -E 'state|to\ full|percentage'"
alias y2j="ruby -ryaml -rjson -e 'YAML.load_stream(ARGF).each { |d| puts JSON.pretty_generate(d) }'"
function testproxy() {
	local p=${1:-/}
	local s=$(echo -n "${2:-sGMjvyjf}$p" | md5)
	echo "http://testwebproxy.imgix.net$p&s=$s"
}

function ptr() {
	ssh "sjc1-$1" "tail -f /data/log/painter/painter.stderr.log | grep --line-buffered --colour=always ' [45]\d\d '"
}

function s() {
	ssh "sjc1-$1"
}

function len() {
	echo -n $@ | wc -c
}

function spillway-tail() {
	if [[ $HOSTNAME != $HOMEBOX ]]; then
		if ping -qc 1 sjc1-b4-8 > /dev/null; then
			ssh $HOMEBOX "tail -F ~andy/tmp/tail/log/current"
		else
			ssh home "tail -F ~andy/tmp/tail/log/current"
		fi
	else
		tail -F ~andy/tmp/tail/log/current
	fi
}

function show-colors() {
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

function fd() {
	cd "$(find . -maxdepth 3 -type d | fzy)"
}

function insert-path-in-command-line() {
	local selected_path
	selected_path=$(ag . -l -g '' | fzy -p "$LBUFFER") || return
	eval 'LBUFFER="$LBUFFER$selected_path"'
	zle reset-prompt
}
zle -N insert-path-in-command-line
bindkey "^P" "insert-path-in-command-line"

# }}}
# Vi Mode {{{1
VI_NORMAL_PROMPT="%m %{%F{red}%B%}%#%{%f%b%} "
VI_INSERT_PROMPT="%m %{%F{green}%B%}%#%{%f%b%} "

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

# }}}1
# History {{{1

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history hist_ignore_all_dups hist_reduce_blanks extended_history hist_ignore_space

# }}}1
# Completions {{{1

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

# }}}1
# Prompt Configuration {{{

autoload -U colors && colors
autoload -Uz vcs_info
autoload -U url-quote-magic

setopt autocd extendedglob nomatch
unsetopt beep notify

zle -N self-insert url-quote-magic

bindkey "^r" history-incremental-search-backward

zstyle ':vcs_info:*' actionformats "%{$fg[red]%}%b %{$fg[green]%}%a%{$reset_color%}"
zstyle ':vcs_info:*' formats "%{$fg[green]%}%b%{$reset_color%}"
zstyle ':vcs_info:*' enable git

function precmd() {
	local estat=$?
	if [[ $estat -ne 0 ]]; then
		echo "${fg[green]}exit: ${fg[red]}${estat}${reset_color}"
	fi
	echo
	vcs_info
	echo -ne "\e]2;$PWD\a"
	print -rP "%{$fg[cyan]%}[%*] %{$fg[white]%}%~ ${vcs_info_msg_0_}"
	PROMPT=$VI_INSERT_PROMPT
}

# }}}

