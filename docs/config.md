#configuring your classroom

Gitlearn is configurable by running:  
```
$ config.sh
```
The following variable names can be be changed if needed,
but by default, the script is configured as followed:
```
#######################################
# configuration (can be modified)

# the github project name
classname="ucr-cs100"

# tmp folder for all student repos
tmpdir="$HOME/.gitlearn/$classname"

# branch of student git repository that stores the grades
gradesbranch="grades"

# folder containing instructor pgp keys
instructorinfo="people/instructors"

# folder containing student information
studentinfo="people/students"

#######################################
```
#variables
  
| Variable       | Purpose                                                                                |
|----------------|----------------------------------------------------------------------------------------|
| classname      | Controls the name of the class. Recommended to be same as repo name. 		  | 	
| tmpdir         | Contains file path that stores the student repositories on local machines and servers. |
| gradesbranch   | Stores the name of where the grades are stored					  |
| instructorinfo | Stores the path for where intructor keys are held.					  |
| studentinfo    | Stores the path for where student information is held.				  |	

