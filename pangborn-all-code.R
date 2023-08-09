## ----setup-----------------------------------------------------------------------------------
library(tidyverse)
library(ca)
library(ggrepel)
berry_data <- read_csv("data/clt-berry-data.csv")


## ----workshop-code, child = c("1-intro-to-R.Rmd", "2-using-R.Rmd", "3-tidyverse.Rmd", "4-tidyreshape.Rmd", "5-untidyanalysis.Rmd", "6-dataviz.Rmd")----

## --------------------------------------------------------------------------------------------
getwd() # will print the current working directory


## ---- eval=FALSE-----------------------------------------------------------------------------
## setwd("Enter/Your/Desired/Directory/Here")


## ---- eval = FALSE---------------------------------------------------------------------------
## install.packages("ca")


## --------------------------------------------------------------------------------------------
library(tidyverse)


## --------------------------------------------------------------------------------------------
library(tidyverse)
library(ca)


## --------------------------------------------------------------------------------------------
sessionInfo()


## ---- eval = FALSE---------------------------------------------------------------------------
## ?sessionInfo


## ----example of a code block, eval = FALSE---------------------------------------------------
## You can't write this in an R script because it is plain text.  This will
## cause an error.
## 
## # If you want to write text or notes to yourself, use the "#" symbol at the start of
## # every line to "comment" out that line.  You can also put "#" in the middle of
## # a line in order to add a comment - everything after will be ignored.
## 
## 1 + 1 # this is valid R syntax
## 
## print("hello world") # this is also valid R syntax


## ----calculator 1----------------------------------------------------------------------------
2 + 5


## ----calculator 2----------------------------------------------------------------------------
1000 / 3.5


## ----assignment demo-------------------------------------------------------------------------
x <- 100
hi <- "hello world"
data_set <- rnorm(n = 100, mean = 0, sd = 1)


## ----algebra 1-------------------------------------------------------------------------------
x / 10


## ----algebra 2-------------------------------------------------------------------------------
x + 1


## ----updating a variable---------------------------------------------------------------------
x
x <- 100 + 1
x


## ----first function--------------------------------------------------------------------------
sqrt(x)


## ----a more complex function-----------------------------------------------------------------
rnorm(n = 100, mean = 0, sd = 1)


## ----argument order matters in functions-----------------------------------------------------
# This will give us 1 value from the normal distribution with mean = 0 and sd = 100
rnorm(1, 0, 100)

# But we can also use named arguments to provide them in any order we wish!
rnorm(sd = 1, n = 100, mean = 0)


## ----loading packages 1----------------------------------------------------------------------
library(tidyverse)


## ----getting the working directory-----------------------------------------------------------
getwd()


## ----reading in data-------------------------------------------------------------------------
read_csv(file = "data/clt-berry-data.csv")


## ----storing data when loaded----------------------------------------------------------------
berry_data <- read_csv(file = "data/clt-berry-data.csv")


## ----object properties 1---------------------------------------------------------------------
x <- 100
class(x)
typeof(x)


## ----object properties 2---------------------------------------------------------------------
length(x)


## ----the c()ombine function------------------------------------------------------------------
y <- c(1, 2, 3, 10, 50)
y


## ----combining variables with c()------------------------------------------------------------
c(x, y)


## ----vector types----------------------------------------------------------------------------
animals <- c("fox", "bat", "rat", "cat")
class(animals)


## ----type coercion---------------------------------------------------------------------------
c(y, animals)


## ----math with characters, error = TRUE------------------------------------------------------
c(y, animals) / 2


## ----examining the str()ucture of objects----------------------------------------------------
str(y)
str(animals)


## ----examining our berry data----------------------------------------------------------------
str(berry_data)


## ----subsetting 1----------------------------------------------------------------------------
y[1]
animals[4]


## ----subsetting 2----------------------------------------------------------------------------
animals[c(1, 2)]


## ----the ":" sequence shortcut---------------------------------------------------------------
1:3
animals[1:3]


## ----logical operators-----------------------------------------------------------------------
y < 10


## ----subsetting with logical operators-------------------------------------------------------
y[y < 10]


## ----data frame properties-------------------------------------------------------------------
nrow(berry_data)
ncol(berry_data)
length(berry_data) # Note that length() of a data.frame is the same as ncol()


## ----examining what a data frame contains, eval = FALSE--------------------------------------
## berry_data # simply printing the object
## head(berry_data) # show the first few rows
## tail(berry_data) # show the last few rows
## glimpse(berry_data) # a more compact version of str()
## names(berry_data) # get the variable/column names


