function fdd --description "finding directories"
    fd --type directory |
        fzf --prompt 'Directory> ' \
            --border \
            --bind 'enter:become(nvim {+}),ctrl-y:execute-silent(echo {} | wl-copy -n)+abort' \
            --preview "eza --icons=always --color=always -T {}"
end
