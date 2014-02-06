local user_host='%{$terminfo[bold]$fg[green]%}%n%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'
local git_mode_prompt='%{$fg[magenta]%}$GIT_MODE%{$reset_color%}'
PROMPT="╭─${user_host}${current_dir} ${git_branch} ${git_mode_prompt}
╰─%B$%b "

local return_code="%(?..%{$fg[red]%}%? ←←↵%{$reset_color%})"
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%}"
