#Setup gitlearn for your class

This is a general overview on tools that instructors would use regularly. This tutorial will cover the basics of instructor tool scripts, but more specifically, how to setup your class with **gitlearn**.

###Setup

1. Create a repository on Github with your classname.

2. Clone a local copy of your current repository to your local machine.

3. Clone a copy of **gitlearn** into your local repository 
 ```
 $ git clone https://github.com/mikeizbicki/gitlearn  
 $ echo "export PATH=$(pwd)/gitlearn/scripts:"'$PATH' >> $HOME/.bashrc 
 ```
4. Setup directories for class folders
 ```
 $ mkdir assignments
 $ mkdir people
 $ cd people
 $ mkdir students
 $ mkdir instructors
 
 ```
5. Commit all changes to your repository
 ```
 $ git add --all
 $ git commit -m "Intial Classroom commit" 
 $ git push origin
 ```
 
###Adding Instructors

After setting up and installing your classroom repository, it is recommended that you add the instructor keys so that student grades can be verified for validity.
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
Make sure you have your instructors github accounts setup as contributor for the repository.

**IMPORTANT:**
Make sure you generate the key on the computer that you will grade on.

###Create Assignments
After setting up your classroom repository, you can make assignments store grades for the class.
For example, you can run the following commands in the `assignments' directory.  
```
$ mkdir assn1
$ cd assn1
$ echo /100 >> grade
$ touch README.md
```
**NOTE:** 
+ You can add subfolders into the `assignments` directory for different type of assignments and categories.  
+ You can change the grade total to any other integer value.  

###Grade Assignments
The `gradeassignment-all.sh` script lets an instructor grade an assignment for the whole class.
Before execution, the script requires the assignment path as a parameter of which assignment to grade.
In order to grade an assignment, you will run the following code:
```
$ gradeassignment-all.sh assignments/assn1/
```
The script will pull a local copy of each student's repository and check for the existence of the assignments.
It will open up a vim editor with a spreadsheet to edit student grades:

![gradeassignment.png](img/gradeassignment.png)

**NOTE:**
The "spreadsheet" will show if the assignment was previously graded and signed.
After saving the score on the editor, the script will check for your instructor key to verify and sign the commit.
The updated grades will then get pushed to each student repository.

####grading individual assignments
The `gradeassignment-individual.sh` script allows an instructor to grade an assignment for a specific student, so running it requires two parameters: 
```
$ gradeassignment-individual.sh githubaccount assignmentfolder
```
Similar to the `gradeassignment-all.sh` script, it will pull a local copy of the student's repository and check for the assignments.
This feature might be used more often as it lets the grader provide feedback for the student.
It will open up a blank page in the vim editor for grading.
The script will automatically push the grades to the student repository.

###View Grades
In order for instructors to view all student grades, you would run:
```
$ instructortools-viewallgrades.sh
```
This script will pull local copy of each student repository and displays names and overall scores in a table.
For greater detail on an individual student, use [calcgrade.sh](grades.md).

![viewallgrades.png](img/viewallgrades.png)

**NOTE:**
If you use it the first time, the script will need to clone a local repository of each student.  
In addition, you may have to run the script again as it might not get the correct grade values the first time.


###Additional tools/resources

[`runtests.md`](runtests.md) - semi-automatic grading script  
[`grades.md`](grades.md) - detailed explaintion on how grades work
