# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias gc='git ci -a -m "up"'
alias gp='git push'

alias ls='ls --color=auto'
alias ll='ls -la'
alias h='history'

### set up a clean UTF-8 environment
### run: locale command
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

### display history command with date and time
export HISTTIMEFORMAT="%m/%d/%y %T "

### Prompt
#PS1='\e[0;35m\u@\h \w #\e[m '
PS1='\[\e[0;35m\]\u@\h \w \$\[\e[0m\] '

#######
# Note: on Ubuntu, xterm-256color may be in different place, try this:
# find /lib/terminfo /usr/share/terminfo -name "*256*"
# Note: tmux respects screen-256color
#######
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi

### ssh-agent
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"

if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
  eval `$SSHAGENT $SSHAGENTARGS`
  trap "kill $SSH_AGENT_PID" 0
fi

### Make bash check its window size after a process completes
shopt -s checkwinsize

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