## ----subsetting data tables 1----------------------------------------------------------------
berry_data[3, 9] # get the 3rd row, 9th column value


## ----subsetting data tables 2----------------------------------------------------------------
berry_data[1:6, 9] # get the first 5 rows of the 9th column value


## ----subsetting data tables 3----------------------------------------------------------------
berry_data[, 1] # get all rows of the 1st column


## ----logical subsetting for data tables------------------------------------------------------
berry_data[berry_data$berry == "raspberry", ] # get all raspberry data


## ----getting variables out of a data frame, eval = FALSE-------------------------------------
## berry_data$lms_overall # not printed because it is too long!
## berry_data$`9pt_overall` # column names starting with numbers or containing special characters like spaces need to be surrounded by backticks (`)


## ----reload the berry data in case you started your session over-----------------------------
library(tidyverse)
berry_data <- read_csv("data/clt-berry-data.csv")


## ----use glimpse() to examine the berry data-------------------------------------------------
glimpse(berry_data)


## ----reminder of base R subsetting with column numbers---------------------------------------
berry_data[, c(10,25,28,45,56:64,81,89:91)]


## ----reminder of base R subsetting with column names-----------------------------------------
berry_data[, c("9pt_aroma","9pt_overall","9pt_taste","9pt_texture","9pt_appearance",
               "lms_aroma","lms_overall","lms_taste","lms_texture","lms_appearance",
               "us_aroma","us_overall","us_taste","us_texture","us_appearance",
               "berry","test_day")]


## ----using select() with explicit column names-----------------------------------------------
select(berry_data, berry, test_day,
       lms_aroma, lms_overall, lms_taste, lms_texture, lms_appearance) # note the lack of quoting on the column names


## ----errors from select() with unusual column names, eval = FALSE----------------------------
## select(berry_data, berry, test_day,
##        9pt_aroma, 9pt_overall, 9pt_taste, 9pt_texture, 9pt_appearance) # this will cause an error


## ----using select() with escaped column names------------------------------------------------
select(berry_data, berry, test_day, #these ruly column names don't need escaping
       `9pt_aroma`, #only ones starting with numbers...
       `9pt_overall`, `9pt_taste`, `9pt_texture`, `9pt_appearance`,
       `Sample Name`) #or containing spaces


## ----using select() with a character search--------------------------------------------------
select(berry_data, starts_with("lms_")) #the double-quotes are back because this isn't a full column name


## ----combining character search and explicit select()----------------------------------------
select(berry_data, starts_with("lms_"), starts_with("9pt_"), starts_with("us_"),
       berry, test_day)

select(berry_data, starts_with("jar_"), ends_with("_overall"),
       berry, test_day)


## ----everything() is a select helper that selects everything (else)--------------------------
select(berry_data, everything()) #This selects everything--it doesn't change at all.
select(berry_data, berry, contains("_overall"),
       everything()) #only type the columns you want to move to the front, and everything() will keep the rest


## ----using where() with select() is more advanced--------------------------------------------
select(berry_data, where(is.numeric)) #a few functions return one logical value per vector
select(berry_data, where(~!any(is.na(.)))) #otherwise we can use "lambda" functions


## ----reminder of how to get rows from a data frame in base R---------------------------------
berry_data[1:10, ]


## ----first example of filter() with conditional logic----------------------------------------
filter(berry_data, pre_expectation > 3) # let's get survey responses with had a higher-than-average expectation


## ----using the equality operator in filter()-------------------------------------------------
filter(berry_data, pre_expectation > 3, berry == "raspberry")


## ----case-sensitivity in filter()------------------------------------------------------------
filter(berry_data, pre_expectation > 3, berry == "Raspberry")


## ----using the OR operator in filter()-------------------------------------------------------
filter(berry_data, pre_expectation > 3, berry == "raspberry" | berry == "strawberry")


## ----using character searches in filter()----------------------------------------------------
filter(berry_data, str_detect(test_day, "Day 1"))


## ----nesting functions-----------------------------------------------------------------------
select(filter(berry_data, berry == "blackberry"), `Sample Name`, contains("_overall"), contains("cata_"))


## ----storing results as intermediates--------------------------------------------------------
blackberries <- filter(berry_data, berry == "blackberry")
select(blackberries, `Sample Name`, contains("_overall"), contains("cata_"))


## ----the rm() function deletes objects from the Environment----------------------------------
rm(blackberries)


