function tfvm -a cmd -d "terraform version manager"
	set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
	set -g tfvm_config $XDG_CONFIG_HOME/tfvm
	set -g tfvm_url "https://releases.hashicorp.com/terraform"

	switch "$cmd"
	case ls list
		set -e argv[1]
		_tfvm_ls $argv
	case use
		set -e argv[1]
		_tfvm_use $argv
	case update
		_tfvm_update
	end
end

function _tfvm_update
	set -l index "$tfvm_config/index"
	set -q tfvm_index_update_interval; or set -g tfvm_index_update_interval 0

	if ! test -d $tfvm_config
		mkdir -p $tfvm_config
	end

	if test ! -e $index -o (math (command date +%s) - $tfvm_index_update_interval) -gt 300
		command curl --silent "$tfvm_url/" | sed -En 's/^.*terraform_([0-9]+\.[0-9]+\.[0-9]+).*$/\1/p' >$index
		set -g tfvm_index_update_interval (command date +%s)

		for ver in (cat $index)
			complete -xc tfvm -n "__fish_seen_subcommand_from use" -a $ver
		end
	end
end

function _tfvm_ls
	_tfvm_update
	cat "$tfvm_config/index"
end

function _tfvm_use
	set -l ver $argv[1]
	set -l target "$tfvm_config/$ver"

	if test ! -e "$target/terraform"
		set -l os
		set -l arch
		switch (uname -s)
		case Linux
			set os linux
			switch (uname -m)
			case x86_64
				set arch amd64
			case 'armv*'
				set arch arm
			case '*'
				set arch 386
			end
		case Darwin
			set os darwin
			set arch amd64
		case '*'
			echo "tfvm: OS not implemented" >&2
			return 1
		end

		command mkdir -p $target

		set -l url $tfvm_url/$ver/terraform_{$ver}_{$os}_{$arch}.zip
		if not command curl --fail --progress-bar $url | command tar -xzf- -C $target
			command rm -rf $target
			echo "tfvm: fetch error -- are you offline?" >&2
			return 1
		end

		command chmod +x $target/terraform
	end

	if test -s "$tfvm_config/version"
		read -l last <"$tfvm_config/version"
		if set -l i (contains -i -- "$tfvm_config/$last" $fish_user_paths)
			set -e fish_user_paths[$i]
		end
	end

	echo $ver >$tfvm_config/version

	if not contains -- "$target" $fish_user_paths
		set -U fish_user_paths "$target" $fish_user_paths
	end
end


