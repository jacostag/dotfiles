function ff --description "finding files"
    fd --type file $argv[1] |
        fzf --prompt 'Files> ' \
            --multi \
            --border \
            --bind 'enter:become(nvim {+}),ctrl-y:execute-silent(echo {} | wl-copy -n)+abort' \
            --preview "bat -p --color=always {}"
end
