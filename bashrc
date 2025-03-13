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

if [[ "$(hostname)" == "treblech" ]]; then
    PS1="(TRE) $PS1"
fi

export PATH=/home/$USER/.local/bin:/home/$USER/pkg:/home/$USER/.cargo/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. "$HOME/.cargo/env"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
export PATH=$PATH:/usr/local/go/bin
