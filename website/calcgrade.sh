#!/bin/bash

#
# This script takes a github account as a parameter.  It then displays all the
# grades associated with the account
#

if [ -z "$GITLEARN_CLASSDIR" ]; then
    scriptdir=`dirname "$0"`
else
    scriptdir="$GITLEARN_CLASSDIR/gitlearn/scripts"
fi

source "$scriptdir/config.sh"

#echo "\$scriptdir is $scriptdir"

########################################
# check for valid command line params


if [ -z $1 ]; then
    user="$USER"
else
    user=$(simplifycsaccount "$1")
fi
echo "user=$user" >&2
echo "\$1=$1" >&2

#######################################
# check if instructor keys are installed

installInstructorKeys

#######################################
# calculate stats

studentname=$(getStudentInfo $user name)

if [ -z $studentname ]; then
    echo "<h2>Grades</h2>"
    echo "<p>$red Invalid user name.$endcolor</p>"
    echo "<form action=\"grades\" method=\"GET\">"
    echo "Please enter a valid cs account:<br>"
    echo "<input type=\"text\" name=\"user\"><br>"
    echo "<input type=\"submit\" value=\"Enter\">"
    echo "</form>"
    exit
fi

echo "<h2>Grade for $studentname ($user)</h2>"
downloadGrades "$user"

totalgrade=$(totalGrade "$user")
runningtotaloutof=$(runningTotalOutOf "$user")
totaloutof=$(totalOutOf "$user")

runningpercent=`bc <<< "scale=2; 100 * $totalgrade / $runningtotaloutof"`
percent=`bc <<< "scale=2; 100 * $totalgrade/$totaloutof"`

#######################################
# display everything

echo "<br>"
echo "<table>"
echo "<tr><th>Grade</th><th>Assignment</th><th>Grader</th></tr>"

cd "$tmpdir/$classname-$user"
for f in `find . -name grade | sort`; do
    echo "<tr>"
    dir=`dirname $f`
    assn=$(pad "$(basename $dir)" 30)
    grader=$(git log -n 1 --pretty=format:"%aN" "$f")
    signature=$(git log -n 1 --pretty=format:"%G?" "$f")

    grade="---"
    if isGraded "$f"; then
        grade=$(getGrade "$f")
    fi
    outof=$(getOutOf "$f")

    if [ ! $grade = "---" ]; then
        cmd="scale=2; 100*$grade/$outof"
        assnPercent=$(bc <<< "$cmd" 2> /dev/null)
        echo "<td>"
        colorPercent "$assnPercent"
        printf "%3s / %3s" "$grade" "$outof"
        printf "$endcolor</td>"
        echo "<td>"
        colorPercent "$assnPercent"
        printf "$assn$endcolor</td><td>$grader "
        if [ "$signature" = "G" ]; then
            printf "$green[signed]$endcolor"
        else
            if [ "$signature" = "U" ]; then
                printf "$cyn[signed but untrusted]$endcolor"
            else
                printf "$red[bad signature]$endcolor"
            fi
        fi
        echo "</td>"
    else
        printf "<td>%3s / %3s</td>" "$grade" "$outof"
        printf "<td>$assn</td><td>---</td>"
    fi
    echo "</tr>"
done

echo "</table>"
echo "<br>"

printf "running total = %4s / %4s = " $totalgrade $runningtotaloutof
dispPercent "$runningpercent"
printf "  "
percentToLetter "$runningpercent"
echo
printf "overall total = %4s / %4s = " $totalgrade $totaloutof
dispPercent "$percent"
printf "  "
percentToLetter "$percent"
echo
echo
