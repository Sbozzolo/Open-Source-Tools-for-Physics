# Print on a png
set term pngcairo

# Set x range
set xrange [0:5000]

# Set title
set title "The law of large number with NUMB faces"

# I will change EXP and NUMB with the correct values
plot EXP linewidth 5 linecolor rgb 'red' title 'Expected value', \
    'NUMB/averages.dat' linewidth 3 linecolor rgb 'blue' with lines title 'Averages'
