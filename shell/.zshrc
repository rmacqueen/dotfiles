# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="bira"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(github)


export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.bin:$HOME/bin:/usr/local/opt/python/libexec/bin:$HOME/go/bin:$HOME/Library/Python/2.7/bin

source $ZSH/oh-my-zsh.sh

source ~/.profile

#git uses sublime
export EDITOR="subl -w"

# resume downloads if dc'd
alias wget='wget -c'
alias chrome='google-chrome'
alias gdb='gdb -q -ex r'

# some more ls aliases
alias la='ls -A'
alias ll='ls -Alh'
alias lt='ls -Alhtr'

# easy zsh move
autoload -U zmv
alias mmv='noglob zmv -W'

# sudo uses aliases
# alias sudo='sudo '

export GOPATH="$HOME/gocode"

[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh

# more dots
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias size='command du -sh'

alias shutdown='quote && sudo shutdown -h now'
alias reboot='sudo shutdown -r now'

alias zedit='subl ~/.zshrc'
alias zup='source ~/.zshrc'

# cd commands for the stuff i'm currently working on
alias rd='cd ~/checkout/rd'

# ssh connections

# git
alias mas='git checkout master'
alias pull='git pull'
alias masp='mas && pull'
alias gg='git grep -Ii'
alias s='git status'
alias l='git log'
alias co='git rebase --continue'
alias af='arc diff -m "fix"'


# pipe to grep
alias -g '@'="| command grep"
alias pgrep="ps -e | command grep"
alias dgrep="dpkg -l | command grep"

# add to clipboard
alias clip="xclip -sel clip"

# ls after every cd
function chpwd() {
    emulate -LR zsh
    ls
}

# quick clone
function gclone()
{
    if [ "$#" -eq 0 ]; then
        say "Enter a path!"
        return
    fi
    local gitpath=git@github.com:"$1".git
    shift
    git clone $gitpath "$@"
}

# Git mode! work in progress
function rm_git_mode()
{
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local output
        output=`git rm $@ 2>&1`
        local ret="$?"
        if [ $ret -ne 128 ]; then
            echo $output
            return $ret
        fi
    fi
    command rm "$@"
}
function mv_git_mode()
{
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local output
        output=`git mv $@ 2>&1`
        local ret="$?"
        if [ $ret -ne 128 ]; then
            echo $output
            return $ret
        fi
    fi
    command mv "$@"
}
function alias_git_mode()
{
    local aliases="$(git config --get-regexp '^alias.' | sed s/alias.// | awk '{print $1}')"
    local git_builtins="add am annotate apply archive bisect blame branch bundle cat-file check-attr check-ref-format checkout checkout-index cherry cherry-pick clean clone column commit commit-tree config count-objects credential credential-cache credential-store daemon describe diff diff-files diff-index diff-tree difftool fast-export fast-import fetch fetch-pack filter-branch fmt-merge-msg for-each-ref format-patch fsck fsck-objects gc get-tar-commit-id grep hash-object help http-backend http-fetch http-push imap-send index-pack init init-db instaweb log lost-found ls-files ls-remote ls-tree mailinfo mailsplit merge merge-base merge-file merge-index merge-octopus merge-one-file merge-ours merge-recursive merge-resolve merge-subtree merge-tree mergetool mktag mktree name-rev notes p4 pack-objects pack-redundant pack-refs patch-id peek-remote prune prune-packed pull push quiltimport read-tree rebase receive-pack reflog relink remote remote-ext remote-fd remote-ftp remote-ftps remote-http remote-https remote-testgit remote-testsvn repack replace repo-config request-pull rerere reset rev-list rev-parse revert send-pack sh-i18n--envsubst shell shortlog show show-branch show-index show-ref stage stash status stripspace submodule symbolic-ref tag tar-tree unpack-file unpack-objects update-index update-ref update-server-info upload-archive upload-pack var verify-pack verify-tag web--browse whatchanged write-tree"
    local hub_builtins="alias"
    _git_mode_commands=(${(ps:\n:)${aliases}} ${(ps: :)${git_builtins}})
    for word in $_git_mode_commands; do
        alias "$word"="git $word"
    done
    alias mv="mv_git_mode"
    alias rm="rm_git_mode"
}
function unalias_git_mode()
{
    for word in $_git_mode_commands
        do unalias "$word"
    done
    unalias mv
    unalias rm
}
# toggle git mode or run a single command with git
function g()
{
    if [ "$#" -eq 0 ]; then
        if [ $GIT_MODE ]; then
            unset GIT_MODE
            unalias_git_mode
        else
            export GIT_MODE=true
            alias_git_mode
        fi
    else
        git $@
    fi
}
if [ $GIT_MODE ]; then
    alias_git_mode
fi


# TODO
# intergrate with hub
# autocomplete for huboard github commands
# cd commands for every eos repo
# version control!

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
brew analytics off 2>&1 >/dev/null

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$HOME/Library/Android/sdk/tools:$PATH"

export PATH="/usr/local/opt/openssl/bin:$PATH"
