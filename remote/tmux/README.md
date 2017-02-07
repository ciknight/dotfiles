Getting Started
===============
- [Fix scrolling in iTerm2](http://dan.carley.co/blog/2013/01/11/tmux-scrollback-with-iterm2/)

Sessions
========
* `Prefix d` Detaches from the session, leaving the session running in the background.

Windows
=======
* `Prefix c` Creates a new window from within an existing tmux session. Shortcut for new-window.
* `Prefix &` Closes the current window after prompting for confirmation.”
* `Prefix %` Divides the current window in half vertically.
* `Prefix "` Divides the current window in half horizontally.
* `swap-window -s 3 -t 1` swaps windows 1 and 3

Panes
=====
* `Prefix o` Cycles through open panes.
* `Prefix x` Closes the current pane after prompting for confirmation.
* `Prefix Space` Cycles through the various pane layouts.”
* `PREFIX : resize-pane -UDLR 20` moves current pane up/down/left/right 20 cells.

