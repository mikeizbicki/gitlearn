#!/bin/bash

upperRightPID=$1
gradeFile=$2
starterTestCaseFile=$3
tempFile=$(mktemp)
declare -a commandArray

# function to print its parameters in red
# does not insert a newline after printing
red() {
  echo -en "\033[1;31m"
  echo -n "$@"
  echo -en "\033[0m"
}


cleanupAndQuit() {
  rm -rf $tempFile
  tmux kill-session -t $session
}

trap cleanupAndQuit SIGINT SIGQUIT SIGTERM SIGTSTP


readTestCases() {
  if [ -z "$1" ]
  then
    return
  elif [ ! -f $1 ]
  then
    red "$1"; echo ": file not found"
    return
  fi

  index=0
  commandArray=()

  while read line
  do
    if [ ${#line} -gt 0 ]
    then
      commandArray[$index]="$line"
      index=`bc <<< "$index + 1"`
    fi
  done <$1

  unset index
}



rshellUp() {
  if [ `ps --ppid $upperRightPID | wc -l` -le 1 ]
  then
    red "rshell is not running. starting a new instance..."; echo
    #tmux send-keys -t 1 'valgrind --leak-check=full bin/rshell' C-m
    tmux send-keys -t 1 C-c
    tmux send-keys -t 1 'bin/rshell' C-m
    return 0
  elif [ ! -z `ps --ppid $upperRightPID -o state | grep T` ]
  then
    red "rshell is stopped. attempting to restart..."; echo
    tmux send-keys -t 1 C-c
    tmux send-keys -t 1 fg C-m
  fi

}



executeCommand() {
  rshellUp
  for i in $(seq 0 `bc <<< "${#1} - 1"`)
  do
    # send one char
    # assumes rshell is in pane 1
    tmux send-keys -t 1 "${1:$i:1}"
  done
  tmux send-keys -t 1 C-m
}


fullGrade() {
  line=$1
  outOf=$(cat $gradeFile | head -$line | tail -1 |
          grep -o '/[[:blank:]]*[[:digit:]][[:digit:].]*[[:blank:]]*\]' |
          grep -o '[[:digit:].]*')
  #echo line:$line
  #echo amt:$amt
  changeGrade $line $outOf
  #sed "$line"'s/\[.*\//\['$outOf'\//' $gradeFile >$tempFile &&
  #cp $tempFile $gradeFile
}


changeGrade() {
  line=$1
  amt=$2
  if [[ $line =~ ^[0-9]+$ ]] # line is made of only numbers
  then
    if [[ $amt =~ ^[0-9][0-9.]*$ ]] # amt is made of only numbers and '.'
    then
      sed "$line"'s/\[.*\//\['$amt'\//' $gradeFile >$tempFile &&
      cp $tempFile $gradeFile
    else
      red $amt; echo ": improper amount"
    fi
  else
    red $line; echo ": improper line number"
  fi
}


parseGradeFile() {
  grep -o '\[[[:blank:]]*[[:digit:].]*[[:blank:]]*/[[:blank:]]*[[:digit:]][[:digit:].]*[[:blank:]]*\]' |
  grep -o '[[:blank:][:digit:]/.]*'
}


updateTotal() {
  earned=0
  total=0
  for val in $(cat $gradeFile | parseGradeFile | cut -d/ -f1)
  do
    earned=`bc <<< "$earned + $val"`
  done

  for val in $(cat $gradeFile | parseGradeFile | cut -d/ -f2)
  do
    total=`bc <<< "$total + $val"`
  done

  sed '1s/.*/'"$earned \\/ $total"'/' $gradeFile >$tempFile &&
  cp $tempFile $gradeFile
}


updateVim() {
  tmux send-keys -t 0 ':e!' C-m 'gg' C-l
}


prevCommand="n"
commandIndex=0


controller() {
  cmd=$1
  line=$2
  file=$2
  amt=$3
  if [ ! -z "$cmd" ]
  then
    prevCommand="$@"
  fi
  case "$cmd" in
    "") # same as previous
      controller $prevCommand
      ;;
    "h")
      ;&
    "h?")
      ;&
    "?h")
      ;&
    "?")
      ;&
    "help")
      echo -e "Valid commands:"
      echo -e "n\t\t - next test case"
      echo -e "p\t\t - previous test case"
      echo -e "\t\t   + b is an alias of p"
      echo

      echo -e "g <line> <amt>\t - assign <amt> points to <line> in grade file"
      echo -e "f <line>\t - assign full points to <line> in grade file"
      echo -e "zero\t\t - make all grades [ 0 / total ]"
      echo -e "full\t\t - make all grades [ total / total ]"
      echo
      
      echo -e "h\t\t - print this message"
      echo -e "c\t\t - clear the screen"
      echo -e "e\t\t - exit"
      echo -e "\t\t   + q is an alias of e"
      ;;
    "c")
      ;&
    "clear")
      clear
      ;;
    "l") # load testcase
      ;&
    "load") # load testcase
      if [[ -f $file ]]
      then
        readTestCases $file
        commandIndex=0
        echo "successfully loaded"
      else
        red $file; echo "is not a file";
      fi
      ;;
    "n") # next one command
      ;&
    "next") # next one command
      if [ $commandIndex -lt ${#commandArray[@]} ]
      then
        executeCommand "${commandArray[$commandIndex]}"
        commandIndex=`bc <<< "$commandIndex + 1"`
      else
        red "no more test cases"; echo
      fi
      ;;
    "b") # back one command
      ;&
    "back")
      ;&
    "p")
      ;&
    "previous")
      if [ $commandIndex -gt 0 ]
      then
        commandIndex=`bc <<< "$commandIndex - 1"`
        executeCommand "${commandArray[$commandIndex]}"
      else
        red "no previous test case"; echo
      fi
      ;;
    "g")
      ;&
    "grade") # grade <line> <amt>
      changeGrade $line $amt
      updateTotal
      updateVim
      ;;
    "f") # full grade <line>
      fullGrade $line
      updateTotal
      updateVim
      ;;
    "zero") # zero all grades
      for zeroLine in `seq 1 $(cat $gradeFile | wc -l)`
      do
        changeGrade $zeroLine 0
      done
      updateTotal
      updateVim
      ;;
    "full") # max all grades
      for fullLine in `seq 1 $(cat $gradeFile | wc -l)`
      do
        fullGrade $fullLine >/dev/null
      done
      updateTotal
      updateVim
      ;;
    "q")
      ;&
    "quit")
      ;&
    "e")
      ;&
    "exit")
      cleanupAndQuit
      ;;
    *)
      red $cmd
      echo ": invalid command (try h?)"
  esac
}

readTestCases $starterTestCaseFile

while read -p "command [$prevCommand]: " args
do
  controller $args
done

cleanupAndQuit


