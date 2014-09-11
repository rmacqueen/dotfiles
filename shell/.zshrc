# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_SCRIPT_DIR=$(dirname $(readlink -f ${HOME}/.zshrc))

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

export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$HOME/.bin

source $ZSH/oh-my-zsh.sh

# for gnome jhbuild
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$PATH:$HOME/.local/bin"
fi

#git uses sublime
export EDITOR="subl -w"

# resume downloads if dc'd
alias wget='wget -c'
alias chrome='google-chrome'
alias files='xdg-open .'
alias term='gnome-terminal'
alias gdb='gdb -q -ex r'

# some more ls aliases
alias l='ls'
alias la='ls -A'
alias ll='ls -Alh'
alias lt='ls -Alhtr'

# easy zsh move
autoload -U zmv
alias mmv='noglob zmv -W'

alias sl='sl'

# sudo uses aliases
# alias sudo='sudo '

function say() {
    if which cowsay >/dev/null; then
        cowfile=`ls /usr/share/cowsay/cows | sort -R | tail -1`
        cowsay -f $cowfile "$@"
        # cowsay -f head-in -e "><" "$@" | cowthink -n -f dragon-and-cow -e "OO" | cowthink -n -s -f bong
    else
        echo $@
    fi
}

alias fortune='wget -O - -q http://www.iheartquotes.com/api/v1/random\?max_characters=300 | sed "s/&quot;/\"/g" | sed -e "s!http[s]\?://\S*!!g"'
alias quote='say `fortune`'
alias bored='while :; do quote && sleep 4; done'
alias lol='say lol'
alias yo='say yo-yo'
alias hey='say oh hai'
alias fart='say pffttbbttbt'

# apt crap
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get update && sudo apt-get dist-upgrade'
alias search='apt-cache search'

# more dots
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias size='command du -sh'

alias shutdown='quote && sudo shutdown -h now'
alias reboot='sudo shutdown -r now'
alias logout='gnome-session-quit'

alias zedit='subl ~/.zshrc'
alias zup='source ~/.zshrc'

# cd commands for the stuff i'm currently working on
alias sdk='cd ~/checkout/eos-sdk'
alias prog='cd ~/checkout/eos-programming'
alias build='cd ~/checkout/eos-obs-build'
alias photo='cd ~/checkout/eos-photos'
alias gtk='cd ~/checkout/gtk'
alias theme='cd ~/checkout/eos-theme'
alias shell='cd ~/checkout/eos-shell'
alias ekn='cd ~/checkout/eos-knowledge-engine'
alias ekl='cd ~/checkout/eos-knowledge-lib'
alias ekb='cd ~/checkout/eos-knowledge-db-build'
alias eka='cd ~/checkout/eos-knowledge-apps'
alias xb='cd ~/checkout/xapian-bridge'
alias xglib='cd ~/checkout/xapian-glib'

# ssh connections
alias knowledge-build='ssh devs@knowledge-build'
alias jenkins='ssh ci -L 8080:localhost:8080'
alias elastic='ssh elastic@10.0.1.16 -L 9200:localhost:9200'
alias markin='ssh endlesss@endless.kollective.it -L 9200:localhost:9200'
alias aws='ssh -i ~/AWS_keys/rory_key.pem ubuntu@54.88.124.154'

# debian
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"

# gsettings
alias draw-desktop="gsettings set org.gnome.desktop.background show-desktop-icons"
alias caps-is-control="gsettings set org.gnome.desktop.input-sources xkb-options \"['ctrl:nocaps']\""

# sublime projects
alias update-sublime-projects="python ${ZSH_SCRIPT_DIR}/update_projects.py"

function burn-image() {
    sudo true # grab sudo rights first or its hard to see under the curl output
    curl $1 | tee ~/images/$(basename $1) | gunzip -c | sudo dd of=/dev/mmcblk0 bs=8M conv=sparse oflag=sync
}

function deb-extract() {
    mkdir -p $2
    dpkg-deb -x $1 $2
    dpkg-deb --control $1 $2/DEBIAN
}

function deb-build() {
    dpkg -b $1 $2
}

# run command for different directories
function r() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        say "No git no dice"
        return
    fi
    local repodir=$(git rev-parse --show-toplevel)
    local reponame="$(basename $repodir)"
    if [ "$reponame" = "eos-knowledge-apps" ]; then
        jhbuild run eos-thrones
    elif [ "$reponame" = "eos-knowledge-lib" ]; then
        jhbuild run gjs $repodir/tests/smoke-tests/homePageBSmokeTest.js
    elif [ "$reponame" = "eos-resume" ]; then
        jhbuild run gjs $repodir/resume-app.js
    else
        jhbuild run $reponame
    fi
}
alias m='jhbuild make'
alias mr='m && r'

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

function remote-debug()
{
    gnome_session=$(command pgrep -u $USER gnome-session)
    eval export $(sed 's/\o000/\n/g;' < /proc/$gnome_session/environ | command grep DISPLAY)
    eval export $(sed 's/\o000/\n/g;' < /proc/$gnome_session/environ | command grep XAUTHORITY)
    eval export $(sed 's/\o000/\n/g;' < /proc/$gnome_session/environ | command grep DBUS_SESSION_BUS_ADDRESS)
}

function stop-ekn()
{
    sudo systemctl stop xapian-bridge.service
    sudo systemctl stop xapian-bridge.socket
    sudo systemctl stop eos-knowledge-engine.service
    sudo systemctl stop eos-knowledge-engine.socket
}

function jhbuild-knowledge-engine()
{
    sudo systemctl stop xapian-bridge.service
    sudo systemctl stop xapian-bridge.socket
    jhbuild run xapian-bridge &
    sudo systemctl stop eos-knowledge-engine.service
    sudo systemctl stop eos-knowledge-engine.socket
    jhbuild run node $HOME/checkout/eos-knowledge-engine/server.js
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

function j()
{
    if [[ -z $UNDER_JHBUILD ]]; then
        jhbuild shell
    else
        exit
    fi
}

# dir shortcuts
c() { cd ~/checkout/$1; }
_c() { _files -W ~/checkout -/; }
compdef _c c

i() { cd ~/install/$1; }
_i() { _files -W ~/install -/; }
compdef _i i

h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# TODO
# intergrate with hub
# autocomplete for huboard github commands
# cd commands for every eos repo
# version control!
