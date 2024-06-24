abbr rm "rm -I"
abbr cp "cp -i"
abbr mv "mv -i"
abbr mkdir "mkdir -p"
abbr ls "eza --icons=always --color=always"
abbr ll "eza --icons=always --color=always -lbgh"
abbr la "eza --icons=always --color=always -labgh"

abbr vi nvim
abbr svi "sudo -Es nvim"
abbr grep "rg --color auto"
abbr catb bat
abbr cat "bat -pp"
abbr ff "fd --type file"
abbr fd "fd --type dir"

abbr shoot "procs | fzf | awk '{print \$1}' | xargs kill -9"

abbr md "fzf --query .md| xargs glow -p"
abbr vmd "fzf --query .md --preview=\"glow {-1}\" --bind 'enter:become(nvim {+}),ctrl-y:execute-silent(echo {} | wl-copy -n)+abort'"

abbr fs "fzf --multi --preview=\"bat --color=always {}\" --bind 'enter:become(nvim {+}),ctrl-y:execute-silent(echo {} | wl-copy -n)+abort'"

abbr scrcpyAudio 'scrcpy --tcpip=192.168.86.26 --no-video'
abbr scrcpyCtrl 'scrcpy --tcpip=192.168.86.26 --turn-screen-off'

abbr sshgem 'ssh kiosk@gemini.circumlunar.space'

abbr vichez 'nvim $HOME/.local/share/chezmoi/'

abbr u2mac '/usr/bin/ddcutil --noverify setvcp xe7 xff00' #switch to mac display/auto-usb

abbr s2mac '/usr/bin/ddcutil setvcp 60 0x1b' #switch usb to mac
