set -x GOPATH $HOME/dev
set -x GOPRIVATE "github.com/segmentio"
set -x ROBO_CONFIG $GOPATH/src/github.com/segmentio/robofiles/development/robo.yml
set -x SEGMENT_TEAM platform
set -x SEGMENT_USER jeremy.larkin@segment.com
set -x VIMINIT "source $HOME/.config/vim/vimrc"
set -x PATH \
	$HOME/opt/bin \
	$HOME/.cargo/bin \
	/usr/local/opt/llvm/bin \
	/usr/local/sbin \
	/usr/local/bin \
	/usr/local/opt/ruby/bin \
	/usr/local/lib/ruby/gems/3.0.0/bin \
	$HOME/.yarn/bin \
	$HOME/.config/yarn/global/node_modules/.bin \
	$GOPATH/bin $PATH

set -x LSCOLORS GxFxCxDxBxegehxbxgxcxd
set -x LS_COLORS 'di=01;36:ln=01;35:so=01;32:pi=01;33:ex=01;31:bd=34;46:cd=34;47:su=01;41:sg=01;46:tw=0;42:ow=0;43:'
set -x EDITOR vim

function fish_prompt
	# if the last command failed, print the status code
	#set -l last_command_status $status
	#if test $last_command_status -ne 0
	#	set_color green
	#	echo -n "exit: "
	#	set_color red
	#	echo "$last_command_status"
	#end

	# when not in tmux, print the current status information
	if test -z $TMUX
		set_color yellow
		echo -n (prompt_hostname) ""
		set_color normal
		set_color brblack
		echo -n (prompt_pwd) ""
	end

	switch $fish_bind_mode
	case default
		set_color blue --bold
	case insert
		set_color green --bold
	case visual
		set_color magenta --bold
	end

	echo -n "% "
	set_color normal
end

set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1

set -g __fish_git_prompt_color brblack
set -g __fish_git_prompt_color_stagedstate cyan
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_dirtystate green
set -g __fish_git_prompt_color_untrackedfiles yellow
set -g __fish_git_prompt_color_stashstate brblack
set -g __fish_git_prompt_color_cleanstate magenta

set -g __fish_git_prompt_char_cleanstate ' ✔'
set -g __fish_git_prompt_char_dirtystate ' ✚'
set -g __fish_git_prompt_char_invalidstate ' ✖'
set -g __fish_git_prompt_char_stagedstate ' •'
set -g __fish_git_prompt_char_untrackedfiles ' …'
set -g __fish_git_prompt_char_upstream_ahead ' ↑'
set -g __fish_git_prompt_char_upstream_behind ' ↓'
set -g __fish_git_prompt_char_upstream_diverged ' ⇵'
set -g __fish_git_prompt_char_upstream_equal ' ='
set -g __fish_git_prompt_char_stateseparator ''
set -g __fish_git_prompt_char_upstream_prefix (set_color white)

function fish_right_prompt
  __fish_git_prompt
end

function fish_mode_prompt
end

function fish_greeting
end

alias y2j="ruby -ryaml -rjson -e 'YAML.load_stream(ARGF).each { |d| puts JSON.pretty_generate(d) }'"
alias cc-defs="cc -dM -E -x c /dev/null"
alias pls='git ls-files -co --exclude-standard ^/dev/null; or find . -type d -name "*.dSYM" -prune -o -type f -maxdepth 4 -print ^/dev/null'

function lt
	tree -C $argv | less -R
end

alias tsh="tmk shell ~"
alias tls="tmux ls -F '#S: created #{t:session_created} in #{s|$HOME|~|:pane_current_path} #{?session_attached,[attached],}' 2>/dev/null"

function tm -d "Create or attach to a session directory" -a name
	set -l dir "$PWD"
	if test -z "$name"
		echo "usage: tm NAME/DIR"
		return 1
	end
	if test -d "$name"
		set dir (pushd "$name"; pwd; popd)
		set name (basename $dir)
	end
	tmk $name $dir
end

function __complete_tm
	set -l sessions (tmux ls -F '#S' 2> /dev/null)
	printf "%s\tSession\n" $sessions

	set comp (commandline -ct)
	complete -C"nonexistentcommandooheehoohaahaahdingdongwallawallabingbang $comp" | string match -r '.*/$'
end

complete -c tm -x
complete -c tm -k -a '(__complete_tm)'

function tmk -a name dir
	tmux new-session -d -s "$name" -c "$dir" 2>/dev/null
	if test -z $TMUX
		tmux attach-session -t $name
	else
		tmux switch-client -t $name
	end
end

function api
	curl -s $argv | jq
end