## ----the mighty pipe!------------------------------------------------------------------------
berry_data %>%                             # Start with the berry_data
  filter(berry == "blackberry") %>%        # AND THEN filter to blackberries
  select(`Sample Name`,                    # AND THEN select sample name, overall liking...
         contains("_overall"), contains("cata_"))


## ----order of operations with the pipe-------------------------------------------------------
1 + 2 %>% sqrt # this is instead computing 1 + sqrt(2)


## ----parentheses will make the pipe work better----------------------------------------------
(1 + 2) %>% sqrt() # Now this computes sqrt(1 + 2) = sqrt(3)


## ----an example of a custom function---------------------------------------------------------
subtract <- function(a, b) a - b
subtract(5, 4)


## ----argument order still matters with piped functions---------------------------------------
5 %>% subtract(4)


## ----the pipe will always send the previous step to the first argument of the next step------
4 %>% subtract(5) # this is actually making subtract(4, 5)


## ----using the "." pronoun lets you control order in pipes-----------------------------------
4 %>% subtract(5, .) # now this properly computes subtract(5, 4)


## ----using pipes with filter()---------------------------------------------------------------
berry_data %>%
  filter(post_expectation > pre_expectation)


## ----first example of mutate()---------------------------------------------------------------
berry_data %>%
  mutate(improved = post_expectation > pre_expectation) %>%
  # We'll select just a few columns to help us see the result
  select(`Participant Name`, `Sample Name`, pre_expectation, post_expectation, improved)


## ----mutate() makes new columns--------------------------------------------------------------
# Let's find out the average (mean) rating for the berries on the 9-point scale
berry_data$`9pt_overall` %>% #we need the backticks for $ subsetting whenever we'd need them for tidy-selecting 
  mean(na.rm = TRUE)

# Now, let's create a column that tells us how far each rating is from to the average
berry_data %>%
  mutate(difference_from_average = `9pt_overall` - mean(`9pt_overall`, na.rm = TRUE)) %>%
  # Again, let's select just a few columns
  select(`Sample Name`, `9pt_overall`, difference_from_average)


## ----mutate() using group means--------------------------------------------------------------
berry_data %>%
  group_by(`Sample Name`) %>%
  mutate(difference_from_average = `9pt_overall` - mean(`9pt_overall`, na.rm = TRUE)) %>%
  # Again, let's select just a few columns
  select(`Sample Name`, `9pt_overall`, difference_from_average)


## ----Grouped and ungrouped averages----------------------------------------------------------
berry_data %>%
  select(`Sample Name`, `9pt_overall`) %>%
  group_by(`Sample Name`) %>%
  mutate(group_average = mean(`9pt_overall`, na.rm = TRUE),
         difference_from_average = `9pt_overall` - group_average) %>%
  ungroup() %>%
  mutate(grand_average = mean(`9pt_overall`, na.rm = TRUE))


## ----split-apply-combine pipeline example----------------------------------------------------
berry_summary <- 
  berry_data %>%
  filter(!is.na(`9pt_overall`)) %>%                    # only rows with 9-point ratings
  group_by(`Sample Name`) %>%                          # we will create a group for each berry sample
  summarize(n_responses = n(),                         # n() counts number of ratings for each berry
            mean_rating = mean(`9pt_overall`),         # the mean rating for each species
            sd_rating = sd(`9pt_overall`),             # the standard deviation in rating
            se_rating = sd(`9pt_overall`) / sqrt(n())) # multiple functions in 1 row

#Equivalent to:
berry_data %>%
  filter(!is.na(`9pt_overall`)) %>%
  summarize(n_responses = n(),                         # n() counts number of ratings for each berry
            mean_rating = mean(`9pt_overall`),         # the mean rating for each species
            sd_rating = sd(`9pt_overall`),             # the standard deviation in rating
            se_rating = sd(`9pt_overall`) / sqrt(n()),
            .by = `Sample Name`)

berry_summary


## ----simple stat summaries with split-apply-combine------------------------------------------
berry_summary %>%
  mutate(lower_limit = mean_rating - 1.96 * se_rating,
         upper_limit = mean_rating + 1.96 * se_rating)


## ----apply the same tidy operation across() multiple columns---------------------------------
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(.cols = starts_with("cata_"),
                   .fns = sum))


## ----using multiple functions in across()----------------------------------------------------
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(.cols = starts_with("cata_"),
                   .fns = list(frequency = sum,
                               #the sum of binary cata data gives the citation frequency
                               percentage = mean)))
                               #meanwhile, the mean gives the percentage.


## ----lambda functions for more complicated `across()`----------------------------------------
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(.cols = starts_with("9pt_"),
                   .fns = list(mean = mean,
                               sd = sd))) #All NA

berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(.cols = starts_with("9pt_"),
                   .fns = list(mean = ~ mean(.x, na.rm = TRUE),
                               sd = ~ sd(.x, na.rm = TRUE))))


## ----pivoting data tables--------------------------------------------------------------------
berry_data %>%
  select(`Subject Code`, `Sample Name`, berry, starts_with("cata_"), starts_with("9pt")) %>% # for clarity
  pivot_longer(cols = starts_with("cata_"),
               names_prefix = "cata_",
               names_to = "attribute",
               values_to = "presence") -> berry_data_cata_long
#The names_prefix will be *removed* from the start of every column name
#before putting the rest of the name in the `names_to` column

berry_data_cata_long


## ----reversing the effects of pivot_longer() with pivot_wider()------------------------------
berry_data_cata_long %>%
  pivot_wider(names_from = "attribute",
              values_from = "presence",
              names_prefix = "cata_") #pivot_wider *adds* the names_prefix


## --------------------------------------------------------------------------------------------
berry_data %>%
  pivot_longer(cols = starts_with(c("9pt_","lms_","us_")),
               names_to = c("scale", "attribute"),
               names_sep = "_",
               values_to = "rating",
               values_drop_na = TRUE) %>%
  group_by(scale) %>%
  mutate(normalized_rating = (rating - mean(rating)) / sd(rating)) %>%
  group_by(scale, attribute, berry) %>%
  summarize(avg_liking = mean(normalized_rating)) %>%
  pivot_wider(names_from = scale,
              values_from = avg_liking)


## ----using bind_rows() to stack the output of multiple summarize() calls---------------------
berry_type_counts <-
  berry_data %>%
  group_by(berry) %>%
  summarize(n = n_distinct(`Subject Code`, test_day)) %>%
  rename(Level = berry)

berry_scale_counts <-
  berry_data %>%
  pivot_longer(ends_with("_overall"),
               names_sep = "_", names_to = c("Scale", NA),
               values_to = "Used", values_drop_na = TRUE) %>%
  group_by(Scale) %>%
  summarize(n = n_distinct(`Subject Code`, test_day)) %>%
  rename(Level = Scale)

#These are both summarizing the same set of observations into different groups:
sum(berry_scale_counts$n)
sum(berry_type_counts$n)
#Hence needing two summarize() calls

bind_rows(Berry = berry_type_counts,
          Scale = berry_scale_counts,
          .id = "Variable") #This makes a new column called "Variable" which will
                            #specify which of the two tables each row came from


## ----joining different sets of variables taken on the same observations----------------------
demographics <-
  berry_data %>%
  distinct(`Subject Code`) %>%
  mutate(Age = round(rnorm(n(), 45, 6)),
         Gender = ifelse(rbinom(n(), 1, 0.6), "F", "M"),
         Location = sample(state.name, n(), replace = TRUE)) %>%
  rename(ID = `Subject Code`) #To demonstrate how you can manually configure
                              #the columns used to align the datasets

#And now we can join it:
berry_data %>%
  select(-Age, -Gender) %>% #Getting rid of the empty demographic columns first
  left_join(demographics, by = c("Subject Code" = "ID"))
  


## ----using anti_join() to remove rows--------------------------------------------------------
problem_participants <-
  berry_data %>%
  group_by(`Participant Name`) %>%
  summarize(sessions = n_distinct(test_day)) %>%
  filter(sessions > 1)

berry_data %>%
  anti_join(problem_participants)
#We don't need to specify by if they share the column name they're joining on
#and NO OTHERS


## ----renaming columns------------------------------------------------------------------------
names(berry_data)

berry_data %>%
  rename(Sample = `Sample Name`,
         Subject = `Participant Name`) %>%
  select(Subject, Sample, everything()) #no more backticks!


## ----rename() works with positions as well as explicit names---------------------------------
berry_data %>%
  rename(Subject = 1)


## ----reordering columns in a tibble----------------------------------------------------------
berry_data %>%
  relocate(`Sample Name`) # giving no other arguments will move to front


## ----using relative positions with relocate()------------------------------------------------
berry_data %>%
  relocate(Gender, Age, `Subject Code`, `Start Time (UTC)`, `End Time (UTC)`, `Sample Identifier`, .after = berry) # move repetitive and empty columns to the end


## ----missing values make more of themselves--------------------------------------------------
mean(berry_data$price) #This column had no NAs, so we can take the average
mean(berry_data$`9pt_overall`) #This column has some NAs, so we get NA


