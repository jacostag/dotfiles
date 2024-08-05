function ff --description "finding files"
    fd --type file |
        fzf --prompt 'Files> ' \
            --multi \
            --bind 'enter:become(nvim {+}),ctrl-y:execute-silent(echo {} | wl-copy -n)+abort' \
            --preview "bat --color=always {}"
end
