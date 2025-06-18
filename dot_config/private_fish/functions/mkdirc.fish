function mkdirc --description "create and enter a new dir"
    /usr/bin/mkdir $argv[1]
    and begin
        echo "cd to new directory: $PWD"
        cd $argv[1]
    end
end
