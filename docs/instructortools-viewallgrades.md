# viewing student grades

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
