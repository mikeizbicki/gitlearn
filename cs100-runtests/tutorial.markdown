# cs100-runtests Tutorial

## Invocation
``cs100-runtests`` accepts two parameters.
All parameters are optional.

* ``shell`` can be any shell (``bin/rshell``, ``sh``, ``bash``, ``ksh``, etc).
It defaults to ``bin/rshell``

* ``testCaseFile`` is the path to the test cases to load at startup.
It is possible to load test cases while running.
Only one file's test cases may be loaded at a time.


## What You're Seeing cs100-runtests Do
In the left pane, ``vim`` is open and editing a grade file.
The line numbers are turned on so it's easier to grade the assignment.
All other default ``vim`` settings are preserved.
``vim`` is manipulated by the controller instance in the bottom right of the ``tmux`` session.
Because only one pane can be in focus at a time in ``tmux``, the controller will not interfere with edits *when* you make them.
The controller will, however, discard your changes if you neglect to save them before running another grade-related command.

In the upper-right pane ``shell`` is run inside of ``sh``.
``sh``'s children are checked every time a command is sent to the ``shell`` pane.
If ``sh`` doesn't have any children, ``Control-C`` is sent to the ``shell`` pane to get rid of any lingering text (possibly from user's interference).
Then, ``shell`` is typed and run.
If ``sh`` has no children at this point, you are notified of the failure and sending test cases becomes disabled.

The ``tmux`` session starts focused on the controller pane.
This pane runs a script that repeatedly asks for a command.
It supports commands to change the grade file or run test cases in the upper-right pane.
To run test cases, it uses ``tmux``'s ``send-keys`` ablility.
Test cases in the file are sent character by character as if the user had typed them.
To edit the grade file, ``cs100-runtests`` works behind the scenes then forces vim to update by sending ``:e!<Return>`` (which loads the grade file from the disk).
If you want to run test cases yourself, click on the ``shell`` pane and run as many as you'd like.
If you want to edit the grade file yourself, select the ``vim`` pane and edit it.
Just don't forget to save your changes before going back to the controller!

## Control
This is a short walkthrough for ``cs100-runtests`` that will cover some of the basic features.
For a breakdown of all control options, see the [README](./README.md)

Run ``cs100-runtests`` like the following.
```
./cs100-runtests bin/rshell exampleFolder/exampleTestCaseFile
```
It should be run in the ``cs100-runtests`` folder of the ``gitlearn`` repository.

Start ``cs100-runtests``.
You'll notice the grade file is open on the left, an example ``rshell`` is open in the upper-right, and the selected pane is the controller in the bottom-right.
The controller starts by letting you know if your test case file was successfully loaded and printing the commands available to you.

Step through two test cases by pressing ``Enter`` twice.
This takes advantage of previous command repeating feature.
If you don't specify a command to run, the previous controller command is rerun.
Now run the previous test cases by typing ``previous`` and hitting ``Enter``.
Do this three times.
The controller does bounds checking so you don't accidentally run more test cases than the amount that exist.

Step forward four times (``next``).
Space is preserved by the controller, and the text is sent very quickly.

Step through one more case, and...
Oh no!
Our ``bin/rshell`` has finished!
Run the next test case.
The controller realized that our ``shell`` had finished, so it was restarted.
Also, you were notified that the ``shell`` needed to be restarted.

Step throught the next case.

This one stops the shell. How is it handled? Try the last case to find out.

The controller attempts to bring the stopped process back using job control.

Trying to run more cases yields and error:
there are no more test cases.
To stop running ``cs100-runtests`` type ``exit`` and hit ``Enter``.

## Test Case Format
Whatever you type in a test case file (newlines and all) will be sent to the ``shell``.
See the [``exampleFolder/``](./exampleFolder) for example test case files.

## Gradefile Format
The gradefile format is very lenient.
The first line is always the total score (or nothing) out of the total possible points for a given assignment.
After that, anything can go in the file.
The only lines that are parsed for grades follow this format:

``[<value>/<value>]``

Anything can go before the ``[`` and after the ``]``.
Also, any amount of whitespace (excluding newlines) can go before or after the ``<value>``.
``<value>`` is made up of numbers and an optional period, and always starts with a number.

