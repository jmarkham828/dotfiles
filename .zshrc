### SETTINGS ### 
set -o vi

autoload -Uz compinit && compinit # allow git autocompletion


### git Command Line Prompt ### 
autoload -Uz vcs_info
precmd () { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

### Command Line Prompt/Color Formatting ### 
setopt PROMPT_SUBST

export CLICOLOR=1
PS1='%F{red}%*%F{yellow}@%F{green}[%B%~%b]%F{blue}[%B${vcs_info_msg_0_}%b] %F{magenta}
$ %F{reset}'

### ALIASES ### 
# Note to self: if you alias over a built-in command, you can always invoke it with
# \CMD. This will bypass any aliases
alias l='ls'


setopt auto_cd

# Desktop Shortcuts <3
# AKA an implementation of CDPATH=CDPATH:~/Desktop/
alias de='cd && cd Desktop/'
DESKTOP_DIR_NAMES="$(de && find . -type d -maxdepth 1 | sed 's/[\.\/]//g' | sed '/^[[:space:]]*$/d')"
while read -r file; do
    alias $file="de && cd $file"
done <<< $DESKTOP_DIR_NAMES

alias gob='go build'

alias add='git add'
alias branch='git branch'
alias checkout='git checkout'
alias commit='git commit'
alias delete-branches='git branch | grep -v master | xargs git branch -D'
alias git-cur='git rev-parse --abbrev-ref HEAD'
alias master='git checkout master'
alias pull='git pull'
alias push='git push'
alias rebase='git rebase'
alias status='git status'

alias sw='echo $(PWD) | pbcopy'
alias timer='while true; do echo -ne "`date`\r"; done'

# STFU about make clena please
alias clena='clean'

alias hh='de && cd projects/heavy-hitters/'
alias hhb='cd ${GOROOT}/src/heavy-hitters-batch'
alias hhl='cd ${GOROOT}/src/heavy-hitters-lambdas'

alias nv='nvim'
alias rc='vim $HOME/.zshrc && source $_'
alias sane='stty sane'
alias v='nvim'
alias vim='nvim'
alias vrc='nv ~/.vimrc'

export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

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
        COMMAND_STR="${c} -- ${d}" 
        echo $COMMAND_STR >> $COMMAND_FILE
    else
        echo "Not writing command"
    fi
        
}

wipeusage() {
    echo "Usage: ${FUNCNAME[0]} filename"
}

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

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins 'Jk' vi-cmd-mode

# use custom accept-line widget to update $VI_KEYMAP
bindkey -M vicmd '^J' vi-accept-line
bindkey -M vicmd '^M' vi-accept-line

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

# allow ctrl-r and ctrl-s to search the history
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
fi

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi

function vi_mode_prompt_info() {
	local mode_indicator
	if [[ "${KEYMAP}" == 'vicmd' ]]
	then
		mode_indicator='[N]'
	else
		mode_indicator='[I]'
	fi
	echo "%{%B%}%{%b%}%{%B%F{red}%}${mode_indicator}%{%b%f%}%{%B%} %{%b%}"
}

### FZF ###
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/usr/local/opt/ruby/bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

