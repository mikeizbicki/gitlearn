#How to use Runtests

This walkthrough will familiarize you with the basic features and usages of ``runtests``.

First, start ``runtests`` as such:
```
runtests.sh bin/rshell exampleFolder/exampleTestCaseFile
```

You will see the [Vim Pane](#the-vim-pane) to the left, the [Shell Pane](#the-shell-pane) to the upper right, and the [Runtests Controller Pane](#the-runtest-controller-pane) to the lower right. 
The controller will let you know if you test case file was successfully loaded, and print out the commands available.

![ss1.PNG](img/ss1.PNG)

First we will step through one test case. Type ``n`` or ``next`` and press Enter. 
The first test case should be run, and the result printed in the Shell Pane.

![ss2.PNG](img/ss2.PNG)

Step through another test case by just pressing ``Enter``. 
This utilizes the previous command repeating feature. 
If no commands are specified, pressing ``Enter`` will run the previously entered command.

![ss3.PNG](img/ss3.PNG)

Now let's try running previous test cases. 
Type in ``p`` or ``previous`` and hit ``Enter`` as many times as you would like. 
Notice that the controller prints an error message when you attempt to run more test case commands after you reach the very first one.

![ss4.PNG](img/ss4.PNG)

Let's step forward four times (``next``). 
Be sure to take advantage of the previous command repeating feature. 
Now step through one more test case and...

You'll notice that our ``bin/rshell`` has finished executing. 

![ss5.PNG](img/ss5.PNG)

There is no need to quit and restart ``runtests`` when this is encountered. 
Simply run the next test case and ``runtests`` will restart ``bin/rshell``. 
You will also be notified that ``bin/rshell`` has been restarted.

![ss6.PNG](img/ss6.PNG)

Step through the next test case. This one backgrounds the shell.
Fortunately, ``runtests`` is able to use job control to bring back the stopped process.
Try the last case, and you will see that ``runtests`` has foregrounded the program.

![ss7.PNG](img/ss7.PNG)

Now that we have run out of test cases, let's try to run more. 
Step forward as many times as you would like to. 
The controller prints out an error notifying you that you have run out of test cases.

![ss8.PNG](img/ss8.PNG)

Now that we have finished testing the ``shell``, let's grade it. 
Grading can happen at any time while you're using ``runtests``.
First, zero out all of the grades by entering ``zero`` in the controller pane. 

![ss9.PNG](img/ss9.PNG)

Let's say the student earned full credit for the objectives on lines 5 and 7.
To enter their grades, type in:
```
f 5
f 7
```
![ss10.PNG](img/ss10.PNG)

Perhaps they received 4 points for the objective on line 6:
```
g 6 4
```
And received 11 points for the objectives on lines 8 and 9:
```
g 8 11
g 9 11
```
![ss11.PNG](img/ss11.PNG)

If you wanted to give a full grade for every objective on every line, run ``full``.

![ss12.PNG](img/ss12.PNG)

Now that we are done testing and grading ``bin/rshell``, type ``exit`` and hit ``Enter`` to stop running ``runtests``.

Congratulations. You now know the basic features of ``runtests``.


##A more detailed explanation
``runtests`` is a script that can be used by students to test their programs, and by TAs to grade student programs.

To start ``runtests``:

```
runtests.sh <program> <testcasefile>
```
where ``<program>`` is the path to the program you want to test (e.g. ``bin/rshell``, ``sh``, ``bash``, etc.) 
and <testcasefile> is the path to the file containing all of the test cases you would like to use on your shell.
These parameters are optional, as runtests will default to ``bin/rshell`` if no shell is entered, and it is possible to load a test case file within the program after the script has been run.

Three panes are created when ``runtests`` is started.  
The lower right pane is the [Runtests Controller Pane](#the-runtests-controller-pane).  
The left pane is the [Vim Pane](#the-vim-pane).  
The upper right pane is the [Shell Pane](#the-shell-pane).  

###The Runtests Controller Pane
The Runtests Controller Pane is where all controls will be entered.
If no test case file is specified when running the script, you can manually load a test case file in from this pane.
Properly formatted test case files contain each individual test case on a separate line.
(see the sample test case files in ``/exampleFolder/sampleTestCases``)

The Runtests Controller Pane is controlled with the following commands:
* ``c`` or ``clear`` clears the controller screen.
* ``e``, ``exit``, ``q``, or ``quit`` ends the program.
* ``h`` or ``help`` prints a small help message detailing the controls for ``runtests``.
  * ``h?``, ``?h``, ``?``, and ``??`` also print the help message.


###The Vim Pane
The Vim Pane contains an open grade file that is located in the current directory. 
If a grade file does not already exist, a blank file is opened, and you will have to create your own grade file.
The proper format for a line in a grade file would be 
```
[0/<# of points possible>]
```  
The grade file is automatically saved upon exit.
For examples of properly formatted grade files, see the sample grade files in ``/exampleFolder/sampleGradeFiles``.  
For more information about ways to format the grade file, see the sample grade file provided in the current directory.


The Vim Pane is controlled with the following commands:
* ``g <line> <amount>`` or ``grade <line> <amount>`` places the amount entered as a grade on the line entered.
* ``f <line>`` places a full score on the entered line. 
  * Nothing happens when these commands are entered if ``<line>`` is not a properly-formatted grade line.
* ``zero`` makes all grades 0.
* ``full`` makes all grades maximum.

###The Shell Pane
The Shell Pane is where the user input ``<program>`` (or default ``bin/rshell``) is started.

The Shell Pane is controlled with the following commands:
* ``n`` or ``next`` runs the next test case loaded from the test case file.
* ``p``, ``previous``, ``b``, or ``back`` runs the previous test case loaded from the test case file.
  * Note: Pressing enter following a ``next`` or ``previous`` command will repeat it.
* ``l <testcasefile>`` or ``load <testcasefile>`` loads ``<testcasefile>`` into ``<program>``, discarding previously loaded test cases.

