complete -c gpk -f
complete -c gpk -n "__fish_use_subcommand" -a "(gpk completions commands)"
complete -c gpk -n "__fish_seen_subcommand_from remove upgrade info source-of why versions downgrade hold" -a "(gpk completions installed)"
complete -c gpk -n "__fish_seen_subcommand_from unhold" -a "(gpk completions held)"
complete -c gpk -n "__fish_seen_subcommand_from snapshot snap" -a "save list diff prune"
complete -c gpk -l manager -x -a "(gpk completions managers)"
complete -c gpk -s m -x -a "(gpk completions managers)"
