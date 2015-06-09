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

########################################
# check for valid command line params


if [ -z $1 ]; then
    user="$USER"
else
    user=$(simplifycsaccount "$1")
fi
echo "user=$user"
echo "\$1=$1"

#######################################
# check if instructor keys are installed

installInstructorKeys

#######################################
# calculate stats

echo "finding grade for $(getStudentInfo $user name) ($user)"
downloadGrades "$user"

totalgrade=$(totalGrade "$user")
runningtotaloutof=$(runningTotalOutOf "$user")
totaloutof=$(totalOutOf "$user")

runningpercent=`bc <<< "scale=2; 100 * $totalgrade / $runningtotaloutof"`
percent=`bc <<< "scale=2; 100 * $totalgrade/$totaloutof"`

#######################################
# display everything

echo
echo "==============================================================================="
echo "    grade        |  assignment                     |  grader"
echo "==============================================================================="

cd "$tmpdir/$classname-$user"
for f in `find . -name grade | sort`; do
    dir=`dirname $f`
    assn=$(pad "$(basename $dir)" 30)
    grader=$(git log -n 1 --pretty=format:"%aN" "$f")
    signature=$(git log -n 1 --pretty=format:"%G?" "$f")
    gradee=$(git log -1 --pretty=format:"%s" "$f" |
             grep -Eio '\<[a-z]{5}[0-9]{3}\>')

    grade="---"
    if isGraded "$f"; then
        grade=$(getGrade "$f")
    fi
    outof=$(getOutOf "$f")

    if [ ! $grade = "---" ]; then
        cmd="scale=2; 100*$grade/$outof"
        assnPercent=$(bc <<< "$cmd" 2> /dev/null)
        colorPercent "$assnPercent"
        printf "    %3s / %3s    " "$grade" "$outof"
        printf "$endcolor|"
        colorPercent "$assnPercent"
        printf "  $assn$endcolor |  $grader "
        if [ "$signature" = "G" ]; then
            printf "$green[signed]$endcolor"
        else
            if [ "$signature" = "U" ]; then
                # this means that our commits are signed but untrusted
                # this isn't perfect cryptographically, but it should be good enough for us
                # displaying a different message is confusing for students
                #printf "$cyn[signed but untrusted]$endcolor"
                printf "$green[signed]$endcolor"
            else
                printf "$red[bad signature]$endcolor"
            fi
        fi
        # check whether the cs account on the commit message matches the cs
        # account of the student
        if [ -z "$gradee" ]; then
            echo
            warning "no cs account name found in commit message"
        else
            if [ ! "$user" = "$gradee" ]; then
                echo
                warning "student's cs account name does not match cs account name
in commit message: \"$gradee\""
            fi
        fi
        echo
    else
        printf "    %3s / %3s    " "$grade" "$outof"
        printf "|  $assn |  ---\n"
    fi
done

echo "==============================================================================="
echo

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
