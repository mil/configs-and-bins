### ZSH Options

#Promptinit
autoload -U promptinit
promptinit


#Auto Completej
setopt extendedglob
zmodload -a autocomplete
zmodload -a complist
zmodload zsh/complist

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors 'reply=( "=(#b)(*$VAR)(?)*=00=$color[green]=$color[bg-green]" )'
zstyle ':completion:*:*:*:*:hosts' list-colors '=*=30;41'
zstyle ':completion:*:*:*:*:users' list-colors '=*=$color[green]=$color[red]'

zstyle ":completion:*:*:$command:*:$tag" list-colors "=(#b)\
=$zshregex_with_brackets\
=$default_color_escape_number\
=$color_number_for_letters_in_first_bracket-pair\
=$color_number_for_letters_in_second_bracket-pair"     "..."

setopt correctall
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt INC_APPEND_HISTORY #share hist
setopt SHARE_HISTORY #share hist

zstyle ':completion:*' menu select
setopt completealiases


autoload -U compinit
compinit

#Colors
zmodload -a colors
autoload -U colors colors
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"




#Version Control Shit
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable hg git bzr svn



#VARIABLES
export TZ="America/New_York"
export HISTSIZE=2000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

export EDITOR="vim -u ~/.vimrc"
export BROWSER="dwb"




###PATH
export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin/:$PATH"
export PATH="/usr/bin/vendor_perl:$PATH" #ls++
export PATH="/usr/lib/cw:$PATH" #Colorized output

export PATH="/home/mil/bin/data:$PATH"
export PATH="/home/mil/bin/downloaded:$PATH"
export PATH="/home/mil/bin/misc:$PATH"
export PATH="/home/mil/bin/symlinks:$PATH"
export PATH="/home/mil/bin/system:$PATH"
export PATH="/home/mil/bin/util:$PATH"
export PATH="/home/mil/bin/wm:$PATH"
export PATH="/home/mil/bin/x:$PATH"


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

PATH=$PATH:/home/mil/.gem/ruby/1.9.1/bin
export PATH




### ALIASES 
alias ls='ls++'
alias v='vim'
alias back='cd "$OLDPWD";pwd'
alias grep='grep --colour'
alias tree='tree -C'
alias pacman='pacman-color'
alias vim='vim -u ~/.vimrc'
alias gcalc='pwdhash google.com | sed -n 2p | xargs -0 -I XXX gcalcli --user miles.sandlar@gmail.com --pw XXX'

alias mwm='exec /home/mil/repos/github/mwm/mwm'



### FUNCTIONS

# PWDHash and PWDClip
pwdclip() {
    pwdhash $* | sed -n 2p | tr -d '\n' | xclip -sel clip
    #notify-send "clipped hash:: $1"
    echo "clippd"
}

# Extract Stuff
extract () {
if [ -f $1 ]; then
    case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       unrar e $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
	else
         echo "'$1' is not a valid file"
fi
}


###ZSH PLUGINS
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlight/zsh-syntax-highlighting.zsh

#source /home/mil/.zsh/auto-fu.zsh
#zle-line-init () {auto-fu-init;}; zle -N zle-line-init
#zstyle ':completion:*' completer _oldlist _complete
#zle -N zle-keymap-select auto-fu-zle-keymap-select


###MISC

#VIM COMPATIBILITY & Inline Keybindings
set -o vi
bindkey -v


#Xdefaults colors in console
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" $HOME/.Xdefaults | \
               awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        echo -en "$i"
    done
    clear
fi
THSTATUS=`tput tsl`
FHSTATUS=`tput fsl`

set_xterm_title() {
    if tput hs ; then
        print -Pn "$THSTATUS$@$FHSTATUS"
    fi
}
export TDIR="sdfasdf"
alias scmstatus=`echo $TDIR`

preexec() {
    set_xterm_title "urxvt< %n@%m: %50>...>$1%<<"
}

PROMPT=""
RPROMPT=""
setopt prompt_subst


#key setups
# bindkey SO HERE'S HOW I CONFIGURED THE PROMPT FOR ZSH:-v # vi key bindings
bindkey -e bold # emacs key bindings
bindkey ' ' magic-space # also do history expansion on space

# setup backspace correctly
stty erase `tput kbs`

#delete key
bindkey '\e[3~' delete-char

#home
bindkey '\e[1~' beginning-of-line


figlet `hostname`


local IT="${terminfo[sitm]}${terminfo[bold]}"
local ST="${terminfo[sgr0]}${terminfo[ritm]}"

local FMT_BRANCH="%F{9}(%s:%F{7}%{$IT%}%r%{$ST%}%F{9}) %F{11}%B%b %K{235}%{$IT%}%u%c%{$ST%}%k"
local FMT_ACTION="(%F{3}%a%f)"
local FMT_PATH="%F{1}%R%F{2}/%S%f"

setprompt() {
  local USER="%(#.%F{1}.%F{3})%n%f"
  local HOST="%F{1}%M%f"
  local PWD="%F{7}$($XDG_CONFIG_HOME/zsh/rzsh_path)%f"
  local TTY="%F{4}%y%f"
  local EXIT="%(?..%F{202}%?%f)"
  local PRMPT="${USER}@$HOST:${TTY}: ${PWD}
${EXIT} %F{202}»%f "

  if [[ "${vcs_info_msg_0_}" == "" ]]; then
    PROMPT="$PRMPT"
  else
    PROMPT="${vcs_info_msg_0_}
$PRMPT"
  fi
}



precmd() {
    set_xterm_title "urxvt> %n@%m: %50<...<%~%<<"
    echo -e "\e[1;30m\e[1;43m`sh /home/mil/bin/system/scmstatus $PWD`"
		setprompt
}


