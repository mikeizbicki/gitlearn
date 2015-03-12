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

    grade="---"
    if isGraded "$f"; then
        grade=$(getGrade "$f")
    fi
    outof=$(getOutOf "$f")

    if [ ! $grade = "---" ]; then
        cmd="scale=2; 100*$grade/$outof"
        assnPercent=$(bc <<< "$cmd" 2> /dev/null)
        #colorPercent "$assnPercent"
        printf "    %3s / %3s    " "$grade" "$outof"
        #printf "$endcolor|"
        printf "|"
        #colorPercent "$assnPercent"
        #printf "  $assn$endcolor |  $grader "
        printf "  $assn |  $grader "
        if [ "$signature" = "G" ]; then
            #printf "$green[signed]$endcolor"
            printf "[signed]"
        else
            if [ "$signature" = "U" ]; then
                #printf "$cyn[signed but untrusted]$endcolor"
                printf "[signed but untrusted]"
            else
                printf "[bad signature]"
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
