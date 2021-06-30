complete -xc tfvm -n __fish_use_subcommand -a ls -d "List available versions matching <regex>"
complete -xc tfvm -n __fish_use_subcommand -a use -d "Download <version> and modify PATH to use it"
complete -xc tfvm -n __fish_use_subcommand -a update -d "Update the version index"
#complete -xc tfvm -n __fish_use_subcommand -a exec -d "Execute terraform using a specific version"

tfvm complete
