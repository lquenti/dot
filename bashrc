#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias vim="nvim"

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
alias nvimrc='nvim ~/.config/nvim/init.lua'
alias swayrc='nvim ~/.config/sway/config'
alias de='setxkbmap de'
alias us='setxkbmap us'
alias xclip='xclip -selection c'
alias kb='pushd ~/Sync/thoughts; nvim README.md; popd'
alias work='pushd ~/work; nvim README.md; popd'
alias eupd='sudo emaint --auto sync'
alias efet='sudo emerge -avuDNf @world'
alias eupg='sudo emerge -avuDN @world'
alias lock='swaylock -c "#555555"'

# I want to get more suckless
alias rg='grep -iRnP'

alias yt-mp4='yt-dlp --restrict-filenames -f "bestvideo[ext=mp4][height<=1080]"'
alias yt-1080='yt-dlp --restrict-filenames -f "bestvideo[height=1080]+bestaudio/best[height=1080]"'
alias cloc='cloc --vcs git'

alias calc='python3 -i ~/code/dot/calc.py'

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

function setup_lc() {
  local SESSION_NAME="lc_tmux"
  local DATE="$(date +%Y-%m-%d)"

  if [ -n "$TMUX" ]; then
    echo "Error You are already inside a tmux session."
    return 1
  fi

  pushd ~/code/LGKATA/LC

  firefox --new-window "https://leetcode.com" &
  if [ ! -e "${DATE}.c" ]; then
    cp template.c "${DATE}.c"
  fi

  if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux attach-session -t "$SESSION_NAME"
  else
    tmux new-session -d -s "$SESSION_NAME"
    tmux send-keys -t "$SESSION_NAME":0.0 "nvim ${DATE}.c" C-m

    tmux new-window -t "$SESSION_NAME":1 -n 'build' -c ~/code/LGKATA/LC
    tmux send-keys -t "$SESSION_NAME":1 "gcc -Wall -Wextra -g -fsanitize=address "

    tmux select-window -t "$SESSION_NAME":0
    tmux attach -t "$SESSION_NAME"
  fi
}
alias lc=setup_lc

function setup_bh() {
  # Currently relevant: HTTP server
  local SESSION_NAME="bh_tmux"

  pushd ~/code/LGTOOLS/LGHTTP_SEQ

  if [ -n "$TMUX" ]; then
    echo "Error You are already inside a tmux session."
    return 1
  fi

  if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux attach-session -t "$SESSION_NAME"
  else
    tmux new-session -d -s "$SESSION_NAME"
    tmux send-keys -t "$SESSION_NAME":0.0 "nvim LGHTTP_SEQ.h" C-m

    tmux select-window -t "$SESSION_NAME":0
    tmux attach -t "$SESSION_NAME"
  fi
}
alias bh=setup_bh

declare -A install_dates
install_dates["privb"]="2025-09-22"
install_dates["workblech"]="2025-04-22"
current_weekday=$(date +%u) # do not run on thu
if [[ "$current_weekday" -ne 4 ]] && [[ -n "${install_dates[$(hostname)]}" ]]; then
  install_date="${install_dates[$(hostname)]}"
  current_date=$(date +%Y-%m-%d)
  days_since_install=$(( ($(date -d "$current_date" "+%s") - $(date -d "$install_date" "+%s")) / 86400 ))
  formatted_date=$(date -d "$install_date" "+%d.%m.%Y")
  echo "############################################"
  echo "Installed at $formatted_date ($days_since_install days)"
  echo "############################################"
fi

if [[ "$(hostname)" == "treblech" ]]; then
    PS1="(TRE) $PS1"
fi

export PATH=/home/$USER/.local/bin:/home/$USER/pkg:/home/$USER/.cargo/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. "$HOME/.cargo/env"
export PATH=$PATH:/usr/local/go/bin
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
