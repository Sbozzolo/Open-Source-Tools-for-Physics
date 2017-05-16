#!/usr/bin/env python3

# Basic numeric framework
import numpy as np

# For plotting
import matplotlib.pyplot as plt

# For statistical functinons
from scipy.stats import norm

# For generating random number
import random

# For reading the number of faces from command line
import sys

# Check if the argument has been given
# This is the most naive possibility
# Argparse is much more refined
# Example (with argparse)
# import argparse
# parser = argparse.ArgumentParser()
# parser.add_argument("-f", "--faces", type = int, required = True,
                    # help = "Number of faces")
# args = parser.parse_args()
# faces = args.faces

if (len(sys.argv) < 2):
    print("You must tell me how many faces the dice have!")
    print("Usage:", sys.argv[0], "<faces>")
    sys.exit(1)

# Better "cast" to int because I will use randint
faces = int(sys.argv[1])

# How many times I have to roll the die
N = 10000

# Simulate two dice N times
die1 = np.random.randint(low = 1, high = faces + 1, size = N)
die2 = np.random.randint(low = 1, high = faces + 1, size = N)

# With this NumPy's universal function I compute the sum
sum = die1 + die2
type(die1)

# Compute mean and standard deviation
print("Mean die1: {:.3f}, Mean die2: {:.3f}".format(np.mean(die1), np.mean(die2)))
print("Standard Dev die1: {:.3f}, Standard Dev die2: {:.3f}".format(np.std(die1), np.std(die2)))

# The law of large numbers

# Compute expected value by arithmetic mean
exp_value = np.average([x for x in range(1, faces + 1)])

# Compute the average value step by step
# This is a list comprehension, I compute a sliced sublist
# of die1 for increasing values of i
averages = [np.average(die1[:i]) for i in range(1,N)]

# I define a figure so that I can save it easier on a pdf
f = plt.figure()

# Divide the figure in subplots
# subplot(numrows, numcols, numfig)
# I want two plots side a side, so two columns
# This is the first one (numfig = 1)
plt.subplot(1,2,1)
plt.title("Law of Large Numbers")
avr_val, = plt.plot(averages, label='Average value')
# This is an inelegant way to plot an horizontal line, it is
# a plot from the point (0, exp_value) to (N, exp_value)
exp_val, = plt.plot((0,N), (exp_value, exp_value), label='Expected value', linewidth = 3)

# Add legend
plt.legend(handles=[exp_val, avr_val])

# This is the second one (numfig = 2)
plt.subplot(1,2,2)

# Plot the histogram of the sum generating bins and normalizing
plt.hist(sum, bins = 'auto', normed = True)
plt.title("Central Limit Theorem")

# Fit the data with a gaussian and extract mean value and standard deviation
(mu, sigma) = norm.fit(sum)
print("Mu = {:.3f}, Sigma = {:.3f}".format(mu, sigma))

# Plot a gaussian
x = np.linspace(1, faces*2, 100)

# NumPy's ufunc are vectorialized (optimized)
y = np.power(np.e, -0.5*(x-mu)**2 /(sigma**2) )/np.sqrt(2*np.pi*sigma*sigma)

plt.plot(x, y, linewidth = 3)

# bbox_inches remove white borders
f.savefig("theorems.pdf", bbox_inches='tight')
plt.show()
