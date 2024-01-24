export ZSH="$HOME/.oh-my-zsh"

eval "$(starship init zsh)"
# ZSH_THEME="spaceship"

plugins=(
  git 
  fzf-zsh-plugin 
  colored-man-pages 
  sudo
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

alias cat="batcat"
alias copy="xclip -selection clipboard"
alias updocker="docker-compose up -d --remove-orphans idtheft-services"
alias downdocker="docker-compose down --remove-orphans --rmi local --volumes"
alias upvpn="cat /home/jlparis/myssh | copy && sudo openvpn /home/jlparis/Downloads/awspro-Linux.ovpn"
alias upvpneu="cat /home/jlparis/myssh | copy && sudo openvpn /home/jlparis/Downloads/awspro-Linux-germany.ovpn"
alias upvpnmadrid='cat /home/jlparis/myssh2 | copy && sudo openvpn /home/jlparis/Downloads/awspro-Linux-madrid.ovpn'
alias pods="watch -n 2 kubectl get pods -A"
alias svc="watch -n 2 kubectl get svc -A"
alias hpa="watch -n 2 kubectl get hpa -A"
alias kdesc="kubectl describe"
alias klogs="kubectl logs -f"
alias kget="kubectl get"
alias vim="nvim"
alias grep="rg"
alias rng="ranger"

. /usr/share/autojump/autojump.sh

# Git editor
export GIT_EDITOR=nvim
export EDITOR=nvim

eval $(thefuck --alias) # To use fuck as auto-correction tool
alias f="fuck"

export PATH=$PATH:/usr/local/go/bin
