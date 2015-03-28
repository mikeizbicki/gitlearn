# cs100-runtests

## About
``cs100-runtests`` is a script designed to assist testing ``rshell``.
This ``README`` lists the features of ``cs100-runtests``.
For a tutorial, checkout [``tutorial.markdown``](./tutorial.markdown).


## Usage
```
cs100-runtests [shell [testCaseFile]]
```

## Features
<!-- This section details how to use the runtests controller. -->

When ``cs100-runtests`` is started, three panes are created in the terminal.
On the left, ``vim`` edits the ``grade`` file in the current directory.
In the upper-right, the ``shell`` is started.
On the bottom-right, the runtests controller awaits commands.
The runtests controller is used to interact with the ``vim`` and ``shell`` panes.
If necessary, the other panes can be controlled manually by clicking on them to bring them into focus.


#### Controlling the Shell Pane
* ``n`` or ``next`` goes to the next loaded test case.
* ``p`` or ``previous`` or ``b`` or ``back`` goes to the previous loaded test case.
* ``l`` or ``load`` and then a filename loads a test case file.
The previously loaded test cases are discarded.

  ###### Special Features:
  * If ``shell`` isn't running in the shell pane, it is restarted.
    * this allows for multiple ``exit`` commands in the same test file.
    * the grader is notified when ``shell`` is restarted.
  * If ``shell`` is suspended, the controller will attempt to make it continue.
  For this feature to work properly, ``sh`` must have job control enabled.

#### Controlling the Vim Pane
* ``g`` or ``grade`` followed by ``<line>`` ``<amt>`` puts ``<amt>`` as a grade on ``<line>``. If ``<line>`` isn't a properly-formatted grade line, nothing happens
* ``f`` ``<line>`` puts a full score on ``<line>``. If ``<line>`` isn't a properly-formatted grade line, nothing happens.
* ``zero`` makes all scores ``0``
* ``full`` makes all scores maximum

  ###### Special Features:
  * After every update, the total is adjusted

#### Controlling the Runtests Controller Pane
* ``h`` or ``help`` or ``h?`` or ``?h`` or ``?`` or ``??`` print a small help message.
* ``c`` or ``clear`` clears the controller screen
* ``e`` or ``exit`` or ``q`` or ``quit`` terminate the ``tmux`` session (closes everything)

  ###### Special Features
  * Upon receiving ``SIGINT``, ``SIGQUIT``, ``SIGTERM``, or ``SIGTSTP``, the controller terminates the session
  * The session terminates when ``read`` exits with an error.
    ``read`` will exit with an error value when the user types ``Control+D`` after nothing else when prompted for a command.
  * Focus can be shifted from the controller to either the vim instance or the shell instance for manual manipulation by using the mouse.
  * Pressing enter without entering a command runs the previous command (useful for speeding through test cases)
  * Displays the previous command in the prompt

