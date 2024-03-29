# APPEARANCE
if command -v pfetch &>/dev/null; then
  pfetch
fi
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
autoload -U colors && colors # Load colors

# TWEAKS
# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.
# Vi mode
bindkey -v
export KEYTIMEOUT=1
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

# ALIAS
alias dot="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias \
	v="nvim" \
	ll="ls -lSGh" \
	tf="terraform" \
	dc="docker-compose"
alias \
	g="git" \
	gc="git clone" \
	gf="git fetch" \
	gps="git push" \
	gpl="git pull" \
	gpso="git push origin" \
	gplo="git pull origin" \
	gpsm="git push origin main" \
	gplm="git pull origin main" \
	gb="git branch" \
	gch="git checkout" \
	gcb="git checkout -b" \
	gcm="git checkout main" \
	gl="git log" \
	gll="git ll" \
	gs="git stash" \
	gsl="git stash list" \
	gsa="git stash apply" \
	gsd="git stash drop"
alias \
	k="kubectl" \
  kg="kubectl get" \
  kd="kubectl describe" \
  kl="kubectl logs" \
  ke="kubectl explain" \
	kn="kubens" \
	kc="kubectx" \
  kgp="kubectl get pod" \
  kgs="kubectl get service" \
  kgd="kubectl get deploy" \
  kgpa="kubectl get pods -A" \
  kgsa="kubectl get secrets -A" \
  kgna="kubectl get nodes -A" \
  kgrc="kubectl get rc" \
  kgn="kubectl get node" \
  kgs="kubectl get secret" \
  kdp="kubectl describe pod" \
  kds="kubectl describe service" \
  kdd="kubectl describe deploy" \
  keit="kubectl exec -it" \
  ktop="kubectl top nodes" \
  kevent="kubectl get events"
gac() {
	if [ -n "$1" ]; then
		git add . && git commit -m "$1"
	else
		echo "No message provided, commit will not process"
	fi
}

# SOURCING
# Add custom run commands that wouldn't push to public repo
POWERLEVEL10K_PATH="$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme"
ZSH_SYNTAX_HIGHLIGHTING_PATH="$HOME/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
ZSH_AUTOSUGGESTIONS_PATH="$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
CUSTOMRC_PATH="$HOME/.config/zsh/custom"
[ -f $POWERLEVEL10K_PATH ] && source $POWERLEVEL10K_PATH
[ -f $ZSH_SYNTAX_HIGHLIGHTING_PATH ] && source $ZSH_SYNTAX_HIGHLIGHTING_PATH
[ -f $ZSH_AUTOSUGGESTIONS_PATH ] && source $ZSH_AUTOSUGGESTIONS_PATH
[ -f $CUSTOMRC_PATH ] && source $CUSTOMRC_PATH
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
LFCD="$HOME/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi
