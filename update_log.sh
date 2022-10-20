#!/usr/bin/bash
# The original case study file
FILE="/home/mireles/obsidian_notes/horseless/Maternal Mortality Case Study.md"

# Where it needs to be copied in the repo's file
DESTINATION="/home/mireles/horseless/maternal_mortality/mortality"

cp "${FILE}" "${DESTINATION}"
mv 'Maternal Mortality Case Study.md' log.md
