alias tmux "export TERM=xterm-256color; command tmux -2"
alias vim "nvim"
alias git "hub"
alias code="code-insiders"

# Colorize terminal
alias ls='ls -G'
alias ll='ls -lG'

alias NVIM_RC='nvim ~/.config/nvim/init.vim'
alias FISH_RC='nvim ~/.config/fish/config.fish'

alias ds_store='find . -name ".DS_Store" -delete'

export GOPATH="/Users/fzxt/Code/Go/"
export GREP_OPTIONS="--color"
# for rust
export PATH="$HOME/.cargo/bin:$PATH"
export TERM="xterm-256color"

set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
rvm default

function start_tmux
    if type tmux > /dev/null
        # if not inside a tmux session, and if no session is started, start a new session
        if test -z "$TMUX" ; and test -z $TERMINAL_CONTEXT
            tmux -2 attach; or tmux -2 new-session
        end
    end
end

# start_tmux
