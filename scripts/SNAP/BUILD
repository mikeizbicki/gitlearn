#!/bin/bash

rm total.csv

selectyear="error"

./start/infomake $selectyear

#execute searches using usernames in info resource
function bulk {
	for name in $(cat < ./start/info);
	do
	    echo $name | sed 's/,.*//' >> total${selectyear}.csv
	    ./grademake $(echo $name | sed 's/,.*//') >> total${selectyear}.csv
		
		#(./resourcep) use corresponding username for the following large 
	    ./githubp/getem $(echo $name | sed 's/,/~~@~~/' | sed 's/.*~~@~~//' | sed 's/,.*//')
	    ./githubp/makem $(echo $name | sed 's/,/~~@~~/' | sed 's/.*~~@~~//' | sed 's/,.*//') >> total${selectyear}.csv

	    ./redditp/getem $(echo $name | sed 's/,/~~@~~/4' | sed 's/.*~~@~~//' | sed 's/,.*//')
	    ./redditp/makem $(echo $name | sed 's/,/~~@~~/4' | sed 's/.*~~@~~//' | sed 's/,.*//') >> total${selectyear}.csv
	     echo ?~!~endl~!~? | cat >> total${selectyear}.csv
	done

	cat < total${selectyear}.csv | sed ':a;N;$!ba;s/\n//g' | cat > total${selectyear}.csv
	cat < total${selectyear}.csv | sed 's/?~!~endl~!~?/\n/g' | cat > total${selectyear}.csv
}

if [ $# = 0 ]; then
	echo "2015winter" > totals
	bulk
else
	rm totals
	COUNTER=0
	while [ $counter -le $# ]; do
		selectyear=$(echo $i)
		echo $selectyear
		bulk
		let COUNTER=COUNTER+1
	done
fi

rm scrip
for total in $(cat totals);
do
	mkdir ${total}pics
	for col in {3..32}; 
	do
		echo "set datafile separator \",\"" > ${total}pics/scrip
		echo "f1(x) = a1*x + b1" >> ${total}pics/scrip
		echo "fit f1(x) '"$total"' using "$col":2 via a1, b1" >> ${total}pics/scrip
		echo "plot '"$total"' using "$col":2, f1(x)" >> ${total}pics/scrip

		echo "set term png" >> ${total}pics/scrip
		echo "set output \"pics/"$col"vs2.png\"" >> ${total}pics/scrip
		echo "replot" >> s${total}pics/scrip
		echo "set term x11" >> ${total}pics/scrip

		gnuplot < scrip
	done
done