## ----na.rm in base R functions---------------------------------------------------------------
mean(berry_data$`9pt_overall`, na.rm = TRUE) #We get the average of only the valid numbers
sum(berry_data$`9pt_overall`, na.rm = TRUE) /
  length(berry_data$`9pt_overall`) #The denominator is NOT the same as the total number of values anymore
sum(berry_data$`9pt_overall`, na.rm = TRUE) /
  sum(!is.na(berry_data$`9pt_overall`)) #The denominator is the number of non-NA values


## ----removing rows with na values------------------------------------------------------------
berry_data %>%
  drop_na() #All of our rows have *some* NA values, so this returns nothing

berry_data %>%
  select(`Participant Name`, `Sample Name`, contains("9pt_")) %>%
  drop_na() #Now we get only respondants who answered all 9-point liking questions.


## ----removing columns with missing values----------------------------------------------------
berry_data %>%
  select(where(~none(.x, is.na))) #Only 38 columns with absolutely no missing values.
#This loses all of the liking data.


## ----removing rows that are missing all three aroma liking ratings---------------------------
berry_data %>%
  select(where(~!every(.x, is.na))) %>% #remove columns with no data
  filter(!(is.na(`9pt_aroma`) & is.na(lms_aroma) & is.na(us_aroma)))
#You'll notice that only strawberries have any non-NA liking values, actually


## ----using summarize() to count responses----------------------------------------------------
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(n_responses = n())


## ----using count() to count responses--------------------------------------------------------
berry_data %>%
  count(`Sample Name`) #Counts the number of observations (rows) of each berry

berry_data %>%
  count(berry) #Number of observations, *not necessarily* the number of participants!


## ----easy counting with distinct() and count()-----------------------------------------------
berry_data %>%
  distinct(test_day, `Subject Code`)
#Two columns, with one row for each completed tasting session
#(each reflects 5-6 rows in the initial data)

berry_data %>%
  distinct(test_day, `Subject Code`) %>%
  count(test_day)
#Counts the number of participants per testing day


## ----arrange() lets you sort your data-------------------------------------------------------
berry_data %>%
  arrange(desc(lms_overall)) %>% # which berries had the highest liking on the lms?
  select(`Sample Name`, `Participant Name`, lms_overall)


## ----arrange() works on both numeric and character data--------------------------------------
tibble(state_name = state.name, area = state.area) %>% # using a dataset of US States for demonstration
  arrange(desc(state_name))                            # sort states reverse-alphabetically


## ----making sure that we have loaded all packages and data-----------------------------------
# The packages we're using
library(tidyverse)
library(ca)

# The dataset
berry_data <- read_csv("data/clt-berry-data.csv")


## ----loading the ca package and looking at help files, eval = FALSE--------------------------
## library(ca)
## 
## ?ca


## ----example contingency table---------------------------------------------------------------
data("author")
str(author)
head(author)


## ----example of tidy CATA data---------------------------------------------------------------
berry_data %>%
  select(`Sample Name`, `Subject Code`, starts_with("cata_"))


## ----converting binary data from numeric to logical------------------------------------------
testlogic <- c(TRUE,FALSE,FALSE)
testlogic
class(testlogic) #We start with logical data

testnums <- as.numeric(testlogic) #as.numeric() turns FALSE to 0 and TRUE to 1
testnums
class(testnums) #Now it's numeric

as.logical(testnums) #We can turn numeric to logical data the same way
as.logical(c(0,1,2,3)) #Be careful with non-binary data, though!


## --------------------------------------------------------------------------------------------
berry_data %>%
  mutate(presence = 1) %>%
  pivot_wider(names_from = berry,
              values_from = presence, values_fill = 0) %>%
  #The rest is just for visibility:
  select(ends_with("berry"), `Sample Name`, everything()) %>%
  arrange(lms_overall)


## ----using summarize to count the CATA frequency---------------------------------------------
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(starts_with("cata_"), sum))


## ----frequency table of terms shared by all berries------------------------------------------
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(starts_with("cata_"), sum)) %>%
  select(where(~ none(.x, is.na))) -> berry_tidy_contingency

berry_tidy_contingency


## ----error with tibbles in base R functions, eval = FALSE------------------------------------
## berry_tidy_contingency %>%
##   ca()


## ----tabular data with and without rownames--------------------------------------------------
class(author)
dimnames(author)
class(berry_tidy_contingency)
dimnames(berry_tidy_contingency)


## ----turning data frames into matrices (badly)-----------------------------------------------
as.matrix(berry_tidy_contingency)


## ----trying to do math with character data, eval = FALSE-------------------------------------
## 1 + 2
## "1" + "2"


