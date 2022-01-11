# If we wanna do a loop for example:
    for i in $(cat usuarios.txt)
# and usuarios.txt has multiple lines like
# adrian1:general:El primer general
# adrian2:general:El segundo general
# when the loop reach the space it make a new variable ($i) so we have to say to bash that the loop
# just has to make a new $i when it reach a newline, not a space

# make newlines the only separator
IFS=$'\n'