# Explanation
This program is meant to find the greatest common divisor of two numbers using parity, shifts, comparisons, and subtraction.

The greatest common division is the largest number that **both** numbers can be divided by.

The basic algorithm is as follows:

while both numbers are even
	divide both by 2
	remember one common factor of 2

while a != b
	if a is even: a /= 2
	else if b is even: b /= 2
	else:
		subtract the smaller odd number from the larger

answer a * remembered_power_of_two
