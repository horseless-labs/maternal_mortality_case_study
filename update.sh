#!/usr/bin/bash
# The original case study file
FILE="/home/mireles/obsidian_notes/horseless/Maternal Mortality Case Study.md"

# Where it needs to be copied in the repo's file
DESTINATION="/home/mireles/horseless/maternal_mortality/mortality"

cp "${FILE}" "${DESTINATION}"
mv 'Maternal Mortality Case Study.md' log.txt

USER="horseless-labs"
PAT=`head "/home/mireles/Documents/pat.txt"`

expect - <<_END_EXPECT
	spawn git push -u origin main
	expect "User*"
	send "$USER\r"
	expect "Pass*"
	send "$PAT\r"
	set timeout -1
	expect eof
_END_EXPECT
