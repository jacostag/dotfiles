abbr rm "rm -I"
abbr cp "cp -nvi"
abbr mv "mv -nvi"
abbr mkdir "mkdir -p"
abbr ls "eza --icons=always --color=always"
abbr ll "eza --icons=always --color=always -lbgh"
abbr la "eza --icons=always --color=always -labgh"

abbr vi nvim
abbr svi "sudo -Es nvim"
abbr grep "rg --color auto"
abbr catb bat
abbr cat "bat -pp"
abbr cle "yes ' ' | head -n 100"

abbr sed "sad --pager 'delta -s'"

abbr tvmd "fd -t f .md | tv --preview 'mdcat {0}'"
abbr tvf "fd -t f | tv --preview 'bat -p --color=always {0}'"
abbr ntv "tv | xargs nvim"

abbr scrcpyAudio 'scrcpy --tcpip=192.168.86.26 --no-video'
abbr scrcpyCtrl 'scrcpy --tcpip=192.168.86.26 --turn-screen-off'
abbr scrcpyScreen 'scrcpy --tcpip=192.168.86.26 --turn-screen-off --new-display'

abbr reap 'set -gx GDK_SCALE 1.75; pw-jack -s 48000 -p 256 reaper -new'

abbr dndon 'gsettings set org.gnome.desktop.notifications show-banners false'
abbr dndoff 'gsettings set org.gnome.desktop.notifications show-banners true'

abbr sshgem 'ssh kiosk@gemini.circumlunar.space'

abbr vichez 'nvim $HOME/.local/share/chezmoi/'

abbr u2mac '/usr/bin/ddcutil --noverify setvcp xe7 xff00' #switch to mac display/auto-usb

abbr s2mac '/usr/bin/ddcutil setvcp 60 0x1b' #switch usb to mac

abbr delsnaps 'sudo snapper --config root --csvout list --columns number | rg -v "0|number" | xargs -I {} sudo snapper delete -s {}'

#bash -c 'gsettings set org.gnome.desktop.notifications show-banners $(if [ "$(gsettings get org.gnome.desktop.notifications show-banners)" = "true" ]; then echo "false"; else echo "true"; fi)'
