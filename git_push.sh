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
