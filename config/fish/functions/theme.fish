function theme -a mode
	switch $mode
	case ""
		set mode "light"
		set -l val (defaults read -g AppleInterfaceStyle) >/dev/null
		if test $status -eq 0
			set mode "dark"
		end
	case light
		set update "false"
		set mode "light"
	case dark
		set update "true"
		set mode "dark"
	case '*'
		echo "unsupported theme '$mode'"
		return 1
	end

	if not test -z $update
		osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = $update" >/dev/null
	end

	set alacritty (realpath ~/.config/alacritty/theme.yml)
	echo >$alacritty "import:
  - ~/.config/alacritty/$mode.yml"

	set r "MessagePack::RPC::Client.new(MessagePack::RPC::UNIXTransport.new, \$_.strip).call(:nvim_command, 'set background=$mode')"
	ls $TMPDIR/nvim*/0 | ruby -r 'msgpack/rpc' -r 'msgpack/rpc/transport/unix' -n -e "$r"
end

complete -c theme -x -a "dark light"
