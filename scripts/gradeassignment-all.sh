#!/bin/bash

#
# This script takes as a parameter an assignment folder.
# Then it opens up a single editor window as a "spreadsheet" to edit everyone's grades.
#

scriptdir=`dirname "$0"`
source "$scriptdir/config.sh"

########################################
# check for valid command line params

assn="$1"
if [ -z $assn ]; then
    echo "no assignment given"
    exit
fi

########################################
# create display to edit grades

downloadAllGrades

tmpfile=$(mktemp)
curdir=$(pwd)

echo "creating grades \"spreadsheet\" ..."

echo "---------------------------------------------------------------------------------------------" >> $tmpfile
echo " $(pad csaccount 10) | $(pad name 20) | grade/total | $(pad "grader" 10) | sig | notes (\\n for newline)" >> $tmpfile
echo "---------------------------------------------------------------------------------------------" >> $tmpfile

for file in $studentinfo/*; do
    csaccount=$(basename $file)
    name=$(getStudentInfo $csaccount "name")

    cd "$tmpdir/$classname-$csaccount/$assn"
    grader=$(git log -n 1 --pretty=format:"%aN" "$f")
    signature=$(git log -n 1 --pretty=format:"%G?" "$f")
    cd "$curdir"

    gradefile="$tmpdir/$classname-$csaccount/$assn/grade"
    grade=$(getGrade "$gradefile")
    outOf=$(getOutOf "$gradefile")
    notes=$(tail -n +2 "$gradefile" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/^\\n//' | sed 's/\\n$//')

    #echo $(pad "$name" 20)
    echo " $(pad "$csaccount" 10) | $(pad "$name" 20) | $(pad "$grade" 4) / $(pad "$outOf" 4) | $(pad "$grader" 10) |  $(pad "$signature" 1)  | $notes" >> $tmpfile
    #csaccount=$(basename $file)
    #cp $tmpfile "$tmpdir/$classname-$csaccount/$assn/grade"
done

vim $tmpfile

#######################################
# covert display into final grades

tail -n +4 $tmpfile | while read -r line; do
    #echo line
    #echo "$line"
    csaccount=$(cut -d'|' -f1 <<< "$line" | sed 's/ *$//')
    grades=$(cut -d'|' -f3 <<< "$line")
    notes=$(cut -d'|' -f6 <<< "$line")

    mkdir -p "$tmpdir/$classname-$csaccount/$assn"
    echo -e "$grades\n\n$notes\n" > "$tmpdir/$classname-$csaccount/$assn/grade"
done

uploadAllGrades

echo "done."

