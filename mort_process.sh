#!/usr/bin/bash

# TODO: test this section out later
# Have this generate a new folder. Something like
# mkdir mortality
# cd mortality
# Then run the following stuff inside.

# Test download, extract, and rename procedure
#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2019us.zip
#7z e mort2019us.zip
#split -l 250000 VS19MORT.DUSMCPUB_r20210304
#python3 mortality_row_parser.py -o "maternal_mortality_2019.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2018us.zip
#7z e mort2018us.zip
#split -l 250000 Mort2018US.PubUse.txt
#python3 mortality_row_parser.py -o "maternal_mortality_2018.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2017us.zip
#7z e mort2017us.zip
#split -l 250000 VS17MORT.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2017.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2016us.zip
#7z e mort2016us.zip
#split -l 250000 VS16MORT.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2016.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2015us.zip
#7z e mort2015us.zip
#split -l 250000 VS15MORT.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2015.csv"
#rm x*

wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2014us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2013us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2012us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2011us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2010us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2009us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2008us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2007us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2006us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2005us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2004us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2003us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2002us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2001us.zip
wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2000us.zip