## ----Turning a Column to Rownames------------------------------------------------------------
berry_tidy_contingency %>%
  column_to_rownames("Sample Name") -> berry_contingency_df

class(berry_contingency_df)
dimnames(berry_contingency_df)


## --------------------------------------------------------------------------------------------
berry_data %>%
  pivot_longer(starts_with("cata_"),
               names_to = "attribute",
               values_to = "presence") %>%
  filter(presence == 1) %>%
  count(attribute) %>%
  arrange(desc(n)) %>% #Arranges the highest-cited CATA terms first
  pull(attribute)      #Pulls the attribute names as a vector, in the order above


## ----doing Correspondence Analysis!!---------------------------------------------------------
ca(berry_contingency_df) -> berry_ca_res


## --------------------------------------------------------------------------------------------
berry_data %>%
  select(`Sample Name`, contains(c("cata_", "9pt_", "lms_", "us_"))) %>%
  summarize(across(contains("cata_"), ~ sum(.x, na.rm = TRUE)),
            across(contains(c("9pt_","lms_","us_")), ~ mean(.x, na.rm = TRUE)), .by = `Sample Name`) %>%
  column_to_rownames("Sample Name") %>%
  ca(supcol = 37:51) #You have to know the NUMERIC indices to do it this way.


## ----structure of ca() results---------------------------------------------------------------
berry_ca_res %>%
  str()


## ----the most commonly-used parts of ca() results--------------------------------------------
berry_ca_res$rowcoord #the standard coordinates of the row variable (berry)
berry_ca_res$colcoord #the standard coordinates of the column variable (attribute)

berry_ca_res$sv       #the singular value for each dimension
berry_ca_res$sv %>%   #which are useful in calculating the % inertia of each dimension
  {.^2 / sum(.^2)}
#The column and row masses (in case you want to add your own supplementary variables
#after the fact):
berry_ca_res$rowmass  #the row masses
berry_ca_res$colmass  #the column masses
                      #(in case you want to add your own supplementary variables
                      #after the analysis)


## ----tidying the row and column coordinates--------------------------------------------------
berry_row_coords <- berry_ca_res$rowcoord %>%
  as.data.frame() %>% #rownames_to_column() works on data.frames, not matrices
  rownames_to_column("Variable") #This has to be the same for both to use bind_rows()!

berry_col_coords <- berry_ca_res$colcoord %>%
  as_tibble(rownames = "Variable") #Equivalent to the above, and works on matrices.

berry_ca_coords <- bind_rows(Berry = berry_row_coords,
                             Attribute = berry_col_coords,
                             .id = "Type")

berry_ca_coords


## ----turning multiple vectors into one tibble------------------------------------------------
berry_rowmass <- tibble(Variable = berry_ca_res$rownames,
                        Mass = berry_ca_res$rowmass)

berry_rowmass


## ----turning named vectors into tibbles------------------------------------------------------
named_colmasses <- berry_ca_res$colmass
names(named_colmasses) <- berry_ca_res$colnames

berry_colmass <- named_colmasses %>%
  enframe(name = "Variable",
          value = "Mass")

berry_colmass


## ----remember: tidy-joining multiple tables--------------------------------------------------
bind_rows(berry_colmass, berry_rowmass) %>%
  left_join(berry_ca_coords, by = "Variable")


## ----saving the tidy and tabular ca results--------------------------------------------------
berry_ca_coords %>%
  write_csv("data/berry_ca_coords.csv")

berry_col_coords %>%
  write_csv("data/berry_ca_col_coords.csv")

berry_row_coords %>%
  write_csv("data/berry_ca_row_coords.csv")


## ----saving the jagged berry_ca_res as an rds------------------------------------------------
berry_ca_res %>%
  write_rds("data/berry_ca_results.rds")


## ----base R plotting example-----------------------------------------------------------------
plot(berry_ca_res)


## ----non-working schematic of a ggplot, eval = FALSE-----------------------------------------
## # The ggplot() function creates your plotting environment.  We often save it to a variable in R so that we can use the plug-n-play functionality of ggplot without retyping
## p <- ggplot(mapping = aes(x = <a variable>, y = <another variable>, ...),
##             data = <your data>)
## 
## # Then, you can add various ways of plotting data to make different visualizations.
## p +
##   geom_<your chosen way of plotting>(...) +
##   theme_<your chosen theme> +
##   ...


## ----a first ggplot--------------------------------------------------------------------------
berry_data %>%
  ggplot(mapping = aes(x = lms_appearance, y = lms_overall)) + # Here we set up the base plot
  geom_point()                           # Here we tell our base plot to add points


