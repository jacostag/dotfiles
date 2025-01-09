function shoot --description "Search for a process ank kill it"
    procs | fzf -m --query "$argv" --border | awk '{print $1}' | xargs kill -9
end
