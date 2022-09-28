library(tidyverse)
library(dplyr)
library(ggplot2)
library(scales)
library(naniar)
library(stringr)
# library(Dict)

# Figure out best practices for the directory stuff before production
setwd("/home/mireles/horseless/maternal_mortality/")

mort2019 <- read_csv("mortality/maternal_mortality_2019.csv")
mort2018 <- read_csv("mortality/maternal_mortality_2018.csv")
mort2017 <- read_csv("mortality/maternal_mortality_2017.csv")
mort2016 <- read_csv("mortality/maternal_mortality_2016.csv")
mort2015 <- read_csv("mortality/maternal_mortality_2015.csv")

# Make necessary type conversions in dataset
# TODO(?): make all of the codes the same type, as they become boolean
# instead of char at code14, for some reason.
# TODO: change "code 10" to "code10"
factor_dataset <- function(mort, year=0) {
  mort$res_status <- as.factor(mort$res_status)
  mort$education <- as.factor(mort$education)
  mort$age <- as.numeric(mort$age)
  mort$death_loc <- as.factor(mort$death_loc)
  mort$marital_status <- as.factor(mort$marital_status)
  mort$race <- as.factor(mort$race)
  mort$hisp_orig <- as.factor(mort$hisp_orig)
  mort$hisp_orig_race <- as.factor(mort$hisp_orig_race)
  
  # Removing age codes with 999; not specified
  mort$age[mort$age == 999] <- NA
  
  # Change "code 10" to "code10"
  mort <- rename(mort, code10="code 10")
  
  if(year != 0) {
    mort <- mort %>% add_column(year=year, .after="month")
    mort$year <- as.factor(mort$year)
  }
  
  return(mort)
}

mort2019 <- factor_dataset(mort2019, 2019)
mort2018 <- factor_dataset(mort2018, 2018)
mort2017 <- factor_dataset(mort2017, 2017)
mort2016 <- factor_dataset(mort2016, 2016)
mort2015 <- factor_dataset(mort2015, 2015)

# Make one general dataset for comparison
mort_combined <- bind_rows(mort2019, mort2018, mort2017, mort2016, mort2015)

# View(mort2019)
# View(mort2018)
# View(mort2017)
# View(mort2016)
# View(mort2015)
# View(mort_combined)

# Get a list of all codes applicable to a patient in one row i.e.,
# remove all NA values
get_codes <- function(row, include_underlying=FALSE) {
  underlying <- which(colnames(row)=="underlying")
  first_code <- which(colnames(row)=="code1")
  last_code <- which(colnames(row)=="code20")
  
  if (include_underlying == TRUE) {
    codes <- row[c(underlying:last_code)]
  } else {
    codes <- row[c(first_code:last_code)]
  }

  a_codes <- list()
  for (c in codes) {
    if (is.na(c)) {
      return(a_codes)
    } else {
      a_codes <- append(a_codes, c)
    }
  }
  return(a_codes)
}

get_all_codes <- function(mort) {
  codes <- c()
  for (row in 1:nrow(mort)) {
    codes <- append(codes, get_codes(mort[row,]))
  }
  return(codes)
}

# Take a mortality tibble as an argument.
# Returns a version of the table that includes a column for the number of
# conditions, not counting the underlying condition
add_num_conditions <- function(mort) {
  # num_conditions_col <- list(num_conditions = numeric())
  num_conditions_col <- c()
  for (row in 1:nrow(mort)) {
    codes <- get_codes(mort[row,], include_underlying=FALSE)
    num_conditions_col <- append(num_conditions_col, length(codes))
  }
  
  mort <- mort %>% add_column(num_conditions=num_conditions_col, .before="underlying")
  return(mort)
}

# Group various codes according to the structure given by
# https://www.icd10data.com/ICD10CM/Codes/O00-O9A

# These are regex strings that will partition each one.
code_buckets <- c("O0[0-8]", "O09", "O1[0-6]", "O2[0-9]", "O[3|4][0-8]|O39",
                  "O[6][0-9]|O7[0-7]", "O8[0-2]", "O8[5-9]|O9[0-2]",
                  "O9[4-9]|O9A")
group_codes <- function(mort, code) {
  bucket <- mort[0,]
  for (row in 1:nrow(mort)) {
    underlying <- mort[row, "underlying"]
    if (!is.na(str_extract(underlying, code))) {
      bucket <- bucket %>% add_row(mort[row,])
    }
  }
  
  return(bucket)
}

# Testing with 2019 data
# Pregnancy with abortive outcome
abortive <- group_codes(mort2019, code_buckets[1])
# Supervision of high-risk pregnancy
high_risk <- group_codes(mort2019, code_buckets[2])
# Edema, proteinuria, and hypertensive 
eph <- group_codes(mort2019, code_buckets[3])
# Other maternal disorders predominantly related to pregnancy
preg <- group_codes(mort2019, code_buckets[4])
# Maternal care related to the fetus and amniotic cavity and possible delivery problems
fetal <- group_codes(mort2019, code_buckets[5])
# Complications of labor and delivery
comp <- group_codes(mort2019, code_buckets[6])
# Encounter for delivery
encounter <- group_codes(mort2019, code_buckets[7])
# Complications predominantly related to the puerperium
puerperium <- group_codes(mort2019, code_buckets[8])
# Other obstetric conditions, not elsewhere classified
other <- group_codes(mort2019, code_buckets[9])

