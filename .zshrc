if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias notes="nvim ~/Documents/notes/notes.md"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mael-triquet/miniconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/mael-triquet/miniconda/etc/profile.d/conda.sh" ]; then
        . "/home/mael-triquet/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/mael-triquet/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda deactivate

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
alias vim="nvim"
alias v="nvim"
alias :q="exit"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
alias py="python3"
alias c="clear"
alias logout="gnome-session-quit --logout --no-prompt"

# export MANPAGER='nvim +Man!'
set -o vi
source ~/plugins/fuzzy_tools/fuzzy_tools.sh

~/.pywal/bin/wal -q -i ~/Downloads/
alias wal="~/.pywal/bin/wal --cols16 -q -i ~/Downloads/"
alias col="~/.pywal/bin/wal --preview"
