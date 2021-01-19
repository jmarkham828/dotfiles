SCRIPTS="${HOME}/Desktop/scripts"
source "${SCRIPTS}/git-aliases.sh" &>/dev/null
### SETTINGS ### 

# Vim keybinding in terminal prompt
set -o vi

# Remap esc to "JK"
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins 'kj' vi-cmd-mode
bindkey -M viins 'Jk' vi-cmd-mode
bindkey -M viins 'JK' vi-cmd-mode

setopt auto_cd
export CDPATH="$CDPATH:${HOME}/src"
ZSH_DISABLE_COMPFIX="true"

### git Command Line Prompt ### 
autoload -Uz vcs_info
precmd () { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

# Zsh syntax highlighting
source /Users/johnmarkham/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

### Command Line Prompt/Color Formatting ### 
setopt PROMPT_SUBST
PS1='%~%F{red} ${vcs_info_msg_0_}%b %F{blue}>%F{cyan}>%F{white}> %F{reset}'

### ALIASES ### 
# Note to self: if you alias over a built-in command, you can always invoke it with
# \CMD. This will bypass any aliases
alias l='ls'

alias de='cd && cd Desktop/'

SRC_DIR_NAMES="$(cd ~/src/ && find . -type d -maxdepth 1 | sed 's/[\.\/]//g' | sed '/^[[:space:]]*$/d')"
while read -r dir; do
    alias $dir="cd ~/src/ && cd $dir"
done <<< $SRC_DIR_NAMES

alias gob='go build'

alias gu='git fetch && git pull'
alias git-cur='git rev-parse --abbrev-ref HEAD'
alias master='git checkout master'
alias groot="git rev-parse --show-toplevel"

alias sw='echo $(PWD) | pbcopy'
alias timer='while true; do echo -ne "`date`\r"; done'

alias nv='nvim'
alias rc='nvim $HOME/.zshrc && source $_'
alias sane='stty sane'
alias v='nvim'
alias vim='nvim'
alias vrc='nvim ~/.config/nvim/init.vim'

# STFU about make clena please
alias clena='clean'

alias ccc='clear'

### FUNCTIONS ###
SHEBANG="#!/usr/bin/env bash"

addcusage() {
    echo "Usage: ${FUNCNAME[0]} -c command_name -d command_desc"
}

# "Writes down" a cool command 
addc() {
    if [[ $# -lt 4 ]]
    then
        addcusage
        return
    fi

    c=unset
    d=unset
    while getopts "c:d:" opt; do
        case "${opt}" in
            c)
                c="${OPTARG}"
                ;;
            d)
                d="${OPTARG}"
                ;;
            *)
                addcusage
                ;;
        esac
    done

    if [[ -z ${c} ]] || [[ -z ${d} ]] 
    then
        addcusage
        return
    fi
    echo "Command name: $c"
    echo "Command description: $d"

    COMMAND_FILE="$HOME/Desktop/commands/commands.list"

    confirmation=unset
    echo "Is this OK? [y/n]"

    read -r confirmation
    until [ "$confirmation" = "y" ] || [ "$confirmation" = "n" ]
    do
        echo "Please specify [y/n]"
        read -r confirmation
    done

    if [ "$confirmation" = "y" ]
    then
        echo "Writing command to $(basename $COMMAND_FILE)"
        COMMAND_STR="${c} ${d}" 
        echo $COMMAND_STR >> $COMMAND_FILE
    else
        echo "Not writing command"
    fi
        
}

wipeusage() {
    echo "Usage: ${FUNCNAME[0]} filename"
}

# Empties a file
wipe() {
    if [[ $# -lt 1 ]]
    then
        wipeusage
        return
    fi
    cp /dev/null $1
}

# Adds shebang to file if it doesn't exist or is empty
vish() {
    files=()
    for file 
    do
        if ! [[ $file =~ \.sh$ ]]
        then
            file="${file}.sh"
        fi
        files+=$file
        if [[ ! -e $file ]]
        then
            touch $file
            echo $SHEBANG >> "$file"
            # Only this user can execute by default, you need to update if using a cron job
            chmod u+x "$file" 
        fi
    done
    # Open multiple files in vim file1, file2, ..., filen
    vim -p $files
}

# Padding for when a pager is annoying
function pre() {
    for i in {1..50} do; echo "####################" ;
}

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  # update keymap variable for the prompt
  VI_KEYMAP=$KEYMAP

  zle reset-prompt
  zle -R
}

zle -N zle-keymap-select

function vi-accept-line() {
  VI_KEYMAP=main
  zle accept-line
}

zle -N vi-accept-line

# use custom accept-line widget to update $VI_KEYMAP
bindkey -M vicmd '^J' vi-accept-line
bindkey -M vicmd '^M' vi-accept-line

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

### FZF ###
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

function rot13() {
    echo $1 | tr '[a-z][A-Z]' '[n-za-m][N-ZA-M]'
}

[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh

# Stuff I will delete the minute I ever leave Coinbase
export GEM_HOME="$HOME/.gem"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$HOME/.gem/bin:$PATH
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"
eval export PATH="/Users/johnmarkham/.rbenv/shims:${PATH}"
export RBENV_SHELL=zsh
source '/usr/local/Cellar/rbenv/1.1.2/libexec/../completions/rbenv.zsh'
export PATH="/usr/local/opt/ruby/bin:$PATH"
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}

export AWS_ROLE_SESSION_TIMEOUT=28800

eval "$(rbenv init -)"
export CF_TOKEN=d2781d55dc5df2076bd4560cdd764dea
eval "$($(go env GOPATH)/bin/assume-role -init)"

# Sublime
export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH

# STFU
export HOMEBREW_NO_AUTO_UPDATE=1
