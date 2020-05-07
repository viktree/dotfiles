# $Header: /admin/cvsroot/cdf/local.share/cdf/skel/.bashrc,v 1.8 2009/07/23 17:47:32 ange Exp $
# Default .bashrc file for CSC students whose login shell is Bash.
# This file is executed whenever a new shell is started (eg. when a
# new (xterm) window is created).

# A "PATH" is a list of directories in which the system looks for commands.
# This path puts a "bin" subdirectory in your home directory first, so that
# you can have your own versions of commands override the default versions,
# if you want. The other directories include the X-Window programs
# (in /local/bin/X11), the CDF-specific (local) programs (in /local/bin),
# programs that originally came from the University of California at Berkeley
# (/usr/ucb), and other general programs (/usr/bin).
#
# The dot (.) at the end of the path allows commands in the current directory
# to be run. Make sure this is at the end of your path.
#
# Feel free to change these, but make sure that you have /usr/ucb, /usr/bin, 
# /bin, and /local/bin in your path, and that /local/bin preceeds the other 
# three.

export PATH=$HOME/bin/${OSTYPE}:$HOME/bin:/local/bin/X11:/local/bin:/bin:/usr/bin:.
export PATH=/u/csc209h/winter/pub/bin:$PATH

export PATH=/usr/local/cuda-10.0/bin/:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64/:$LD_LIBRARY_PATH

# Interactive shell prompt.
# PS1='\h:\w\$ '

alias qprint='print -Pp2210a'

# set useful variables. EDITOR is your default line editor, VISUAL is
# the default visual (full-screen) editor. Other good choices for VISUAL
# could be /usr/bin/jove or /usr/bin/emacs.
export EDITOR=/bin/ed
export VISUAL=/bin/vi

# make it harder to wipe out files
set -o noclobber

# eliminate core dumps
ulimit -c 0

# checks for mail every five minutes
MAIL=/var/spool/mail/$USER
MAILCHECK=300

# some aliases to force an "are you sure?" if action might result in data loss.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# alias to allow use of "p" as a pager. Eg. "ls /local/bin | p"
alias p='more -s -d'

umask 077

# Change the window title of X terminals 
case $TERM in
        xterm*|rxvt|eterm)
                PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
                ;;
        screen)
                PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
                ;;
esac

alias nvim="~/.nvim.appimage"
