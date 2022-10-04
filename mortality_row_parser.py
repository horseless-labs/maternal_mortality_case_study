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

#original_fn = "VS20MORT.DUSMCPUB_r20220105"
split_fn = "xaa"
files = [f for f in os.listdir() if f.startswith("x")]
files.sort()
line = ""
with open(split_fn) as file:
    line = file.read()

lines = line.split('\n')
del lines[-1]

def parse(row):
    resident_status = row[19]
    education = row[62]
    month_of_death = row[64:66]
    age = row[70:73]
    death_loc = row[82]
    marital_status = row[83]
    underlying = row[145:148]
    num_conditions = row[162:164]
    conditions = row[343:443]
    # These need to be broken into sequences five characters long.
    # Conditions relating to maternal mortality have a 1 at the end instead of a blank
    icd10_codes = [conditions[i:i+5] + ',' for i in range(0, len(conditions), 5)]
    code_string = ""
    for i in icd10_codes:
        code_string += i

    race = row[444:446]
    hisp_orig = row[483:486]
    hisp_orig_race = row[487]
    occupation_code = row[805:809]
    industry_code = row[811:815]
    return [resident_status, education, month_of_death, age, death_loc, marital_status,
            underlying, code_string, race, hisp_orig, hisp_orig_race,
            occupation_code, industry_code]

def parsed_to_string(parsed):
    parsed_string = ""
    for i in range(len(parsed)):
        parsed_string += parsed[i]
        # Adds commas between each item, but leaves it off at the end
        if i < 12 and i != 7:
            parsed_string += ", "
        # The code string is generated in a way that another comma would be redundant
        if i == 7:
            parsed_string += " "
    return parsed_string

# Checks whether the underlying cause of death is related to maternal mortality
def check_maternal(line):
    if line[7].startswith("O") or line[7] == "A34":
        # Codes O96 and O97 are excluded from the original analysis. The reasons are complicated, but
        # essentially maternal mortality after 42 days is counted differently.
        if line[7].startswith("O96") or line[7].startswith("O97"):
            return False
        else:
            return True
    else:
        return False

header = "res_status, education, month, age, death_loc, marital_status, underlying, code1, code2, code3, code4, code5, code6, code7, code8, code9, code10, code11, code12, code13, code14, code15, code16, code17, code18, code19, code20, race, hisp_orig, hisp_orig_race, occupation_code, industry_code\n"

test = parse(lines[0])
test = parsed_to_string(test)
print(test)
print(test[9])

"""
with open("mm.csv", "w+") as ueg:
    ueg.write(header)
    #ueg.write(test + '\n')
    for i in range(len(lines)):
        line = parse(lines[i])
        if check_maternal(line) == True:
            line = parsed_to_string(line)
            ueg.write(line + '\n')
"""

if __name__ == '__main__':
    for fn in files:
        print("Working on " + fn)
        line = ""
        with open(fn) as source:
            line = source.read()
            
        lines = line.split("\n")
        del lines[-1]

        with open(args.o, 'a') as mm:
            if fn == "xaa":
                mm.write(header)
            for i in range(len(lines)):
                row = parse(lines[i])
                if check_maternal(row) == True:
                    row = parsed_to_string(row)
                    mm.write(row + '\n')
