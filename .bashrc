# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias gs='git status'
#alias gc='git commit -a -m "fix"'
alias gc='git commit -a'
alias gp='git push'
alias gpp='git pull'

alias ls='ls --color=auto'
alias ll='ls -la'
alias h='history'

alias setdevmod='find . | xargs -I {} chown dev:dev {} ; find . -type d | xargs -I {} chmod 770 {} ; find . -type f | xargs -I {} chmod 660 {} ; find . | xargs -I {} chcon -R -t httpd_sys_rw_content_t {}'

alias g='grep -riI --exclude="*\.svn*"'
alias gg='grep -rI --exclude="*\.svn*"'

# find *.go files excluding .git and vendor directories
alias fgo='FindGo'

FindGo() {
  /bin/find . -type d "(" -name .git -o -name vendor ")" -prune -o -type f -name "*.go" -print0 | xargs -0 -I {} grep --color -InH $1 {}
}

# A righteous umask
umask 0027

### default editor
export EDITOR=/bin/vim

### set up a clean UTF-8 environment
### run: locale command
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

### display history command with date and time
export HISTTIMEFORMAT="%m/%d/%y %T "

### Prompt
#PS1='\e[0;35m\u@\h \w #\e[m '
if [[ $EUID -ne 0 ]]; then
  PS1='\[\e[0;33m\]\u@\h \w \$\[\e[0m\] '
else
  PS1='\[\e[0;32m\]\u@\h \w \$\[\e[0m\] '
fi

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

######
# start up ssh-agent automatically when a new bash session starts.
# Note: to add your key to the ssh-agent, run: ssh-add ~/.ssh/id_rsa
# Note: the reason why I added -n "$SSH_TTY" is because without it, sftp and/or scp may fail at connection time if you have shell initialization (.profile, .bashrc, .cshrc, etc) which produces output for non-interactive sessions. This output confuses the sftp/scp client.
# Note: refer to http://blog.ijun.org/2014/12/set-up-ssh-for-git-on-github.html
# Note: the other way: if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
######
#SSHAGENT=/usr/bin/ssh-agent
#SSHAGENTARGS="-s"
#
#if [[ -z "$SSH_AUTH_SOCK" && -n "$SSH_TTY" && -a "$SSHAGENT" && -x "$SSHAGENT" ]]; then
#  eval `$SSHAGENT $SSHAGENTARGS`
#  trap "kill $SSH_AGENT_PID" 0
#fi

### Make bash check its window size after a process completes
shopt -s checkwinsize

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

