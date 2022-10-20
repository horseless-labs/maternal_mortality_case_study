preprocess_dataset <- function(mort, year=0) {
  mort$res_status <- as_factor(mort$res_status)
  mort$education <- as_factor(mort$education)
  mort$age <- as.numeric(mort$age)
  mort$month <- as.numeric(mort$month)
  mort$death_loc <- as_factor(mort$death_loc)
  mort$marital_status <- as_factor(mort$marital_status)
  mort$race <- as_factor(mort$race)
  #mort$hisp_orig <- as_factor(mort$hisp_orig)
  mort$hisp_orig_race <- as_factor(mort$hisp_orig_race)
  
  mort <- mort %>%
    mutate(age = replace(age, age == 999, NA))
  
  if (year != 0) {
    mort <- mort %>% add_column(year=year, .after="month")
    mort$year <- as.numeric(mort$year)
  }
  
  return(mort)
}

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

add_num_conditions <- function(mort) {
  num_conditions_col <- c()
  for (row in 1:nrow(mort)) {
    codes <- get_codes(mort[row,], include_underlying=FALSE)
    num_conditions_col <- append(num_conditions_col, length(codes))
  }
  
  mort <- mort %>% add_column(num_conditions=num_conditions_col, .before="underlying")
  return(mort)
}

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

add_bucket <- function(mort, bucket_name) {
  mort <- mort %>% add_column(bucket=bucket_name, .before="underlying")
  return(mort)
}

get_top_code <- function(idx) {
  o <- tops[idx,2:18] %>%
    pivot_longer(cols=-1) %>%
    rename(year="name") %>%
    rename(n="value") %>%
    select(year, n)
  return(o)
}

get_cohort_codes <- function(dataset, cohort, num=10) {
  cohort_codes <- dataset %>%
    filter(age_cohort==cohort) %>%
    select(underlying, age_cohort) %>%
    add_count(underlying) %>%
    unique() %>%
    arrange(desc(n)) %>%
    slice_max(order_by=n, n=num)
  
  return(cohort_codes)
}

pre_year_codes <- function(dataset, divide_year, code) {
  pre <- dataset %>%
    filter(year < divide_year) %>%
    filter(underlying == code) %>%
    select(code2:code20) %>%
    select(where(~!all(is.na(.x))))
}

post_year_codes <- function(dataset, divide_year, code) {
  post <- dataset %>%
    filter(year >= divide_year) %>%
    filter(underlying == code) %>%
    select(code2:code20) %>%
    select(where(~!all(is.na(.x))))
  
  return(post)
}

get_secondary_codes <- function(dataset) {
  code_header <- colnames(dataset)
  all_non_na <- c()
  
  for (i in code_header) {
    non_na <- dataset[i] %>%
      drop_na()
    
    all_non_na <- append(all_non_na, non_na)
  }
  
  return(all_non_na)
}

strip_codes_to_base <- function(codes) {
  stripped <- unlist(codes)
  stripped <- str_c(stripped, sep="")
  stripped <- as_vector(stripped)
  stripped <- str_sub(stripped, 1, 3)
}

strip_codes_to_char <- function(codes) {
  stripped <- unlist(codes)
  stripped <- str_c(stripped, sep="")
  stripped <- as_vector(stripped)
  stripped <- str_sub(stripped, 1, 1)
}

get_secondary_counts <- function(codes) {
  counts <- strip_codes_to_char(codes)
  counts <- as_tibble(counts)
  counts <- counts %>%
    select(codes = 1) %>%
    group_by(codes) %>%
    summarise(counts = n()) %>%
    arrange(desc(counts))
  return(counts)
}

