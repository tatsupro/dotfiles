# APPEARANCE
autoload -U colors && colors # Load colors
PS1="%B%{$fg[red]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[cyan]%} > "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# TWEAKS
# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.
# Vi mode
bindkey -v
export KEYTIMEOUT=50
bindkey -M viins 'jj' vi-cmd-mode
# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # Initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete
# History in cache directory
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
# Fuzzy Finder
eval "$(fzf --zsh)"

# SOURCING
# Add custom run commands that wouldn't push to public repo
ZSH_SYNTAX_HIGHLIGHTING_PATH="$HOME/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
ZSH_AUTOSUGGESTIONS_PATH="$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
ALIASRC_PATH="$HOME/.config/zsh/alias"
CUSTOMRC_PATH="$HOME/.config/zsh/custom"

[ -f $ZSH_SYNTAX_HIGHLIGHTING_PATH ] && source $ZSH_SYNTAX_HIGHLIGHTING_PATH
[ -f $ZSH_AUTOSUGGESTIONS_PATH ] && source $ZSH_AUTOSUGGESTIONS_PATH
[ -f $CUSTOMRC_PATH ] && source $CUSTOMRC_PATH
[ -f $ALIASRC_PATH ] && source $ALIASRC_PATH
# [ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
for custom_scripts in $HOME/.local/scripts/*.sh; do
    source "$custom_scripts"
done
