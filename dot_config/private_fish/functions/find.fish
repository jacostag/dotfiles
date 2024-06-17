function find --description "finding files/directories"
    fd --type file |
        fzf --prompt 'Files> ' \
            --multi \
            --header 'CTRL-F: Switch between Files/Directories' \
            --bind 'enter:become(nvim {+}),ctrl-y:execute-silent(echo {} | wl-copy -n)+abort' \
            --bind 'ctrl-f:transform:[[ ! $FZF_PROMPT =~ Files ]] &&
              echo "change-prompt(Files> )+reload(fd --type file)" ||
              echo "change-prompt(Directories> )+reload(fd --type directory)"' \
            --preview '[[ $FZF_PROMPT =~ Files ]] && bat --color=always {} || eza -T {}'
end
