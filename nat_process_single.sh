#!/bin/bash

while getopts 'ay:' OPTION; do
	case "$OPTION" in
		a)
			for i in `seq 2003 2019`
			do
				echo Nat${i}us.zip
				OUTFILE="$(7z -slt l Nat${i}us.zip | grep -oP "(?<=Path = ).+" | tail -n +2)"
				7z e Nat${i}us.zip
				split -l 250000 ${OUTFILE}
				python3 natality_row_parser.py -o "natality_${i}.csv"
				rm x*
				rm ${OUTFILE}
			done
			;;
		y)
			YEAR=$OPTARG
			OUTFILE="$(7z -slt l Nat${YEAR}us.zip | grep -oP "(?<=Path = ).+" | tail -n +2)"
			echo "Selected ${YEAR}"
			echo ${OUTFILE}
			7z e Nat${YEAR}us.zip
			split -l 250000 ${OUTFILE}
			python3 natality_row_parser.py -o "natality_${YEAR}.csv"
			rm x*
			rm ${OUTFILE}
			;;
		?)
			echo "script usage: $(basename \$0) [-a] [-y year]"
			exit 1
			;;
	esac
done
shift "$((OPTIND -1))"
