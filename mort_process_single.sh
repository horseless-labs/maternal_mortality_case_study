#!/bin/bash

while getopts 'ay:' OPTION; do
	case "$OPTION" in
		a)
			echo "Processes all available years"
			echo "Not implemented yet :("
			echo "But it will be :)"
			;;
		y)
			YEAR=$OPTARG
			OUTFILE="$(7z -slt l mort${YEAR}us.zip | grep -oP "(?<=Path = ).+" | tail -n +2)"
			echo "Selected ${YEAR}"
			echo ${OUTFILE}
			7z e mort${YEAR}us.zip
			split -l 250000 ${OUTFILE}
			python3 mortality_row_parser.py -o "cardiac_mortality_${YEAR}.csv" -c I
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
