# We will not be running this code during the live tutorial.
# This file shows how we used tidyverse functions to
# wrangle the raw data into a format suitable for analysis
# and visualization during the time-limited workshop.
# We hope that the examples here will be useful.

# This is also (we hope) a good example of how you can
# save raw data, intermediate data, and the process for
# getting one from the other all in one place.
library(tidyverse)

# Import the data
read_csv("data/clt-berry-data.csv") %>%
  select(where(~ !all(is.na(.)))) -> berry_data_raw

raw_cider_data <- 
  read_csv("data/CiderDryness_SensoryDATA.csv")

# Longer versions for specific analyses:

# Long CATA data for penalty analysis
berry_data_raw %>%
  # Get the relevant columns
  select(`Subject Code`, 
         berry,
         sample,
         starts_with("cata_"), 
         contains("overall")) %>%
  # Rescale the LAM and US scales to a 9-pt range
  mutate(lms_overall = (lms_overall + 100) * (8 / 200) + 1,
         us_overall = (us_overall + 0) * (8 / 15) + 1) %>%
  # Switch the 3 overall liking columns into a single column
  pivot_longer(contains("overall"),
               names_to = "hedonic_scale",
               values_to = "rating",
               values_drop_na = TRUE) %>%
  # Let's make all the CATA variables into a single column to make life easier
  # (and get rid of those NAs)
  pivot_longer(starts_with("cata_"),
               names_to = "cata_variable",
               values_to = "checked",
               names_transform = ~str_remove(., "cata_"),
               values_drop_na = TRUE) -> berry_long_cata

#Long liking data for numeric plots
berry_data_raw %>%
  # Switch the 3 x 5 = 15 liking columns to
  # a column for scale, a column for the attribute, and
  # a column for the rating
  pivot_longer(cols = matches("^(9pt|us|lms)_"),
               names_to = c("Scale", "Attribute"), names_sep = "_",
               values_to = "Liking",
               values_drop_na = TRUE) %>%
  # Removing CATA attributes that only applied to some berries
  select(where(~ !any(is.na(.x)))) %>%
  # Rescaling the liking to match the 9-point hedonic scale
  mutate(Liking = ifelse(Scale == "lms",
                         (Liking + 100) * 8/200 + 1,
                         ifelse(Scale == "us",
                                Liking * 8/15 + 1,
                                Liking))) %>%
  # Selecting only columns we actually need:
  select(Subject = `Subject Code`, Sample = `Sample Name`, berry,
         starts_with("cata_"), Attribute, Scale, Liking) -> berry_long_liking

# Penalty Analysis
berry_long_cata %>%
  group_by(berry, cata_variable, checked) %>%
  summarize(penalty_lift = mean(rating),
            count = n()) %>%
  ungroup() -> berry_penalty_analysis_data

raw_cider_data %>%
  pivot_longer(Fresh_Apples:Synthetic,
               names_to = "cata_variable",
               values_to = "checked") %>%
  group_by(cata_variable, checked) %>%
  summarize(rating = mean(Liking),
            count = n()) %>%
  mutate(proportion = count / sum(count)) %>%
  ungroup() -> cider_penalty_data

# Widening for SVD methods
raw_cider_data %>%
  select(Sample_Name, Temperature, Fresh_Apples:Synthetic) %>%
  unite(Sample_Name, Temperature, col = "sample", sep = " ") %>%
  group_by(sample) %>%
  summarize(across(where(is.numeric), ~sum(.))) %>%
  column_to_rownames("sample") -> cider_contingency

berry_long_liking %>%
  pivot_wider(names_from = Attribute, names_prefix = "liking_", values_from = Liking) %>%
  group_by(Sample) %>%
  summarize(across(starts_with("cata_"),
                   sum),
            across(starts_with("liking_"),
                   mean)) %>%
  select(where(~ !any(is.na(.x)))) %>%
  column_to_rownames("Sample") -> berry_mfa_summary

save(berry_long_cata,
     berry_long_liking,
     berry_penalty_analysis_data,
     cider_penalty_data,
     cider_contingency,
     berry_mfa_summary,
     file = "data/cleaned-data.RData")