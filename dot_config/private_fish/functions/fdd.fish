function fdd --description "finding directories"
    fd --type directory |
        fzf --prompt 'Directory> ' \
            --bind 'enter:become(nvim {+}),ctrl-y:execute-silent(echo {} | wl-copy -n)+abort' \
            --preview "eza -T {}"
end
