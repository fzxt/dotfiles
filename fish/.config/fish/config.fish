alias tmux "export TERM=xterm-256color; command tmux -2"
alias vim "nvim"
alias git "hub"

# Colorize terminal
alias ls='ls -G'
alias ll='ls -lG'
export GOPATH="/Users/fzxt/Code/Go/"
export GREP_OPTIONS="--color"
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
rvm default

function start_tmux
    if type tmux > /dev/null
        #if not inside a tmux session, and if no session is started, start a new session
        if test -z "$TMUX" ; and test -z $TERMINAL_CONTEXT
            tmux -2 attach; or tmux -2 new-session
        end
    end
end

start_tmux
