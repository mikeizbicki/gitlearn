#!/bin/bash

#
# This script takes a github account as a parameter.  It then displays all the
# grades associated with the account
#

source "$webroot/config.sh"

########################################
# check for valid command line params


user=$(simplifycsaccount "$1")

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
    echo "<p class=\"error\"><b>You are not enrolled in this class. Please follow the instructions in lab0 to enroll.</b></p>"
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
echo "<table id=\"grade\">"
echo "<tr><th>Grade</th><th>Assignment</th><th>Grader</th></tr>"

giturl=$(getStudentInfo $user giturl | sed -e 's/\.git$//')

cd "$tmpdir/$classname-$user"
for f in `find . -name grade | sort`; do
    githubgradeloc=$(cut -d'.' -f2 <<< "$f")
    githubassignloc=$(echo $githubgradeloc | sed -e 's/\/grade$//' )
    githubgradeloc=$giturl/blob/$gradesbranch$githubgradeloc
    githubassignloc=$giturl/tree/$gradesbranch$githubassignloc
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
        linkcolor=$(colorPercentLink "$assnPercent")
        echo "<td><a href=\"$githubgradeloc\" class=\"$linkcolor\">"
        printf "%3s / %3s" "$grade" "$outof"
        printf "</a></td>"
        linkcolor=$(colorPercentLink "$assnPercent")
        echo "<td><a href=\"$githubassignloc\" class=\"$linkcolor\">"
        printf "$assn</a></td><td>$grader "
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
        printf "<td><a href=\"$githubgradeloc\" class=\"blacklink\">"
        printf "%3s / %3s</a></td>" "$grade" "$outof"
        printf "<td><a href=\"$githubassignloc\" class=\"blacklink\">$assn</a></td>"
        printf "<td>---</td>"
    fi
    echo "</tr>"
done

echo "</table>"
echo "<br>"

echo "<table>"
echo "<tr>"
printf "<td class=\"grade\">running total</td><td class=\"grade\"> = </td><td class=\"grade\">%4s</td><td class=\"grade\">/</td><td class=\"grade\">%4s</td><td class=\"grade\">=</td><td class=\"grade\">" $totalgrade $runningtotaloutof
dispPercent "$runningpercent"
printf "</td><td class=\"grade\">"
percentToLetter "$runningpercent"
echo "</td></tr><tr>"
printf "<td class=\"grade\">overall total</td><td class=\"grade\"> = </td><td class=\"grade\">%4s</td><td class=\"grade\">/</td><td class=\"grade\">%4s</td><td class=\"grade\">=</td><td class=\"grade\">" $totalgrade $totaloutof
dispPercent "$percent"
printf "</td><td class=\"grade\">"
percentToLetter "$percent"
echo "</td></tr>"
echo "</table>"
