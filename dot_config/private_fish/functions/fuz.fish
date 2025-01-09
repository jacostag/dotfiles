function fuz --description "search fzf with bat preview"
    fzf --multi \
        --ansi \
        --query "$argv" \
        --preview "bat -p --color=always {}" \
        --prompt 'fuz> ' \
        --border \
        --bind "enter:become(nvim {+}),ctrl-y:execute-silent(echo {} | wl-copy -n)+abort"
end
