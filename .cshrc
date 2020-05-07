# $Header: /admin/cvsroot/cdf/local.share/cdf/skel/.cshrc,v 1.8 2009/07/23 17:55:28 ange Exp $
# Default .cshrc file for CSC students. This file is executed whenever a
# new shell is started (eg. when a new (xterm) window is created).

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

setenv PATH $HOME/bin/${OSTYPE}:$HOME/bin:/local/bin/X11:/local/bin:/bin:/usr/bin:.

set prompt="%M:%~%% "

# set useful variables. EDITOR is your default line editor, VISUAL is
# the default visual (full-screen) editor. Other good choices for VISUAL
# could be /usr/bin/jove or /usr/bin/emacs.
setenv EDITOR /bin/ed
setenv VISUAL /bin/vi

# make it harder to wipe out files
set noclobber

# eliminate core dumps
limit coredumpsize 0k

# checks for mail every five minutes
set mail=(300 /var/spool/mail/$USER)

# set the number of previous commands remembered. 
set history=50

# some aliases to force an "are you sure?" if action might result in data loss.
alias rm rm -i
alias cp cp -i
alias mv mv -i

# alias to allow use of "p" as a pager. Eg. "ls /local/bin | p"
alias p more -s -d

umask 077

eval `direnv hook tcsh`