## ----basic ggplot2 scatterplot---------------------------------------------------------------
berry_data %>%
  select(`Sample Name`, contains(c("9pt_","lms_","us_"))) %>%
  summarize(across(everything(), ~ mean(.x, na.rm = TRUE)), .by = `Sample Name`) -> berry_average_likings

berry_average_likings %>%
  nrow()

berry_average_likings %>%
  ggplot(aes(x = `9pt_overall`, y = `lms_overall`)) +
  geom_point() #23 points, one per row


## ----what we are plotting in this example----------------------------------------------------
berry_average_likings %>%
  select(lms_overall, `9pt_overall`)


## ----changing the geom changes the way the data map, fig.cap = 'switching geom_() switches the way the data map'----
berry_data %>%
  ggplot(mapping = aes(x = lms_appearance, y = lms_overall)) + 
  geom_smooth()


## ----linear regression with geom_smooth, fig.cap = 'linear regression with geom_smooth()'----
berry_data %>%
  ggplot(mapping = aes(x = lms_appearance, y = lms_overall)) + 
  geom_smooth(method = )


## ----geoms are layers in a plot, fig.cap = 'geom_()s are layers in a plot'-------------------
berry_data %>%
  ggplot(mapping = aes(x = lms_appearance, y = lms_overall)) + 
  geom_point() +
  geom_smooth()


## ----here are some other parts of the plot we can control with data--------------------------
berry_data %>%
  #ggplot will drop NA values for you, but it's good practice to
  #think about what you want to do with them:
  drop_na(lms_overall, cata_appearance_bruised) %>%
  #color, shape, linetype, and other aesthetics that would add a key
  #don't like numeric data types. The quick-and-dirty solution:
  mutate(across(starts_with("cata_"), as.factor)) %>%
  ggplot(mapping = aes(x = lms_appearance, y = lms_overall,
                       color = cata_appearance_bruised)) +
  geom_point(alpha = 1/4) + 
  geom_smooth(se = FALSE) +
  theme_bw()


## ----an unreadable scatterplot---------------------------------------------------------------
berry_data %>%
  ggplot(mapping = aes(x = `9pt_appearance`, y = `9pt_overall`)) +
  geom_point()


## ----transparent points stack on top of each other to make less transparent points-----------
berry_data %>%
  ggplot(mapping = aes(x = `9pt_appearance`, y = `9pt_overall`)) +
  geom_point(alpha = 0.05) 


## ----using geom_jitter for overlapping points, fig.cap = 'using geom_jitter() for overlapping points'----
berry_data %>%
  ggplot(mapping = aes(x = `9pt_appearance`, y = `9pt_overall`)) +
  geom_jitter(alpha = 1/4) +
  geom_smooth(method = "lm", se = FALSE)


## ----geom_bar and geom_histogram, fig.cap = 'geom_bar() and geom_histogram()'----------------
#geom_bar() is for when you already have discrete data, it just counts:
berry_data %>%
  ggplot(aes(x = cata_taste_berry)) +
  geom_bar()

berry_data %>%
  ggplot(aes(x = `9pt_overall`)) +
  geom_bar()

#and geom_histogram() is for continuous data, it counts and bins:
berry_data %>%
  ggplot(aes(x = `lms_overall`)) +
  geom_histogram()


## ----using the aes function, fig.cap = 'using the aes() function'----------------------------
berry_data %>%
  drop_na(lms_overall, cata_appearance_bruised) %>%
  ggplot(aes(x = lms_appearance, y = lms_overall)) + 
  # We can set new aes() mappings in individual layers, as well as the plot itself
  geom_point(aes(alpha = jar_size)) +
  #Unlike color, alpha will accept numeric variables for mapping
  theme_bw()


## ----using the theme functions, fig.cap = 'using the theme_*() functions'--------------------
berry_data %>%
  drop_na(lms_overall, cata_appearance_bruised) %>%
  ggplot(aes(x = lms_appearance, y = lms_overall)) + 
  geom_point() +
  theme_void()


## ----ggplots are R objects-------------------------------------------------------------------
# To effectively plot all of the cata attributes on a bar chart, the data
# needs to be longer (one geom_bar() per group, not per column!)
# and we'll remove columns with NAs for now.
berry_cata_long <- berry_data %>%
  select(where(~none(.x, is.na))) %>%
  pivot_longer(starts_with("cata_"),
               names_to = c(NA, "Modality", "Attribute"), names_sep = "_",
               values_to = "Presence")

