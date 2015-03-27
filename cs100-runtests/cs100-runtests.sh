#!/bin/sh

# sets up a tmux session for cs100-runtests

# accepts one parameter (optional) for starter
# test case file

# script settings
# TODO: sanity check
gradeFile=grade
# always assume we're grading in an rshell repo
#rshell=bin/rshell

# from gitlearn: find gitlearn classdir
if [ -z "$GITLEARN_CLASSDIR" ]; then
  scriptdir=`dirname "$0"`
else
  scriptdir="$GITLEARN_CLASSDIR/gitlearn/scripts"
fi

controller="$scriptdir/../cs100-runtests/runtests-controller.sh"

# unique session and window name
export session="$USER-cs100-runtests"
export window="$USER-$PWD-cs100-runtests"

# make a copy of a global grade file, if one exists
#if [ ! -z "$CS100_RUNTESTS_GRADE_TEMPLATE" ]
#then
  #cp $CS100_RUNTESTS_GRADE_TEMPLATE $gradeFile
#fi

# todo: add cppcheck, valgind, checksyscalls, 
#echo >>$gradeFile
#echo "cppcheck output:" >>$gradeFile
#cppcheck src/ &>>$gradeFile
#echo >>$gradeFile
#echo "valgrind output:" >>$gradeFile
#cppcheck src/ &>>$gradeFile
#echo >>$gradeFile


# make new session or attach previous if one already exists opens vim on the
# grade file
tmux -2 new-session -d -n $window -s $session "vim grade" || {
  tmux kill-session -t $session
  tmux -2 new-session -d -n $window -s $session "vim $gradeFile" || {
    echo "There was a serious problem" >&2; exit 1
  }
}


### session settings
# Mouse support
tmux set-option -t $session mouse-select-pane on
tmux set-option -t $session mouse-resize-pane on
tmux set-option -t $session mouse-select-window on
# Set the default terminal mode to 256color mode
tmux set-option -t $session default-terminal "screen-256color"
# new panes start in current directory
tmux set-option -t $session default-path "$PWD"
# don't stop server when there are no attached clients
tmux set-option -t $session exit-unattached off
# if the session becomes unattached, don't kill it
tmux set-option -t $session destroy-unattached off

### window settings
# mouse support for window
tmux set-window-option -t $session:$window mode-mouse on
tmux set-window-option -t $session:$window allow-rename off

# split current window vertically, ends up as the top right pane
tmux split-window -h "sh"
# after pane is created, it is selected
# calling list-window and printing pane_pid will give the pid of sh
# running in that pane
upperRightPID=`tmux list-pane -t $session -F '#{pane_pid}' | tail -1`
#echo upperRightPID:$upperRightPID
# split right pane horizontally, ends up as the bottom right pane
tmux split-window -v -t 1 "$controller $upperRightPID $gradeFile $1"


# show linenumbers in vim (pane 0)
tmux send-keys -t 0 ":set number" C-m C-l
# open rshell in upper right
#tmux send-keys -t 1 "valgrind --leak-check=full bin/rshell" C-m
tmux send-keys -t 1 "bin/rshell" C-m
# open controller in bottom right
#tmux send-keys -t 2 "$controller $upperRightPID $gradeFile" C-m

tmux -2 attach -t $session >/dev/null