groups <- lst(abortive, high_risk, eph, preg, fetal, comp, encounter, puerperium, other)
# View(groups)

# Search for arbitrary secondary codes
# Takes a mort tibble and a regular expression representing a bucket of codes
# as arguments.
# Returns a tibble of all rows that contain matching codes.
search_secondary_codes <- function(mort, search_code) {
  bucket <- mort[0,]
  
  for (row in 1:nrow(mort)) {
    codes <- get_codes(mort[row,])
    for (code in codes) {
      if (!is.na(str_extract(code, search_code))) {
        bucket <- bucket %>% add_row(mort[row,])
      }
    }
  }

  return(bucket)
}

# Empty for convoluted coding reasons.
encounter <- search_secondary_codes(mort2019, code_buckets[7])
high_risk <- search_secondary_codes(mort2019, code_buckets[2])

# Expanding on preg and other
# Add a column for the number of conditions
preg <- add_num_conditions(preg)
other <- add_num_conditions(other)
# View(preg)
# View(other)

# Small descriptive statistical summary of both
summary(preg$num_conditions)
summary(other$num_conditions)

# Checking to see conditions in other are secondary codes in preg
# and vice versa.
# These being the largest groups, it needs to be determined if the conditions
# accompanying either are at all related.
# Expanded upon in the codes_in_others function
other_in_preg <- search_secondary_codes(preg, code_buckets[9])
preg_in_other <- search_secondary_codes(other, code_buckets[4])
# View(other_in_preg)
# View(preg_in_other)

other_codes <- get_all_codes(other)
unique_other_codes <- unique(other_codes)
print(length(other_codes))
print(length(unique_other_codes))

preg_codes <- get_all_codes(preg)
unique_preg_codes <- unique(preg_codes)
print(length(preg_codes))
print(length(unique_preg_codes))

# Return a dictionary of secondary codes in a given dataset
# Keys are the code in question, values are the number of times
# it occurred in the dataset.
code_dict <- function(codes) {
  dictionary <- c()
  for (code in codes) {
    dictionary[code] <- 0
  }
  
  for (code in codes) {
    dictionary[code] <- as.numeric(dictionary[code]) + 1
  }
  
  return(dictionary)
}

# Return a dictionary by value in descending order
sort_dict <- function(dictionary) {
  dictionary <- dictionary[order(-unlist(dictionary))]
  return(dictionary)
}

other_codes_dict <- code_dict(other_codes)
other_codes_dict <- sort_dict(other_codes_dict)
print(other_codes_dict)

preg_codes <- get_all_codes(preg)
preg_codes_dict <- code_dict(preg_codes)
preg_codes_dict <- sort_dict(preg_codes_dict)
print(preg_codes_dict)

i <- intersect(unique_preg_codes, unique_other_codes)

# Returns the values of a code from two dictionaries
get_code_counts <- function(code, dict1, dict2) {
  return(c(dict1[code], dict2[code]))
}

# Target: determine the amount of overlap in secondary conditions between different buckets.
# Returns a tibble. Each column is a code that is present in the initial bucket.
# The column names are the initial buckets
# The diagonal is the number of rows in each bucket
# Large values not on the diagonal indicate a large amount of overlap in the codes
# that patients have between these buckets; further inspection needed.

# The current buckets are as follows
# abortive, eph, preg, fetal, comp, puerperium, other
codes_matrix <- function(analysand) {
  groups <- lst(abortive, eph, preg, fetal, comp, puerperium, other)
  code_buckets <- c("O0[0-8]", "O1[0-6]", "O2[0-9]", "O[3|4][0-8]|O39",
                    "O[6][0-9]|O7[0-7]", "O8[5-9]|O9[0-2]",
                    "O9[4-9]|O9A")
  
  others <- tibble(
    abortive=numeric(),
    eph=numeric(),
    preg=numeric(),
    fetal=numeric(),
    comp=numeric(),
    puerperium=numeric(),
    other=numeric()
  )
  
  for (group in groups) {
    counts <- c()
    for (bucket in code_buckets) {
      counts <- append(counts, nrow(search_secondary_codes(group, bucket)))
    }
    print(counts)
    others <- others %>%
      add_row(abortive=counts[1],
              eph=counts[2],
              preg=counts[3],
              fetal=counts[4],
              comp=counts[5],
              puerperium=counts[6],
              other=counts[7])
  }
  
  return(others)
}

a <- codes_matrix(abortive)
a <- a %>% add_column(percent_other=0) %>%
  add_column(total_codes=0, .before="percent_other")
for (i in 1:nrow(a)) {
  a[i,8] <- sum(a[i, 1:7])
  a[i,9] <- 100 - (a[i,i] / sum(a[i, 1:7])) * 100
}

View(comp)
comp$underlying
sort(unique(comp$underlying))

comp_underlying <- as_tibble(sort(comp$underlying))
nums <- as_tibble(table(comp_underlying))
ggplot(comp_underlying) +
  geom_bar(mapping = aes(x=value))
