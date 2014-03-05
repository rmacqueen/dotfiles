prompt_matt_precmd () {
  local user_host='%{$terminfo[bold]$fg[green]%}%n%{$reset_color%}'
  local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'
  if [[ -n $(git_prompt_info) ]]; then
    local git_branch=' $(git_prompt_info)%{$reset_color%}'
  fi
  if [[ -n $UNDER_JHBUILD ]]; then
    local jhbuild_token='%{$fg[cyan]%} ‹jh›%{$reset_color%}'
  fi
  if [[ -n $GIT_MODE ]]; then
    local git_mode_token='%{$fg[magenta]%} ‹gm›%{$reset_color%}'
  fi
  PROMPT="╭─${user_host}${current_dir}${jhbuild_token}${git_branch}${git_mode_token}
╰─%B$%b "
}

local return_code="%(?..%{$fg[red]%}%? ←←↵%{$reset_color%})"
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%}"

autoload -U add-zsh-hook
add-zsh-hook precmd prompt_matt_precmd