# And now we can use this for plotting
p <- 
  berry_cata_long %>%
  filter(Presence == 1) %>%
  ggplot(aes(x = Attribute, fill = berry, color = Modality)) + 
  geom_bar(position = position_dodge()) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

p


## ----we can modify stored plots after the fact-----------------------------------------------
p +
  scale_fill_viridis_d() +
  scale_color_grey(start = 0, end = 0.8) #For bar plots, color is the outline!


## ----another example of posthoc plot modification--------------------------------------------
# We'll pick 14 random colors from the colors R knows about
random_colors <- print(colors()[sample(x = 1:length(colors()), size = 10)])

p + 
  scale_fill_manual(values = random_colors) +
  scale_color_manual(breaks = c("taste", "appearance"),
                     values = c("lightgrey", "black"))


## ----splitting the plot into 12 small multiples, fig.cap = 'now we split the plot into 12 "small multiples" with facet_wrap()'----
berry_cata_long %>%
  filter(Presence == 1) %>%
  ggplot(aes(x = berry)) + 
  geom_bar() +
  theme_bw() +
  facet_wrap(~ Attribute) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))



## ----more control over bar plots with geom_col, fig.cap = 'more control over bar plots with geom_col()'----
berry_cata_long %>%
  group_by(berry, Attribute, Modality) %>%
  summarize(proportion = mean(Presence)) %>%
  ggplot(aes(x = berry, y = proportion)) + 
  geom_col() +
  theme_bw() +
  facet_wrap(~ Attribute) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))



## ----a complicated ggplot that gives different data to each geom-----------------------------
ggplot() +
  geom_segment(aes(xend = Dim1, yend = Dim2), x = 0, y = 0,
               arrow = arrow(length = unit(0.25, "cm")),
               data = berry_col_coords) +
  geom_text_repel(aes(x = Dim1, y = Dim2, label = Variable, color = Type,
                      fontface = ifelse(Type == "Attribute", "italic", "plain")),
                  data = berry_ca_coords) +
  scale_color_manual(breaks = c("Attribute","Berry"),
                     values = c("lightgrey","maroon")) +
  theme_bw()


## ----remember what our tidy ca results look like---------------------------------------------
berry_ca_coords


## ----a basic ca map with ggplot2-------------------------------------------------------------
berry_ca_coords %>%
  mutate(Variable = str_remove(Variable, "cata_")) %>%
  ggplot(aes(x = Dim1, y = Dim2, color = Type, label = Variable)) +
  geom_hline(color="black", yintercept = 0) +
  geom_vline(color="black", xintercept = 0) +
  geom_text() +
  theme_bw() +
  xlab("Dimension 1") +
  ylab("Dimension 2")


## ----a basic ca map with geom_repel, fig.cap = 'a basic ca map with geom_repel()'------------
berry_ca_coords %>%
  mutate(Variable = str_remove(Variable, "cata_")) %>%
  ggplot(aes(x = Dim1, y = Dim2, color = Type, label = Variable)) +
  geom_hline(color="black", yintercept = 0) +
  geom_vline(color="black", xintercept = 0) +
  geom_text_repel() +
  theme_bw() +
  xlab("Dimension 1") +
  ylab("Dimension 2")


## ----a much more fine-tuned ca map with ggplot2----------------------------------------------

berry_ca_res$sv %>%
  {str_c("Dimension ", 1:length(.), " (", round(100 * .^2 / sum(.^2), 1), "% Inertia)")} ->
  berry_cata_ca_dimnames

berry_ca_coords %>%
  mutate(Variable = str_remove(Variable, "cata_"),
         Variable = str_replace(Variable, "Strawberry", "Strawberry "),
         font = ifelse(Type == "Attribute", "italic", "plain")) %>%
  separate(Variable, c("Var_Major", "Var_Minor"), remove = FALSE) %>%
  ggplot(aes(x = Dim1, y = Dim2, fontface = font, color = Var_Major, label = Variable)) +
  geom_hline(color="black", yintercept = 0) +
  geom_vline(color="black", xintercept = 0) +
  geom_point() +
  geom_text_repel(size = 5) +
  theme_bw() +
  xlab(berry_cata_ca_dimnames[1]) +
  ylab(berry_cata_ca_dimnames[2]) +
  scale_color_manual(values = c("appearance" = "#bababa",
                                "taste" = "#7f7f7f",
                                "Blackberry" = "#2d0645",
                                "Blueberry" = "#3e17e8",
                                "raspberry" = "#7a1414",
                                "Strawberry" = "#f089cb"))



