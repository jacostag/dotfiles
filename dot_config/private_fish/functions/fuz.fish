function fuz --description "search fzf with bat preview"
    fzf --multi \
        --ansi \
        --query "$argv" \
        --preview "bat --color=always {}" \
        --prompt 'fuz> ' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind "enter:become(nvim {+}),ctrl-y:execute-silent(echo {} | wl-copy -n)+abort"
end
