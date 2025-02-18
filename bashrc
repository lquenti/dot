#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias leetcode='g++ -Wall -Wextra -g -fsanitize=address'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
export PS1="\w\\$ "

alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gs='git status'
alias gp='git push'
alias gpu='git pull'
alias glo='git log --oneline'
alias :r="source ~/.bashrc"
alias bashrc='nvim ~/.bashrc'
alias de='setxkbmap de'
alias us='setxkbmap us'
alias xclip='xclip -selection c'

alias archive='time yt-dlp --yes-playlist -R infinite --retry-sleep=exp=1 --restrict-filenames --write-description --write-info-json --write-thumbnail -S "ext"'

alias sshbig='ssh cloud@141.5.106.221'
alias sshdaemon='ssh cloud@141.5.108.64'

function cd() { builtin cd -- "$@" && { [ "$PS1" = "" ] || ls -hrt --color; }; }

function setup_venv() {
    if [[ ! -d venv ]]; then 
        echo "creating venv"
        python3 -m venv venv
        if [[ ! -f ./.gitignore ]] || ! grep -q "^venv/$" ./.gitignore; then
            echo "venv/" >> ./.gitignore
        fi
        if [[ -f ./requirements.txt ]]; then 
            echo "requirements.txt found, installing"
            ./venv/bin/pip install -r ./requirements.txt
        fi
    fi
    source ./venv/bin/activate
}
alias venv=setup_venv

setup_work() {
    tmux new-session -d -s work

    tmux send-keys -t work:0.0 "cd ~/code/forevercode/foreverbusy/" C-m
    tmux send-keys -t work:0.0 "source ./venv/bin/activate" C-m
    tmux send-keys -t work:0.0 "clear" C-m
    tmux send-keys -t work:0.0 "python3 summarize.py" C-m
    tmux send-keys -t work:0.0 "python3 track.py "

    tmux split-window -h -t work:0
    tmux send-keys -t work:0.1 "cd ~/code/lquentin/time_tracking/" C-m
    tmux send-keys -t work:0.1 "nvim timetracking.md" C-m

    tmux select-pane -t work:0.0
    tmux attach-session -t work
}
alias work=setup_work


if [[ "$(hostname)" == "omniblech" ]]; then
    install_date="2024-11-09"
    current_date=$(date +%Y-%m-%d)
    days_since_install=$(($(($(date -d "$current_date" "+%s") - $(date -d "$install_date" "+%s"))) / 86400))
    echo "Installed at 21.10.2024 ($days_since_install days)"
fi
if [[ "$(hostname)" == "db" ]]; then
    install_date="2024-12-30"
    current_date=$(date +%Y-%m-%d)
    days_since_install=$(($(($(date -d "$current_date" "+%s") - $(date -d "$install_date" "+%s"))) / 86400))
    echo "Installed at 21.10.2024 ($days_since_install days)"
fi
if [[ "$(hostname)" == "treblech" ]]; then
    PS1="(TRE) $PS1"
fi


# saxon stuff
export SAXONPATH=/home/$USER/pkg
export SAXON12CLASSPATH=$SAXONPATH/saxon-he-12.5.jar:$SAXONPATH/lib/xmlresolver-5.2.2.jar:$SAXONPATH/lib/xmlresolver-5.2.2-data.jar
alias saxonXQ='java -cp $SAXON12CLASSPATH net.sf.saxon.Query'
alias saxonXSL='java -cp $SAXON12CLASSPATH net.sf.saxon.Transform'
alias saxonValid='java -cp $SAXON12CLASSPATH net.sf.saxon.Query -qs:. -dtd:on '

export PATH=/home/$USER/.local/bin:/home/$USER/pkg:/home/$USER/.cargo/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[ -f "/home/$(whoami)/.ghcup/env" ] && . "/home/$(whoami)/.ghcup/env" # ghcup-env
. "$HOME/.cargo/env"
export PATH=$PATH:/usr/local/go/bin
