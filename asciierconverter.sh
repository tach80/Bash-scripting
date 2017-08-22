#!/bin/bash

# Let's make it the other way: let's give it an ASCII number
# sequence, or a full file to "translate". I'm still working
# on newlines characters, but this is functional.


EXIT="/home/$USER/translation"
CHAR= # This var is needed empty.


echo "Hello, and welcome to this ASCII converter."
echo "What do you want to translate? A string or a full file?"
echo "1) A string."
echo "2) Content of a text file."

echo -n "Please, select option by number: "
read ENTRY

# Option 1: a string.
if [ $ENTRY -eq 1 ]; then
	echo -n "Ok, tell me your string: "
	read STRING
# Option 2: translate the content of a file.
elif [ $ENTRY -eq 2 ]; then
	echo -n "Ok, tell me the full route to the file: "
	read ROUTE
	STRING=$(<$ROUTE)
fi


# First, a bit of parsing. Delete the new line characters.
STRING=$(echo "$STRING" | tr -d '\n')

# Now, and while there are characters on the variable...
for ((i=0; i<${#STRING}; i++)); do
	# If the character is not a space, add it to the var.
	if [ "${STRING:$i:1}" != " " ]; then
		CHAR="$CHAR${STRING:$i:1}"
	# If it is a space, try the translation.
	else
		# As exit format, ASCII numbers (should) have three digits.
		# Those on the left are zeroes that must be removed. So, how
		# do I know I have zeroes on the left? And, to make it better,
		# what happens to space characters, defined as "000" in ASCII?

		# This trick's not elegant, but it works.
		if [ "$CHAR" == "000" ]; then
			CHAR="032"
		fi

		# An auxiliary control variable. I had to define it.
		CONTROL=${#CHAR}
		for ((j=1; j<$CONTROL; j++)); do
		# This takes the j-th character from the variable.
			if [ "${CHAR:0:1}" == "0" ]; then 
				# This removes the first character from the variable.
				CHAR=${CHAR#?}
			else
				# If there are no more left-zeroes, break the for loop.
				CHAR=$CHAR
				break
			fi
		done
		# Once the variable is parsed, translate it.
		if [ "$CHAR" == "32" ]; then
			sed -i 's/$/& /' $EXIT
		else
			echo -n $(printf "\x$(printf %x $CHAR)") >> $EXIT
		fi
		CHAR="" # Emptying the variable (required).
	fi
done

# Add a new line to the end. To make it elegant.
echo "" >> $EXIT
