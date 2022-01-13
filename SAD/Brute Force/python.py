# Author: Adrianas Vitys
# How to use this script:
# 1. Write a password the script will try to crack in the password constraint
# 2. Write a the maximum characters the script will try to crack in the max_characters constraint

# Import packages
import string # string.printable contains all characters
import itertools # it helps to make bucles
import os # it helps to clear the console

# Declare constant with the password
password = 'abccccs'
# Max characters of the password we wanna crack, if we put 4 then the max length will be 3
max_characters=2

# Make a function that clear our console
def clearConsole():
    command = 'clear'
    if os.name in ('nt', 'dos'):  # If Machine is running on Windows, use cls
        command = 'cls'
    os.system(command)

# Clear the console
clearConsole()

flag=0
for password_length in range(0, max_characters): # In range we have to put the length of the password we wanna crack
    for password_cracker in itertools.product(string.printable, repeat=password_length):
        password_cracker = ''.join(password_cracker)
        print(password_cracker)
        
        if password == password_cracker:
            print("Got it! The password is: " + password_cracker)
            flag=1
            
            break;
    if flag==1:
        break;
        
if flag==0:
    print(f"The password you'r trying to crack is over {max_characters} characters, it's so difficult! :D")