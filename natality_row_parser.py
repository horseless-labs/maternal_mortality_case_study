"""
OVERVIEW:
This code is meant to read unzipped files found under the heading of Mortality Multiple Cause
Files from https://www.cdc.gov/nchs/data_access/VitalStatsOnline.htm and convert them to CSV files.

REASON:
The user guide specified tape positions and field sizes, probably due to the way that data is meant
to be archived. This means that the whitespace in the files is significant, which is causing
alignment problems when loading the file into R.
"""

import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-o', type=str, required=True, help="Output filename")
args = parser.parse_args()

#original_fn = "Nat2018PublicUS.c20190509.r20190717.txt"
split_fn = "xaa"
files = [f for f in os.listdir() if f.startswith("x")]
files.sort()
line = ""
with open(split_fn) as file:
    line = file.read()

lines = line.split('\n')
del lines[-1]

def parse(row):
    age = row[74:76]
    race = row[106:107]
    bmi = row[282:286]
    return [age, race, bmi]

def parse_to_string(parsed):
    parsed_string = ""
    for i in range(len(parsed)):
        parsed_string += parsed[i] + ','
    return parsed_string[:-1]

header = "age,race,bmi\n"

test = []
for i in range(100):
    test.append(parse(lines[i]))
print(test)

if __name__ == '__main__':
    for fn in files:
        print("Working on " + fn)
        line = ""
        with open(fn) as source:
            line = source.read()
            
        lines = line.split("\n")
        del lines[-1]

        with open(args.o, 'a') as nat_file:
            if fn == "xaa":
                nat_file.write(header)
            for i in range(len(lines)):
                row = parse(lines[i])
                row = parse_to_string(row)
                nat_file.write(row + '\n')