function conanit -a dir
	if test -z "$dir"
		echo "directory not specified"
		return 1
	end

	if not mkdir -p $dir
		return 1
	end

	set -l name (basename $dir)

	set -l CMakeLists "$dir/CMakeLists.txt"
	if not test -e "$CMakeLists"
		echo "cmake_minimum_required(VERSION 2.8.12)" > "$CMakeLists"
		echo "project($name)" >> "$CMakeLists"
		echo >> "$CMakeLists"
		echo "add_definitions(\"-std=c++17\")" >> "$CMakeLists"
		echo >> "$CMakeLists"
		echo "include(\${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)" >> "$CMakeLists"
		echo "conan_basic_setup()" >> "$CMakeLists"
		echo >> "$CMakeLists"
		echo "add_executable($name main.cc)" >> "$CMakeLists"
		echo "target_link_libraries($name \${CONAN_LIBS})" >> "$CMakeLists"
	end

	set -l Makefile "$dir/Makefile"
	if not test -e "$Makefile"
		echo "all: build/Makefile" > "$Makefile"
		echo "	cd build && cmake --build ." >> "$Makefile"
		echo >> "$Makefile"
		echo "build/Makefile: build/conanbuildinfo.cmake" >> "$Makefile"
		echo "	cd build && cmake .. -DCMAKE_BUILD_MODE=Release" >> "$Makefile"
		echo >> "$Makefile"
		echo "build/conanbuildinfo.cmake: | build" >> "$Makefile"
		echo "	cd build && conan install .. --build=missing" >> "$Makefile"
		echo >> "$Makefile"
		echo "build:" >> "$Makefile"
		echo "	mkdir build" >> "$Makefile"
		echo >> "$Makefile"
		echo "clean:" >> "$Makefile"
		echo "	rm -rf build" >> "$Makefile"
		echo >> "$Makefile"
		echo ".PHONY: all clean" >> "$Makefile"
	end

	set -l conanfile "$dir/conanfile.txt"
	if not test -e "$conanfile"
		echo "[requires]" > "$conanfile"
		echo "boost/1.69.0@conan/stable" >> "$conanfile"
		echo >> "$conanfile"
		echo "[generators]" >> "$conanfile"
		echo "cmake" >> "$conanfile"
	end

	set -l main "$dir/main.cc"
	if not test -e "$main"
		echo "#include <iostream>" > "$main"
		echo >> "$main"
		echo "int main(int argc, char** argv)" >> "$main"
		echo "{" >> "$main"
		echo "	std::cout << \"hello\" << std::endl;" >> "$main"
		echo "	return 0;" >> "$main"
		echo "}" >> "$main"
	end

	set -l gitignore "$dir/.gitignore"
	if not test -e "$gitignore"
		echo ".DS_Store" > "$gitignore"
		echo "build" >> "$gitignore"
	end

	if not test -d "$dir/.git"
		git init "$dir"
	end
end

if test -z "$TMUX$MYVIMRC"
	tmux new-session -A -s shell -c $HOME
else
	fish_vi_key_bindings

	set fish_color_normal normal # the default color
	set fish_color_command ffffff --bold # the color for commands
	set fish_color_quote green # the color for quoted blocks of text
	set fish_color_redirection normal --bold # the color for IO redirections
	set fish_color_end blue --bold # the color for process separators like ';' and '&'
	set fish_color_error brred --bold # the color used to highlight potential errors
	set fish_color_param normal # the color for regular command parameters
	set fish_color_comment white # the color used for code comments
	set fish_color_match white # the color used to highlight matching parenthesis
	set fish_color_selection normal --background=black # the color used when selecting text (in vi visual mode)
	#set fish_color_search_match # used to highlight history search matches and the selected pager item (must be a background)
	set fish_color_operator cyan --bold # the color for parameter expansion operators like '*' and '~'
	set fish_color_escape green --bold # the color used to highlight character escapes like '\n' and '\x70'
	#set fish_color_cwd # the color used for the current working directory in the default prompt
	set fish_color_autosuggestion 445a77 # the color used for autosuggestions
	#set fish_color_user # the color used to print the current username in some of fish default prompts
	#set fish_color_host # the color used to print the current host system in some of fish default prompts
	#set fish_color_cancel # the color for the '^C' indicator on a canceled command
	set fish_pager_color_prefix bryellow # the color of the prefix string, i.e. the string that is to be completed
	set fish_pager_color_completion normal # the color of the completion itself
	set fish_pager_color_description white # the color of the completion description
	set fish_pager_color_progress brgreen --bold # the color of the progress bar at the bottom left corner
	#set fish_pager_color_secondary # the background color of the every second completion
end

