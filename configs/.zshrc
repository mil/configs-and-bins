
autoload -U promptinit
promptinit

 setopt extendedglob
 zmodload -a colors
 zmodload -a autocomplete
 zmodload -a complist


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


zmodload zsh/complist


autoload -Uz vcs_info
zstyle ':vcs_info:*' enable hg git bzr svn


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

#Copy XDefaults Colors if not in X
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" $HOME/.Xdefaults | \
               awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        echo -en "$i"
    done
    clear
fi



 #key bindings
 bindkey "\e[1~" beginning-of-line
 bindkey "\e[4~" end-of-line
 bindkey "\e[5~" beginning-of-history
 bindkey "\e[6~" end-of-history
 bindkey "\e[3~" delete-char
 bindkey "\e[2~" quoted-insert
 bindkey "\e[5C" forward-word
 bindkey "\eOc" emacs-forward-word
 bindkey "\e[5D" backward-word
 bindkey "\eOd" emacs-backward-word
 bindkey "\e\e[C" forward-word
 bindkey "\e\e[D" backward-word
 # for rxvt
 bindkey "\e[8~" end-of-line
 bindkey "\e[7~" beginning-of-line
 # for non RH/Debian xterm, can't hurt for RH/DEbian xterm
 bindkey "\eOH" beginning-of-line
 bindkey "\eOF" end-of-line
 # for freebsd console
 bindkey "\e[H" beginning-of-line
 bindkey "\e[F" end-of-line
 # completion in the middle of a line
 # bindkey '^i' expand-or-complete-prefix

export HISTSIZE=2000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE


export EDITOR="vim -u ~/.vimrc"
export BROWSER="uzbl-tabbed"

export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin/:$PATH"
export PATH="/usr/lib/cw:$PATH"
export PATH="/home/miles/bin:$PATH"
export TZ="America/New_York"

alias back='cd "$OLDPWD";pwd'
alias ls='ls++'
alias grep='grep --colour'
alias tree='tree -C'
alias pacman='pacman-color'

#alias dualscreen='xrandr --output LVDS1 -o normal --pos 0x0 --mode 1280x800 --output DVI1 --pos 0x0 -o normal --mode 1920x1200 --right-of LVDS1'
alias triplescreen='xrandr --output LVDS1 -o normal --pos 0x0 --mode 1280x800 --output DVI1 --pos 0x0 -o normal --mode 1920x1200 --right-of LVDS1 --output TV1 --pos 0x0 -o normal --mode 1024x768 --right-of DVI1'

alias singlescreen='xrandr --output LVDS1 -o normal --pos 0x0 --mode 1280x800 --output DVI1 --off'

alias btkeyboard='sudo hidd --connect 00:1B:63:FD:2E:E5'

alias notes-update='cd /home/miles/Dropbox && mksite notes && rsync -rv --delete notes/output/* bladdo@bladdo.net:/home/bladdo/notes.bladdo.net/'

alias vim='vim -u ~/.vimrc'

# PWDHash and PWDClip
pwdclip() {
    node ~/bin/pwdhash.js $* | sed -n 2p | tr -d '\n' | xclip -sel clip
    #notify-send "clipped hash:: $1"
    echo "clippd"
}

#PWDHash Password used for gcalc and stored username
alias gcalc='pwdhash google.com | sed -n 2p | xargs -0 -I XXX gcalcli --user miles.sandlar@gmail.com --pw XXX'


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

# Define Stuff
define () {
lynx -dump "http://www.google.com/search?hl=en&q=define%3A+${1}&btnG=Google+Search" | grep -m 3 -w "*"  | sed 's/;/ -/g' | cut -d- -f1 > /tmp/templookup.txt
            if [[ -s  /tmp/templookup.txt ]] ;then    
                until ! read response
                    do
                    echo "${response}"
                    done < /tmp/templookup.txt
                else
                    echo "Sorry $USER, I can't find the term \"${1} \""                
            fi    
rm -f /tmp/templookup.txt
}

#Xdefaults colors in console
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" $HOME/.Xdefaults | \
               awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        echo -en "$i"
    done
    clear
fi

source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


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

precmd() {
    set_xterm_title "urxvt> %n@%m: %50<...<%~%<<"
    echo -e "\e[1;30m\e[1;43m`sh /home/miles/.scmstatus $PWD`"
}


PROMPT=""
RPROMPT=""
setopt prompt_subst


fortune futurama 

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

PROMPT=""
RPROMPT=""
setopt prompt_subst

set -A prompt_array \
    "%{$bg[green]%}%{$fg[black]%}%n%{$fg[default]%}" \
    "%{$bg[white]%}%{$fg[black]%}@" \
    "%{$bg[blue]%}%{$fg[black]%}%m%{$fg[default]%}" \
    "%{$terminfo[sgr0]%}" \
    "%{$fg[black]%}%{$bg[red]%}>%{$bg[default]%} "


set -A rprompt_array \
    "%{$terminfo[bold]%}" \
    "%0(?..%{$fg[red]%}%?) " \
    "%U%{$bg[black]%}%{$fg[white]%}%~%u " \
    "%{$bg[white]%}%{$fg[black]$terminfo[bold]%}%D{%l:%M%p}%{$terminfo[sgr0]%}" \
    "%{$vcs_info_msg_0_%}"
  
for i in $prompt_array; do PROMPT=${PROMPT}${i} done
for i in $rprompt_array; do RPROMPT=${RPROMPT}${i} done

#VI Inline
set -o vi
bindkey -v

