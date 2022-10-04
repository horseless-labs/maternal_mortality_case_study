#!/usr/bin/bash

# TODO: test this section out later
# Have this generate a new folder. Something like
# mkdir mortality
# cd mortality
# Then run the following stuff inside.

# Test download, extract, and rename procedure
#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2019us.zip
7z e mort2019us.zip
split -l 250000 VS19MORT.DUSMCPUB_r20210304
python3 mortality_row_parser.py -o "maternal_mortality_2019.csv"
rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2018us.zip
7z e mort2018us.zip
split -l 250000 Mort2018US.PubUse.txt
python3 mortality_row_parser.py -o "maternal_mortality_2018.csv"
rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2017us.zip
7z e mort2017us.zip
split -l 250000 VS17MORT.DUSMCPUB
python3 mortality_row_parser.py -o "maternal_mortality_2017.csv"
rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2016us.zip
7z e mort2016us.zip
split -l 250000 VS16MORT.DUSMCPUB
python3 mortality_row_parser.py -o "maternal_mortality_2016.csv"
rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2015us.zip
7z e mort2015us.zip
split -l 250000 VS15MORT.DUSMCPUB
python3 mortality_row_parser.py -o "maternal_mortality_2015.csv"
rm x*


# =========================


#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2014us.zip
#7z e mort2014us.zip
#split -l 250000 VS14MORT.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2014.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2013us.zip
#7z e mort2013us.zip
#split -l 250000 VS13MORT.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2013.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2012us.zip
#7z e mort2012us.zip
#split -l 250000 VS12MORT.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2012.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2011us.zip
#7z e mort2011us.zip
#split -l 250000 VS11MORT.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2011.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2010us.zip
#7z e mort2010us.zip
#split -l 250000 VS10MORT.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2010.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2009us.zip
#7z e mort2009us.zip
#split -l 250000 VS09MORT.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2009.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2008us.zip
#7z e mort2008us.zip
#split -l 250000 Mort2008us.dat
#python3 mortality_row_parser.py -o "maternal_mortality_2008.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2007us.zip
#7z e mort2007us.zip
#split -l 250000 VS07MORT.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2007.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2006us.zip
#7z e mort2006us.zip
#split -l 250000 MORT06.DUSMCPUB
#python3 mortality_row_parser.py -o "maternal_mortality_2006.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2005us.zip
#7z e mort2005us.zip
#split -l 250000 Mort05uspb.dat
#python3 mortality_row_parser.py -o "maternal_mortality_2005.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2004us.zip
#7z e mort2004us.zip
#split -l 250000 Mort04us.dat
#python3 mortality_row_parser.py -o "maternal_mortality_2004.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2003us.zip
#7z e mort2003us.zip
#split -l 250000 Mort03us.dat
#python3 mortality_row_parser.py -o "maternal_mortality_2003.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2002us.zip
#7z e mort2002us.zip
#split -l 250000 Mort02us.dat
#python3 mortality_row_parser.py -o "maternal_mortality_2002.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2001us.zip
#7z e mort2001us.zip
#split -l 250000 Mort01us.dat
#python3 mortality_row_parser.py -o "maternal_mortality_2001.csv"
#rm x*

#wget https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2000us.zip
#7z e mort2000us.zip
#split -l 250000 Mort00us.dat
#python3 mortality_row_parser.py -o "maternal_mortality_2000.csv"
#rm x*

