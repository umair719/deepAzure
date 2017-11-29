# Problem 2.
# Write a Python function that, when passed a single number as its argument,
# will return a tuple containing that number, square of that number and sin() of that number.
# Place this function in a loop going through a sequence of integers
# starting with 0 and ending with 9. Pass each integer to the function and
# print results to an output cell of your jupyter notebook.

import math

def main(number):
    return (number, number*number, math.sin(number))

for n in range(0,10):
    print(main(n))

# Define input and output file
r_file = open('read.txt', 'r')
w_file = open('write.txt', 'w')
# Read each line from r_file and run main method.
# Save output in new line of a the w_file
for n in r_file:
    w_file.write(str((main(int(n)))) + '\n')

# Print output from output file
w_file = open('write.txt', 'r')
for l in w_file:
    print(l)


