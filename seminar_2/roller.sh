#!/bin/bash

# Simulation of 5000 die rolls with dice with increasing
# number of faces to verify the law of large numbers and
# the central limit theorem

for i in {4..10}
do
    # Diagnostic message
    echo "Working on d$i die"

    # Create a folder named after the number of faces
    # The flag -p (parent) prevent the creation of the
    # folder if it already exists
    # It is always better to enclose variables in double
    # quotes
    mkdir -p "$i"

    # Generate 5000 numbers from 1 to i and save them in
    # a file called roll.dat in the folder i
    # RECALL: random num min max
    ./random 5000 1 "$i" >> "$i""/roll.dat"


    # To calculate the exepcted value
    # RECALL: var=$(cmd) stores the output of the commnad cmd in var
    # RECALL: No spaces around equal

    # seq is the command Sequence
    # seq n produce as output the list of numbers from 1 to n
    # With awk I sum those numbers and at the END I divide by their number,
    # which in awk is NR (Number of Records) as each number is on its own line
    # So for example:
    # seq 4 ->
    # 1
    # 2
    # 3
    # 4
    # With awk I sum these number and at the END divide by 4, which is the average

    exp=$(seq "$i" | awk '{sum += $1} END {print sum/NR}')

    # Calculate average step after step
    # I use a similar trick, but now I use NR not at the END but at every
    # step, NR is the number of the current line parsed by awk and I print the
    # value at every line
    # For example if roll is
    # 2
    # 4
    # 2
    # 5
    # awk parse the first line, sum = 2 and prints 2/1
    # awk parse the second line, sum = 6 and prints 6/2
    # ...
    # I take all the output and put it into averages

    cat "$i""/roll.dat" | awk '{sum += $1; print sum/NR}' >> "$i""/averages.dat"


    # Plot
    # mean.gnuplot is a gnuplot script. The script can be run with ./mean.gnuplot if
    # it has the shabang or with gnuplot mean.gnuplot or with cat mean.gnuplot | gnuplot
    # I want to customize it before running it since I want to put the correct expected
    # value, I use sed to change two keyword I have defined in the script with the
    # correct value
    cat mean.gnuplot | sed "s|EXP|$exp|" | sed "s=NUMB=$i=" | gnuplot >> "$i""/plot.png"


    # Sleep means "do nothing" for tot seconds, it is here for technical reasons related
    # to the generation of random numbers in the naive way of my program random. It can
    # be avioded with a slightly modified version of random.c
    sleep 0.5

    # # Roll the second die and store the output
    ./random 5000 1 "$i" >> "$i""/roll2.dat"

    # Take the two files and join them in a new two columns output, then take this
    # output and feed awk with it, it sum the values of the two columns line by line
    # Then, save everything to sum.dat in the folder
    paste "$i""/roll.dat" "$i""/roll2.dat" | awk '{print $1 + $2}' >> "$i""/sum.dat"


    # Create histogram
    # To do basic maths in bash the double parentheses are required ((2 + 2))
    # This for loop count the occurences of every number from 2 to 2*i and save
    # it in a file (this is the histogram, bins and values)
    for j in $(seq 2 $((i+i)))
    do
        # The flag -w means that there must be exact match
        # I print the file sum and filter only the lines with the value of j, then
        # I count them
        occ=$(cat "$i""/sum.dat" | grep -w $j | wc -l)
        echo "$j $occ" >> "$i""/histo.dat"
    done

    # This is another way to call gnuplot
    # set style data boxes (or histogram) is a way to draw histograms
    # Fill solid means to fill the columns with a color
    gnuplot -e "set term png; set style data boxes; set style fill solid; plot '$i/histo.dat'" >> "$i""/histo.png"
done
