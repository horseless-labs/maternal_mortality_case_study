# Overview
This case study is being done for the conclusion of the [[Google Data Analytics Certificate]]. The main purpose is to probe the statistics around maternal mortality in the United States and how they compare to those across Europe.

# Important Sources
## US Maternal Mortality
1. [Maternal Mortality Rates in the United States, 2020](https://www.cdc.gov/nchs/data/hestat/maternal-mortality/2020/maternal-mortality-rates-2020.htm) provided the impetus for this investigation. I had some expectations about maternal mortality that did not hold under even the most casual scrutiny, so I wanted to have a closer look.
2. [CDC Birth Data Files](https://www.cdc.gov/nchs/data_access/VitalStatsOnline.htm) is the **primary source** as of 2022-09-01, as it links to the natality data and a few other death ones. **NOTE**: these files come compressed in a proprietary compression method; needed to install and use 7zip to unzip them.
3. [Vital Statistics Natality Birth Data](https://www.nber.org/research/data/vital-statistics-natality-birth-data) is not immediately relevant, but given that the subject matter is broadly healt-related events concerning pregnancy and birth, I thought it would be useful to include. **Starting this project by downloading CSV files and handbooks from this site going back to 2015; will expand further later**.
4. [Vital Statistics Online Data Portal](https://www.cdc.gov/nchs/data_access/vitalstatsonline.htm#Mortality_Multiple) has a collection of download links for files from the National Vital Statistics System. It is linked from the one immediately above; included for the sake of completion.
5. [CDC Pregnancy Mortality Surveillance System](https://www.cdc.gov/reproductivehealth/maternal-mortality/pregnancy-mortality-surveillance-system.htm)
6. [DataBank - World Development Indicators (matermal mortality ratio)](https://databank.worldbank.org/reports.aspx?source=2&series=SH.STA.MMRT&country=#advancedDownloadOptions)
7. [Breakdown by State](https://worldpopulationreview.com/state-rankings/maternal-mortality-rate-by-state)
8. [US Maternal Mortality Within a Global Context: Historical Trends, Current State, and Future Directions](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8020556/)
9. [Why are more American women dying due to pregnancy today than they were 20 years ago?](https://web.northeastern.edu/rugglesmedia/2016/04/15/maternal-mortality/)
10. [Achievements in Public Health, 1900-1999: Healthier Mothers and Babies](https://www.cdc.gov/mmwr/preview/mmwrhtml/mm4838a2.htm)
11. [Demographics of the United States - Wikipedia](https://en.wikipedia.org/wiki/Demographics_of_the_United_States) contains a chart listing US population figured as far back as 1935. Useful for gleaning proportions.

Per documentation on the CDC site, the analysis will focus on ICD-10 codes A34, O00-O95, and O98-O99

## Correlates
A cursory search indicates that the US does a more thorough job of monitoring statistics around maternal mortality than the nations that I would like to compare it to in a number of different categories, or at least makes it easier to procure those data. It might be worthwhile to look at correlates with maternal mortality in other countries that have better documentation.

[Correlates of maternal mortality in developing countries: an ecological study in 82 countries](https://mhnpjournal.biomedcentral.com/articles/10.1186/s40748-017-0059-8)
[Maternal complications and risk factors for mortality](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7376486/)
[Correlates of Maternal Mortality: A Cross-National Examination](https://vc.bridgew.edu/cgi/viewcontent.cgi?referer=&httpsredir=1&article=1035&context=honors_proj)

# Log
## 2022-09-01
- Download Birth Data Files (2018-2021) and Mortality Multiple Cause Files (2020) from [2], as well as user guides for their use.
- Create small test files consisting of the first 10 elements of these datasets to more easily examine structure. This could be done with the base files, but they are on the order of multiple GB in size each.
- Note that the files do not come with headers and are tab delimited.
- The mortality file from 2021 raises the error `  line 1 did not have 24 elements`, suggesting to me that it contains a record that is blank and R is reading it as misaligned.
- The mortality file indicates that the whitespace in the original file is significant; the user's guide specifies tape locations and field sizes. This implies something about archive methodology, as well, but that is neither here nor there.
- Generate a mortality file with 1000 lines instead of 10 to verify loading and alignment.
	- Misalignment found: R's `read.table()` doesn't understand significant whitespace, as per laid out in the document. Writing a Python script to delineate the file.
- Wrote file to parse the file as needed, but the first one is ~2.8 GB, 3390278 lines long. The laptop I am using is having trouble loading it into memory. Splitting.

It makes sense now that the natality file wouldn't have anything specifically related to maternal mortality; that's a different file. Per [1], this analysis will focus on ICD-10 codes A34, O00-O95, and O98-O99.

**Thoughts on the File Structure**
- Huge amount of whitespace; could be compressed and released for more casual perusal.
- **Residence** at tape location 20.
- **Education** (2003 revision) at tape location 61-62
- **Reported age** at tape location 70-73
- **Place of death and decedent's status** at tape location 83.
- **Marital status code** at tape location 84
- Injury at work code at tape location 106
- Manner of death code at tape location 107; I think it blankets things like disease and childbirth and such as "natural", but will verify later
- Activity code at tape location 144
- ICD-10 code for underlying cause of death at tape location 146-149
- Multiple conditions at tape location 163-443
- Tape location 163-164 is the number of conditions that are listed, maximum of 20; might be useful for parsing.
- Each condition has a prefix of two digits. These might be for internal paperwork or something, but don't seem to be relevant to the analysis here. The actual ICD-10 codes come after these.
- **NEVER MIND**. Tape location 341-342 also contains the number of codes, and 344-443 also contains just the conditions themselves.
- **NEVER MIND THAT NEVER MIND**: These codes are five positions long, with the 5th one blank except for a lot of the pregnancy, childbirth, and puerperium, which will have a 1 in the second condition. See [Maternal Mortality in the United States: Changes in Coding, Publication, and Data Release, 2018](https://www.cdc.gov/nchs/data/nvsr/nvsr69/nvsr69-02-508.pdf)
- **Race** at tape position 445-446. **FOR FUTURE REFERENCE**, coding on this changed in 1992. **NOTE**: different regions have slight changes in their coding. This analysis focuses on US states for the time being, but may be expanded further.
- **Hispanic origin** at 484-486
- **Hispanic origin/race** recode at tape location 488
- **Race recode** 40 at tape location 489-490
- **Usual occupation and industry** at tape location 806-817. Arizona, Iowa, North Carolina, Rhode Island, and District of Columbia are currently not included in the program. See [this](https://www.cdc.gov/nchs/nvss/mortality_public_use_data.htm), (might need to dive into this later). [Census Industry and Occupation Codes](https://www.cdc.gov/niosh/topics/coding/more.html).
- **Occupation 4-digit code** at tape position 806-809
- **Occupation 2-digit recode** at tape position 810-811
- **Industry 4-digit code** at tape position 812-815
- **Industry 2-digit recode** at tape position 816-817

## 2022-09-06
Earlier this week, I wrote a Python script that will let me easily clean the larger mortality dataset (~2.8 GB/year) to a single. It was a bit cowboyed and needs a lot of polish, but that can be handled later. By the same token, it would be good to write a bash script that downloads, unzips, processes, and cleans up the dataset files.

The next step is working through an analysis pipeline in R using this data.

**Note**: I am internally debating whether to include the O96 and O97 in the main dataset because there could be items worth examining there. That said, because the analysis that led to this work did not, I will proceed without them. Making a new dataset now.

Outline for the day:
- Examine proportions for demographic characteristics.

Initial observations, **bearing in mind that this is only the data from 2020**. Some of these impressions might be related to the pandemic, or otherwise be artifacts that will disappear as more years are taken into account.
- ~65% died in the same state and county as they resided
- ~24% died in the same state as they lived
- ~65-70% had only some college without a degree
- Slightly fewer held associate's degrees than a bachelor's, but I suspect this will disappear as more years are considered.
- For 2020, noticeable increase in mortality from March onward.
- ~62% died in inpatient hospital care, ~18% died outpatient or admitted to ER, ~15% died at home.
- Slightly more (<10%) were single instead of married
- Divorces were <10%. A quick search indicates these represent ~15% of the population.
- Almost 60% were White, about 35% Black, despite population size disparities.
- O26 makes up about 32%, O99 about 27%

I'm wondering if starting preliminaries with the 2020 is a poor decision.

## 2022-09-08
Wrote a bash script to download datasets going back as far as 2015 and reduce the data down to annual maternal mortality CSV files. I suspect this process can be scaled to cover the whole process.

**Possible Directions**:
- Abandon idea of occupation and industry data; it wasn't collected or recorded before 2020 for no reason that I can find.
- Compare with changes in marriage and divorce rates; there was a switch between 2015 and 2020 where single women became the larger percentage of deceased patients.
- Group populations by number of comorbid or secondary conditions, and see how the demographics compare.
- Download and parse natality datasets, as well.

## 2022-09-14
Targets:
- Use R to generate a single dataset (with an added year column to keep track) and compare with single years.
- TODO: "code 10" needs to be "code10"
- Bucket patients by how many codes they are given in addition to their underlying one.
	- Get counts
	- See how each bucket deviates from the whole dataset
	- Compare to see if age is a factor in these
	- Start by examing how people who no additional codes, just the specific underlying one.

I am trying to remember that a lot of other datasets, studies, etc. can be brought in as references. I can already feel my mind being too constricted due to code weirdness.

It is worth considering how these codes will be labeled; ICD-10 codes are completely opaque to anyone not familiar with them. Even the organizational scheme is unclear. The scheme is truly dense.

Because the work is moving in the direction of coding, I thought it would be a good idea to have a look at a list of what these codes actually mean. I found [Pregnancy, childbirth, and the puerperium O00-09A](https://www.icd10data.com/ICD10CM/Codes/O00-O9A), which might be a good start to bucket divisions that are not immediately obvious from the codes themselves.
- [O00-O08: Pregnancy with abortive outcomes](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O00-O08)
- [O09-O09: Supervision of high-risk pregnancy](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O09-O09)
- [O10-O16: Edema, proteinuria, and hypertensive disorders](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O10-O16)
- [O20-O29: Other maternal disorders predominantly related to pregnancy](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O20-O29)
- [O30-O48: Maternal care related to the fetus and amniotic cavity and possible delivery problems](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O30-O48)
- [O60-O77: Complications of labor and delivery](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O60-O77)
- [O80-O92: Encounter for delivery](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O80-O82)
- [O85-O92: Complications predominantly related to the peirperium](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O85-O92)
- [O94-O9A: Other obstetric conditions, not elsewhere classified](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O94-O9A)

**Question**: is it better to bucket patients by the groupings as in the above and proceed to examine the other conditions they have, or to group them by numbers of conditions? My thought now is to go by the above, as these buckets might be more correlated with certain conditions. Then, examine the numbers of other codes in each bucket.

Takinga a quick look at the buckets with View(), I noticed that the encounter group encouragingly has 0 values going back to 2015. I also noticed that the high-risk group confusingly also has 0 values, which seems incredibly unlikely. I suspected a bug in the regex, but it might have something to do with coding for underlying conditions. For instance, [further details on supervision of high-risk pregnancy O09-](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O09-O09/O09-) indicates a lot of work that would happen *around* a pregnancy.

**Next step**: Looking for these codes from the codes that were given in addition to underlying conditions.
**Results**: I have tested the regex on my function, used other codes that are known to be in the secondary list, and made sure that the number of patients in the groups collectively added up to those that were in the main dataset to ensure that nothing was excluded. In spite of the apparent lack of reference to it in the ICD-10 outline, I can find no reason why these codes, especially those for high-risk pregnancies, would be completely absent from the dataset, and am currently working on the assumption that this was a deliberate choice.
**Correction**: According to [Outsource Strategies International](https://www.outsourcestrategies.com/resources/high-risk-pregnancy-icd-10-coding-changes-2017/), O09 is only intended for use in the prenatal period. I suspect it would not be applicable to this dataset. However, this means that it will be something to keep in mind as the scope of the analysis broadens. The same source indicates that the codes for encounter pregnancies are meant specifically for situations where there were no complications during the labor or delivery episode, not where a mortality event occurred unexpectedly. This is **also** something to keep in mind as the analysis expands, specifically for maternal mortality and related events post 42 days (i.e., using codes that were excluded from the initial source).

**Next step**: The two largest groups, by a very wide margin, are other maternal disorders (O20-O29) and other obstetric conditions (O94-O9A). These together make up 64.9% of the 755 maternal mortality incidents from 2019 (still working on this for exploratory purposes). They are also broad and ambiguous enough that it might be worth further expanding on their related codes.
**Notes**:
- `preg`  has 236 patients, `other` has 254; they are roughly the same size.
- The maximum number of codes in `preg` was 13, median 4, and mean near the same. The maximum number of codes in `other` was 7, median 2, and mean ~2.8.

**Next step**: Check that the codes in `other` do not occur as secondary codes in `preg`.
**Results**: An `other` code occurs in `preg` in five patients, and vice versa in one. This is not a meaningful contributing factor to the difference in number of codes.

## 2022-09-15
**Next step**: Examine secondary codes in `other` and `preg`.
**Results**:

**Next step**: Write something that outputs a matrix finding the overlap between all the codes in one matrix

**Note**: instead of trying to get dictionaries working, it might make more sense to do all of this in tibbles; columns are named for the code in question, rows for each of the buckets, and a 0 or a 1 to indicate whether they are present. That is a much better way to do this; it just needed an R mindset to get there.

## 2022-09-19
```
  abortive   eph  preg fetal  comp puerperium other
     <dbl> <dbl> <dbl> <dbl> <dbl>      <dbl> <dbl>
1       37     0     2     1     0          1     0
2        1    86    28     1     2          5     1
3        3    11   247     8    14         27     5
4        0     0    17    46     6          2     0
5        1     2     6     7    49         11     1
6        0     5    15     5     1         80     1
7        0     0     1     0     0          0   267
```

`preg` has more codes connected to it than any other

## 2022-09-23
Targets:
- Collect the codes in `preg` and `fetal`. Explain what some of them are, and try to explain why it makes sense that they might occur in multiple buckets.
- See if these relationships hold up across age, education, race, and population.
- See if there are other relationships across those groups.
- See if there are any irregularities among those groups in `other`
- Contrariwise, see if any one of those populations is overrepresented in buckets that have smaller overlap with others.
- Download the natality dataset and see what proportion of women with those codes were fine
- Additionally, examine the codes that were excluded (O96 and O97) to see what their mix of codes looked like. I suspect this will be a much wider spread.

**Note**: Quickly looked at the actual percentages of buckets that have codes in other columns. Broadly, I am thinking about these buckets as being attempts at well-defined constellations of maternal healths problems, deviations from which might indicate that something interesting is happening. Eyeballing it made me think that the buckets with the most variance were `preg` and `fetal`, but take a look at the actual breakdown:

```
# A tibble: 7 × 8
  abortive   eph  preg fetal  comp puerperium other percent_o…¹
     <dbl> <dbl> <dbl> <dbl> <dbl>      <dbl> <dbl>       <dbl>
1       37     0     2     1     0          1     0       9.76 
2        1    86    28     1     2          5     1      30.6  
3        3    11   247     8    14         27     5      21.6  
4        0     0    17    46     6          2     0      35.2  
5        1     2     6     7    49         11     1      36.4  
6        0     5    15     5     1         80     1      25.2  
7        0     0     1     0     0          0   267       0.373
# … with abbreviated variable name ¹​percent_other
```

By percentage of codes that appear in other buckets, `preg` is actually one of the *least* interesting of these buckets. Adjust above targets accordingly.

## 2022-09-28
**Thoughts on Code Buckets**
Outside of the bucket that is specifically for codes that don't fit any of the others, the bucket for complications of labor and delivery (`comp`) has the highest proportion of codes that occur in the other buckets. Finding the set of underlying conditions in this bucket can be done as follows:

```
> unique(comp$underlying)
[1] "O74" "O75" "O71" "O72" "O67" "O60" "O63"
```
From the [ICD-10 section detailing this bucket](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O60-O77):
- O74: Complications of anaesthesia during labor and delivery
- O75: Other complications of labor and delivery, not elsewhere classified
- O71: Other obstetric trauma
- O72: Postpartum hemorrhage
- O67: Labor and delivery complicated by intrapartum hemorrhage, not elsewhere classified
- O60: Preterm labor
- O63: Long labor

I've looked at the graphs for what's happening inside of comp, at least. It might be wise to use more than just the 2019 data.

**Idea**: make comparisons between each of the buckets with multiple plots on one page. If there are any demograph differences between any of them, they should just pop right out.
- [Laying out multiple plots on a page](https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html) -> meh
- [Easy multi-panel plots in R using facet_wrap() and facet_grid() from ggplot2](http://zevross.com/blog/2019/04/02/easy-multi-panel-plots-in-r-using-facet_wrap-and-facet_grid-from-ggplot2/)

Reading the above article, I might have to add a column denoting which bucket a given patient's underlying condition falls under, and use that in something like `facet_wrap()`. Consolidating this way will make it easier than having them represented in the half-dozen variables, at least.

## 2022-10-04
I took a closer look at some of the tidyverse functionality over the weekend. That work can be found in [[Notes on R]]. With a rough framework for processing these datasets, I think immediate targets should look like:
- Download and start using data as far back as 2000
- Clean up the functions and naming conventions used in the preliminary R script

This will situate us to better use tidyverse functions, facet wrapping, and a chance to start looking at a longer run of the data.

**Note**: Could not use the same code to parse data from before 2003. Ran into the error:

```
Traceback (most recent call last):                                                                   
  File "/home/mireles/horseless/maternal_mortality/mortality/mortality_row_parser.py", line 82, in <m
odule>                                                                                               
    test = parse(lines[0])                                                                           
  File "/home/mireles/horseless/maternal_mortality/mortality/mortality_row_parser.py", line 49, in pa
rse                                                                                                  
    hisp_orig_race = row[487]                                                                        
IndexError: string index out of range  
```
Three times, indicating the years 2000, 2001, and 2002. Quickly thinking back, I suspect that this is around the time that coding for race and/or Hispanic origin was changed, so the script to handle this will need to be modified. Calling it good for now.

New targets:
- Make the codes more legible. Possibly generate new columns to preserve the originals.

## 2022-10-06
Finished building out the main groups and decoding. Next steps:
- Break down groups by year
- Import US population data

[Politely scraping Wikipedia tables](https://www.r-bloggers.com/2021/07/politely-scraping-wikipedia-tables-2/)

## 2022-10-07
Generated a tibble that will allow me to see frequencies of each of the underlying conditions for each year. Some things I've noticed:
- By far the most common are codes
	- [O99 - Other maternal diseases classifiable elsewhere but complicating pregnancy, childbirth and the puerperium](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O94-O9A/O99-/O99)
	- [O26 - Maternal care for other conditions predominantly related to pregnancy](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O20-O29/O26-/O26)
	- These codes sometimes switch places, sometimes by large margins, but except for 2003, they have been consistently the top two conditions for the period.
- Only eight other codes are present in the top five for each year from 2003-2019:
	- [O88 - Obstetric embolism](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O85-O92/O88-/O88)
	- [O90 - Complications of the puerperium, not elsewhere classified](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O85-O92/O90-/O90)
	- [O10 - Pre-existing hypertension complicating pregnancy, childbirth, and the puerperium](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O10-O16/O10-/O10)
	- [O75 - Other complications of labor and delivery, not elsewhere classified](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O60-O77/O75-/O75)
	- [O24 - Diabetes mellitus in pregnancy, childbirth, and the puerperium](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O20-O29/O24-/O24)
	- [O26 - Maternal care for other conditions predominantly related to pregnancy](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O20-O29/O26-/O26)
	- O95 - cannot be found on the ICD-10 site, for some reason; it jumps from O94 to O98. I looked at just the set that used O95 for its underlying condition. I found 446 cases from the 2003-2019 period.
	- [O15 - Eclampsia](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O10-O16/O15-/O15)
	- [O14 - Pre-eclampsia](https://www.icd10data.com/ICD10CM/Codes/O00-O9A/O10-O16/O14-/O14)

Next steps:
- Write code to get highest frequency codes from the given column. Some of the underlying codes are substantial umbrella terms, and this will come up often enough.

**Note**: Running into a wall with the specificity of the codes, but haven't had a chance to look wider.

## 2022-10-11
Next steps:
- Examine maternal mortality in different age cohorts.
- Determine if different ages have different code breakdowns, and if that has changed over time. (visibly not dissimilar)
- Determine if different races have different code breakdowns
- Determine if Hispanic origin plays a role in the kinds of codes

## 2022-10-12
- Delineate codes before and after 2018 (there is a pronounced jump in codes before and after this year)

## 2022-10-17
Wrote a mechanism for dividing the set into pre- and post-2018 codes, retrieving the secondary for each, and getting counts for the secondary ones in each of the partitioned sets. That said, looking at [the broadest index for what the codes represent](https://www.icd10data.com/ICD10CM/Codes), I'm wondering if it would make more sense to simply look at the letter of each one.

For patients where O99 was the main cause in the pre-2018 dataset, we see:

```
# A tibble: 20 × 2
   codes counts
   <chr>  <int>
 1 O        803
 2 T        153
 3 X         75
 4 R         61
 5 Y         44
 6 S         13
 7 W         12
 8 I          9
 9 V          8
10 F          6
11 Q          4
12 D          3
13 C          2
14 E          2
15 J          2
16 N          2
17 A          1
18 B          1
19 G          1
20 P          1
```

Some of these codes are more straightforward in their delineation than others.
- O is what we have been examining thus far.
- S and T are [injury, poisoning, and certain other consequences of external causes (S00-T88)](https://www.icd10data.com/ICD10CM/Codes/S00-T88). These may need to be parsed more closely.
- X is broadly exposure to heat, fire, accidents, overexertion, self-harm, and assault. Will also need to be partitioned more carefully. Y and W are much the same. See the [breakdown here](https://www.icd10data.com/ICD10CM/Codes/V00-Y99).
- R is symptoms, signs, and abnormal clinical and lab findings not elsewhere classified.
- 

# Notes for Later
Need to go through [Mothers Are Dying From Treatable Mental Health Conditions](https://slate.com/technology/2022/09/mental-health-maternal-mortality.html). A possible consideration for the analysis is mental health conditions that women have while they are pregnant. Pregnancy codes are Z33; might have to sort through mortality data through the various suicides and accidents where Z33 is a secondary condition.