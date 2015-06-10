#Setup gitlearn for your class

This is a general overview on tools that an instructors would use for class. This tutorial will cover the basics of instructor tool scripts, but more specifically, how to setup your class with **gitlearn**.

##Table of Contents
[1. Setup](#setup)  
[2. Adding Instructors](#addkey)  
[3. Grading](#grading)  
[4. View Grades](#view)  
[5. Additional tools/resources](#resource)  

<a name="setup"/>
###Setup

**Follow the instructions to  setup a class repository and install gitlearn:**

Create a repository on Github with your classname.

Clone a local copy of your current repository to your local machine.

Create the following directories inside the respository folder:
- create an `assignments` directory
- create an `people` directory  
--inside include a `students`  directory  
--inside include a `instructors`  directory  

***Note:***
You can add subfolders into the `assignments` directory for different type of assignments and categories.

Clone the `gitlearn `respository into your class folder.

Add the `scripts` folder to your `PATH` using the following commands:
```
$ git clone https://github.com/mikeizbicki/gitlearn
$ export PATH=$(pwd)/gitlearn/scripts:$PATH
```
In order for your `PATH` to remain across sessions you need to update your `~/.bashrc` (or similar):
```
$ echo "export PATH=$(pwd)/gitlearn/scripts:"'$PATH' >> $HOME/.bashrc
```
Push all commits to your github repository.

<a name="addkey"/>
###Adding Instructors

After setting up gitlearn onto your local repository along with your class files,
it is recommended to add the instructor keys so that student grades can be verified for validity.
On the home directory of the class repository, run:
```
$ instructortools-addgrader.sh
```

![addgrader.png](img/addgrader.png)

**NOTE:**
It will take time for your system to generate a strong RSA key that will be automatically push to the github repository.
Expect somewhere around 15~ minutes (depending on your current hardware).

**NOTE:**
The key will automatically push itself onto the main repository.
Make sure you have your instructors setup on the contributor setting for the repository.

**IMPORTANT:**
Make sure you generate the key on the computer that you will grade on.



<a name="grading"/>
###Grade Assignments
The `gradeassignment-all.sh` script lets an instructor grade an assignment for the whole class.
Before execution, the script requires the parameter of which assignment to grade.
In order to grade an assignment you will run:
```
$ gradeassignment-all.sh assignmentfolder
```
It will pull a local copy of each student's repository and check for the assignments.
It will open up a vim editor with a table setup as follow with each students name and id:

![gradeassignment.png](img/gradeassignment.png)

The updated grades will get pushed to each respected repository.

####grading individual assignments
The `gradeassignment-individual.sh` script allows an instructor to grade an assignment for a specific student, so it required to be ran with two parameters:
```
$ gradeassignment-individual.sh githubaccount assignmentfolder
```
It will pull a local copy of the student's repository and check for the assignments.
This feature might be used more often as it would allow the grader to input long feedback for the student.
It will open up a blank page in the vim editor for grading.
After the grader is done grading, the script will automatically push the grades to the respected repository.



<a name="view"/>
###View Grades
In order for instructors to view all the student grades, you would run:
```
$ instructortools-viewallgrades.sh
```
This script displays registered student names in a table and their overall score.
For greater detail on an individual student, use [calcgrade.sh](grades.md).
```
================================================================================
 cs account | name                | pnts /  run ( tot) | grade run  | grade tot 
================================================================================
xxx001      |Edward Snowden       | 400/500 (705)      |  80.00 B   | 60.00 D
xxx002      |Steve Jobs           | 100/500 (705)      |  20.00 F   | 0.00 F
xxx003      |Bill Gates           | 235/500 (705)      |  47.65 F   | 27.65 F
xxx004      |Linus Torvalds       | 515/500 (705)      |  103.00 A  | 83.00 B
...

```
**NOTE:**
If you use it the first time, the script will need to clone a local repository of each student.  
In addition, you may have to run the script twice as it may not get the correct values the first time.



<a name="resource"/>
###Additional tools/resources

[`runtests.md`](runtests.md) - semi-automatic grading script
