set -x PATH $HOME/opt/bin /usr/local/sbin $HOME/.cargo/bin /usr/local/bin /usr/local/lib/ruby/gems/2.5.0/bin $PATH
set -x LSCOLORS GxFxCxDxBxegehxbxgxcxd
set -x LS_COLORS 'di=01;36:ln=01;35:so=01;32:pi=01;33:ex=01;31:bd=34;46:cd=34;47:su=01;41:sg=01;46:tw=0;42:ow=0;43:'
set -x EDITOR vim

function fish_prompt
	# if the last command failed, print the status code
#	set -l last_command_status $status
#	if test $last_command_status -ne 0
#		set_color green
#		echo -n "exit: "
#		set_color red
#		echo "$last_command_status"
#	end

	# when not in tmux, print the current status information
	if test -z $TMUX
		set_color yellow --bold
		echo -n (prompt_hostname) ""
		set_color normal
		set_color white
		echo -n (prompt_pwd) ""
	end

	switch $fish_bind_mode
        case default
			set_color red --bold
        case insert
			set_color green --bold
        case visual
			set_color blue --bold
    end
	echo -n "% "
	set_color normal
end

function fish_mode_prompt
end

function fish_greeting
end

alias y2j="ruby -ryaml -rjson -e 'YAML.load_stream(ARGF).each { |d| puts JSON.pretty_generate(d) }'"
alias cc-defs="cc -dM -E -x c /dev/null"
alias pls='git ls-files -co --exclude-standard ^/dev/null; or find . -type d -name "*.dSYM" -prune -o -type f -maxdepth 4 -print ^/dev/null'

alias tsh="tmk shell ~"
alias tls="tmux ls -F '#S: created #{t:session_created} in #{s|$HOME|~|:pane_current_path} #{?session_attached,[attached],}' ^/dev/null"

function tm -d "Create or attach to a session directory" -a name
	set -l dir "$PWD"
	if test -z "$name"
		if not set name (tls -F '#S' | fzy)
			return 1
		end
	else if test -d "$name"
		set dir (pushd "$name"; pwd; popd)
		set name (basename $dir)
	end
	tmk $name $dir
end

function tmk -a name dir
	tmux new-session -d -s $name -c "$dir" ^/dev/null
	if test -z $TMUX
		tmux attach-session -t $name
	else
		tmux switch-client -t $name
	end
end

function api
	curl -s $argv | jq
end

if test -z $TMUX
	tmux new-session -A -s shell -c $HOME
end

