#! /bin/bash
#
# This script is the container entry script used to setup cli
# interface and trigger qtcreator.

tmux new-session -d -n "opencog-development";
echo evaluating startup script... ;\
# tmux set-option -g set-remain-on-exit on ;\
tmux bind-key R respawn-window ;\
tmux setw -g mode-mouse on ;\
tmux set -g mouse-select-pane on ;\
tmux split-window -d -v -p 25 ;\
tmux send -t 1 "source /home/opencog/miniconda3/bin/activate opencog-dev"
tmux send -t 1 Enter
tmux send -t 1 atom
tmux send -t 1 Enter
tmux attach
