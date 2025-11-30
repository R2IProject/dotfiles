# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

export PATH="$PATH:/home/wreana/.nvim/nvim-linux-x86_64/bin"
alias love="nvim"
alias ls="eza -aa --grid --color=never --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval $(thefuck --alias)
eval $(thefuck --alias fk)

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
eval "$(zoxide init zsh)"
alias cd="z"
