# Wrangling data with `tidyverse`: Reshaping and combining tables



## Pivot tables- wider and longer data

Users of Excel may be familiar with the idea of pivot tables.  These are functions that let us make our data tidier.  To quote Wickham and Grolemund:

> here are three interrelated rules which make a dataset tidy:
>
> 1.  Each variable must have its own column.
> 2.  Each observation must have its own row.
> 3.  Each value must have its own cell.

While these authors present "tidiness" of data as an objective property, I'd argue that data is always tidy **for a specific purpose**.  For example, our data is relatively tidy with one row per tasting event (one person tasting one berry), but this data still has an unruly number of variables (92 columns!!). You've already learned some tricks for dealing with large numbers of columns at once like `across()` and other functions using select helpers, but we have to do this *every time* we use `mutate()`, `summarize()`, or a similar function.

We could also treat the attribute or question as an independent variable affecting the response. If we take this view, then the tidiest dataset actually has one row for each person's response to a single `question`. If we want to make plots or do other modelling, this **longer** form is often more tractable and lets us do operations on the whole dataset with less code.

We can use the `pivot_longer()` function to change our data to make the implicit variable explicit and to make our data tidier.


```r
berry_data %>%
  select(`Subject Code`, `Sample Name`, berry, starts_with("cata_"), starts_with("9pt")) %>% # for clarity
  pivot_longer(cols = starts_with("cata_"),
               names_prefix = "cata_",
               names_to = "attribute",
               values_to = "presence") -> berry_data_cata_long
#The names_prefix will be *removed* from the start of every column name
#before putting the rest of the name in the `names_to` column

berry_data_cata_long
```

```
## # A tibble: 270,252 × 10
##    `Subject Code` `Sample Name` berry `9pt_appearance` `9pt_overall` `9pt_taste`
##             <dbl> <chr>         <chr>            <dbl>         <dbl>       <dbl>
##  1           1001 raspberry 6   rasp…                4             4           4
##  2           1001 raspberry 6   rasp…                4             4           4
##  3           1001 raspberry 6   rasp…                4             4           4
##  4           1001 raspberry 6   rasp…                4             4           4
##  5           1001 raspberry 6   rasp…                4             4           4
##  6           1001 raspberry 6   rasp…                4             4           4
##  7           1001 raspberry 6   rasp…                4             4           4
##  8           1001 raspberry 6   rasp…                4             4           4
##  9           1001 raspberry 6   rasp…                4             4           4
## 10           1001 raspberry 6   rasp…                4             4           4
## # ℹ 270,242 more rows
## # ℹ 4 more variables: `9pt_texture` <dbl>, `9pt_aroma` <dbl>, attribute <chr>,
## #   presence <dbl>
```

Remember that `tibble`s and `data.frame`s can only have one data type per column (`logical > integer > numeric > character`), however! If we have one row for each CATA, JAR, hedonic scale, AND free response question, the `value` column would have a mixture of different data types. This is why we have to tell `pivot_longer()` which `cols` to pull the `names` and `values` from.

Now for each unique combination of `Sample Name` and `Subject Code`, we have 36 rows, one for each CATA question that was asked. The variables that weren't listed in the `cols` argument are just replicated on each of these rows. Each of the 36 rows that represent `Subject Code` 1001's CATA responses for `raspberry 6` has the same `Subject Code`, `Sample Name`, `berry`, and various `9pt_` ratings as the other 35.

Sometimes we want to have "wider" or "untidy" data.  We can use `pivot_wider()` to reverse the effects of `pivot_longer()`.


```r
berry_data_cata_long %>%
  pivot_wider(names_from = "attribute",
              values_from = "presence",
              names_prefix = "cata_") #pivot_wider *adds* the names_prefix
```

```
## # A tibble: 7,507 × 44
##    `Subject Code` `Sample Name` berry `9pt_appearance` `9pt_overall` `9pt_taste`
##             <dbl> <chr>         <chr>            <dbl>         <dbl>       <dbl>
##  1           1001 raspberry 6   rasp…                4             4           4
##  2           1001 raspberry 5   rasp…                8             9           9
##  3           1001 raspberry 2   rasp…                4             3           3
##  4           1001 raspberry 3   rasp…                7             7           6
##  5           1001 raspberry 4   rasp…                7             4           3
##  6           1001 raspberry 1   rasp…                7             4           3
##  7           1002 raspberry 6   rasp…                6             4           4
##  8           1002 raspberry 5   rasp…                8             7           4
##  9           1002 raspberry 2   rasp…                8             7           6
## 10           1002 raspberry 3   rasp…                7             9           9
## # ℹ 7,497 more rows
## # ℹ 38 more variables: `9pt_texture` <dbl>, `9pt_aroma` <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>,
## #   cata_appearance_fresh <dbl>, cata_appearance_goodshape <dbl>,
## #   cata_appearance_goodquality <dbl>, cata_appearance_none <dbl>, …
```

Pivoting is an incredibly powerful and incredibly common data manipulation technique that will become even more powerful when we need to make complex graphs later. Different functions and analyses may require the data in different longer or wider formats, and you will often find yourself starting with even less tidy data than what we've provided.

For an example of this power, let's imagine that we want to compare the 3 different liking scales by normalizing each by the `mean()` and `sd()` of that particular scale, then comparing average liking for each attribute of each berry across the three scales.


```r
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
```

```
## `summarise()` has grouped output by 'scale', 'attribute'. You can override
## using the `.groups` argument.
```

```
## # A tibble: 17 × 5
## # Groups:   attribute [5]
##    attribute  berry         `9pt`      lms      us
##    <chr>      <chr>         <dbl>    <dbl>   <dbl>
##  1 appearance blackberry  0.284    0.364    0.327 
##  2 appearance blueberry   0.381    0.424    0.462 
##  3 appearance raspberry   0.246    0.236    0.223 
##  4 appearance strawberry -0.164   -0.226   -0.220 
##  5 aroma      strawberry  0.0351  -0.0676  -0.0951
##  6 overall    blackberry -0.177   -0.209   -0.177 
##  7 overall    blueberry   0.0234   0.0576   0.166 
##  8 overall    raspberry   0.0261   0.0300   0.0707
##  9 overall    strawberry -0.150   -0.179   -0.200 
## 10 taste      blackberry -0.289   -0.301   -0.336 
## 11 taste      blueberry  -0.0611   0.0202   0.0366
## 12 taste      raspberry  -0.0291  -0.0336  -0.0359
## 13 taste      strawberry -0.306   -0.292   -0.339 
## 14 texture    blackberry -0.0467   0.00645 -0.0118
## 15 texture    blueberry   0.159    0.202    0.284 
## 16 texture    raspberry  -0.00677 -0.00607  0.0289
## 17 texture    strawberry -0.0602  -0.0531  -0.0768
```

While pivoting may seem simple at first, it can also get pretty confusing! That example required two different pivots! We'll be using these tools throughout the rest of the tutorial, so I wanted to give exposure, but mastering them takes trial and error. I recommend taking a look at the [relevant chapter in Wickham and Grolemund](https://r4ds.had.co.nz/tidy-data.html) for details.

## Combining data

While we've been using a single dataset read in from one `.csv` file, this will not always be the way your data is stored when you start working with it. There may be several surveys you're combining, or a separate file with survey responses, another with your blinding code key, and still another with data from a collaborator.

The `tidyverse` verb that you use for this combination depends on whether your datasets have matching columns/variables (say, data from two different years or locations of a project) or matching rows/observations (say, sensory and chemical data).

The "matching variables" case can also happen if we want to stack the outputs of multiple independent `summarize()` calls, such as making a stacked demographic table. Since our data doesn't have demographic data removed, let's instead try to make a table that reports our sample size for each `berry` type and each of the three kinds of liking scales.

If we wanted the combinations of these levels (e.g., the sample size of 9-pt scale ratings of strawberries), we could use one `summarize()` or `count()` call, but we need to do a little extra work if we want to `summarize()` the whole dataset more than one different way.


```r
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
```

```
## [1] 1301
```

```r
sum(berry_type_counts$n)
```

```
## [1] 1301
```

```r
#Hence needing two summarize() calls

bind_rows(Berry = berry_type_counts,
          Scale = berry_scale_counts,
          .id = "Variable") #This makes a new column called "Variable" which will
```

```
## # A tibble: 7 × 3
##   Variable Level          n
##   <chr>    <chr>      <int>
## 1 Berry    blackberry   299
## 2 Berry    blueberry    313
## 3 Berry    raspberry    358
## 4 Berry    strawberry   331
## 5 Scale    9pt          423
## 6 Scale    lms          435
## 7 Scale    us           443
```

```r
                            #specify which of the two tables each row came from
```

For multiple tables that share the same observations, we could want to add follow-up survey data using the same participants or genetic information about the berries. In the latter case, our table of berry genetics would have less rows, but the `tidyverse` actually handles them with the same verbs.

There *is* a `bind_cols()` function, but it's easy to accidentally have the raspberries on the top in one table and the blueberries on the top in another, or to have one table sorted alphabetically and another by blinding code or participant ID, so it's safer to use the `*_join()` functions if you're adding columns instead of rows. `left_join()` is the most common.

We'll make up some demographic data to join to our existing table.


```r
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
```

```
## # A tibble: 7,507 × 93
##    `Subject Code` `Participant Name` `Start Time (UTC)` `End Time (UTC)`
##             <dbl>              <dbl> <chr>              <chr>           
##  1           1001               1001 6/13/2019 21:05    6/13/2019 21:09 
##  2           1001               1001 6/13/2019 20:55    6/13/2019 20:59 
##  3           1001               1001 6/13/2019 20:49    6/13/2019 20:53 
##  4           1001               1001 6/13/2019 20:45    6/13/2019 20:48 
##  5           1001               1001 6/13/2019 21:00    6/13/2019 21:03 
##  6           1001               1001 6/13/2019 21:10    6/13/2019 21:13 
##  7           1002               1002 6/13/2019 20:08    6/13/2019 20:11 
##  8           1002               1002 6/13/2019 19:57    6/13/2019 20:01 
##  9           1002               1002 6/13/2019 20:13    6/13/2019 20:17 
## 10           1002               1002 6/13/2019 20:03    6/13/2019 20:07 
## # ℹ 7,497 more rows
## # ℹ 89 more variables: `Serving Position` <dbl>, `Sample Identifier` <dbl>,
## #   `Sample Name` <chr>, `9pt_appearance` <dbl>, pre_expectation <dbl>,
## #   jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

`anti_join()` can be used to *remove* data. If you have a list of participants whose responses had data quality issues, you can put it in the second argument of `anti_join()` to return the lefthand table with those entries removed.

We do have some repeat participants in the berry tests, because they were allowed to participate for each berry type once. But in online surveys, repeat answers could be a problem necessitating all data removal. Let's demonstrate how we'd do that with `anti_join()`:


```r
problem_participants <-
  berry_data %>%
  group_by(`Participant Name`) %>%
  summarize(sessions = n_distinct(test_day)) %>%
  filter(sessions > 1)

berry_data %>%
  anti_join(problem_participants)
```

```
## Joining with `by = join_by(`Participant Name`)`
```

```
## # A tibble: 3,755 × 92
##    `Subject Code` `Participant Name` Gender Age   `Start Time (UTC)`
##             <dbl>              <dbl> <lgl>  <lgl> <chr>             
##  1           1001               1001 NA     NA    6/13/2019 21:05   
##  2           1001               1001 NA     NA    6/13/2019 20:55   
##  3           1001               1001 NA     NA    6/13/2019 20:49   
##  4           1001               1001 NA     NA    6/13/2019 20:45   
##  5           1001               1001 NA     NA    6/13/2019 21:00   
##  6           1001               1001 NA     NA    6/13/2019 21:10   
##  7           1002               1002 NA     NA    6/13/2019 20:08   
##  8           1002               1002 NA     NA    6/13/2019 19:57   
##  9           1002               1002 NA     NA    6/13/2019 20:13   
## 10           1002               1002 NA     NA    6/13/2019 20:03   
## # ℹ 3,745 more rows
## # ℹ 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

```r
#We don't need to specify by if they share the column name they're joining on
#and NO OTHERS
```

`anti_join()` also gives priority to the first/lefthand argument, usually the one you're piping in with `%>%`. It returns the rows in your left tibble that don't have corresponding entries in the righthand one. It also does *not* add the columns that are unique to your right table. There is no `n` column in the output.

## Utilities for data management

Honestly, the amount of power in `tidyverse` is way more than we can cover today, and is covered more comprehensively (obviously) by [Wickham and Grolemund](https://r4ds.had.co.nz/).  However, I want to name a few more utilities we will make a lot of use of today (and you will want to know about for your own work).

### Rename your columns

Often you will import data with bad column names or you'll realize you need to rename variables during your workflow. This is one way to get around having to type a bunch of backticks forever. For this, you can use the `rename()` function:


```r
names(berry_data)
```

```
##  [1] "Subject Code"                "Participant Name"           
##  [3] "Gender"                      "Age"                        
##  [5] "Start Time (UTC)"            "End Time (UTC)"             
##  [7] "Serving Position"            "Sample Identifier"          
##  [9] "Sample Name"                 "9pt_appearance"             
## [11] "pre_expectation"             "jar_color"                  
## [13] "jar_gloss"                   "jar_size"                   
## [15] "cata_appearance_unevencolor" "cata_appearance_misshapen"  
## [17] "cata_appearance_creased"     "cata_appearance_seedy"      
## [19] "cata_appearance_bruised"     "cata_appearance_notfresh"   
## [21] "cata_appearance_fresh"       "cata_appearance_goodshape"  
## [23] "cata_appearance_goodquality" "cata_appearance_none"       
## [25] "9pt_overall"                 "verbal_likes"               
## [27] "verbal_dislikes"             "9pt_taste"                  
## [29] "grid_sweetness"              "grid_tartness"              
## [31] "grid_raspberryflavor"        "jar_sweetness"              
## [33] "jar_tartness"                "cata_taste_floral"          
## [35] "cata_taste_berry"            "cata_taste_green"           
## [37] "cata_taste_grassy"           "cata_taste_fermented"       
## [39] "cata_taste_tropical"         "cata_taste_fruity"          
## [41] "cata_taste_citrus"           "cata_taste_earthy"          
## [43] "cata_taste_candy"            "cata_taste_none"            
## [45] "9pt_texture"                 "grid_seediness"             
## [47] "grid_firmness"               "grid_juiciness"             
## [49] "jar_firmness"                "jar_juciness"               
## [51] "post_expectation"            "price"                      
## [53] "product_tier"                "purchase_intent"            
## [55] "subject"                     "test_day"                   
## [57] "us_appearance"               "us_overall"                 
## [59] "us_taste"                    "us_texture"                 
## [61] "lms_appearance"              "lms_overall"                
## [63] "lms_taste"                   "lms_texture"                
## [65] "cata_appearane_bruised"      "cata_appearance_goodshapre" 
## [67] "cata_appearance_goodcolor"   "grid_blackberryflavor"      
## [69] "cata_taste_cinnamon"         "cata_taste_lemon"           
## [71] "cata_taste_clove"            "cata_taste_minty"           
## [73] "cata_taste_grape"            "grid_crispness"             
## [75] "jar_crispness"               "jar_juiciness"              
## [77] "cata_appearane_creased"      "grid_blueberryflavor"       
## [79] "cata_taste_piney"            "cata_taste_peachy"          
## [81] "9pt_aroma"                   "grid_strawberryflavor"      
## [83] "cata_taste_caramel"          "cata_taste_grapey"          
## [85] "cata_taste_melon"            "cata_taste_cherry"          
## [87] "grid_crunchiness"            "jar_crunch"                 
## [89] "us_aroma"                    "lms_aroma"                  
## [91] "berry"                       "sample"
```

```r
berry_data %>%
  rename(Sample = `Sample Name`,
         Subject = `Participant Name`) %>%
  select(Subject, Sample, everything()) #no more backticks!
```

```
## # A tibble: 7,507 × 92
##    Subject Sample      `Subject Code` Gender Age   `Start Time (UTC)`
##      <dbl> <chr>                <dbl> <lgl>  <lgl> <chr>             
##  1    1001 raspberry 6           1001 NA     NA    6/13/2019 21:05   
##  2    1001 raspberry 5           1001 NA     NA    6/13/2019 20:55   
##  3    1001 raspberry 2           1001 NA     NA    6/13/2019 20:49   
##  4    1001 raspberry 3           1001 NA     NA    6/13/2019 20:45   
##  5    1001 raspberry 4           1001 NA     NA    6/13/2019 21:00   
##  6    1001 raspberry 1           1001 NA     NA    6/13/2019 21:10   
##  7    1002 raspberry 6           1002 NA     NA    6/13/2019 20:08   
##  8    1002 raspberry 5           1002 NA     NA    6/13/2019 19:57   
##  9    1002 raspberry 2           1002 NA     NA    6/13/2019 20:13   
## 10    1002 raspberry 3           1002 NA     NA    6/13/2019 20:03   
## # ℹ 7,497 more rows
## # ℹ 86 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `9pt_appearance` <dbl>, pre_expectation <dbl>,
## #   jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

You can also rename by position, but be sure you have the right order and don't change the input data later:


```r
berry_data %>%
  rename(Subject = 1)
```

```
## # A tibble: 7,507 × 92
##    Subject `Participant Name` Gender Age   `Start Time (UTC)` `End Time (UTC)`
##      <dbl>              <dbl> <lgl>  <lgl> <chr>              <chr>           
##  1    1001               1001 NA     NA    6/13/2019 21:05    6/13/2019 21:09 
##  2    1001               1001 NA     NA    6/13/2019 20:55    6/13/2019 20:59 
##  3    1001               1001 NA     NA    6/13/2019 20:49    6/13/2019 20:53 
##  4    1001               1001 NA     NA    6/13/2019 20:45    6/13/2019 20:48 
##  5    1001               1001 NA     NA    6/13/2019 21:00    6/13/2019 21:03 
##  6    1001               1001 NA     NA    6/13/2019 21:10    6/13/2019 21:13 
##  7    1002               1002 NA     NA    6/13/2019 20:08    6/13/2019 20:11 
##  8    1002               1002 NA     NA    6/13/2019 19:57    6/13/2019 20:01 
##  9    1002               1002 NA     NA    6/13/2019 20:13    6/13/2019 20:17 
## 10    1002               1002 NA     NA    6/13/2019 20:03    6/13/2019 20:07 
## # ℹ 7,497 more rows
## # ℹ 86 more variables: `Serving Position` <dbl>, `Sample Identifier` <dbl>,
## #   `Sample Name` <chr>, `9pt_appearance` <dbl>, pre_expectation <dbl>,
## #   jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

### Relocate your columns

If you `mutate()` columns or just have a big data set with a lot of variables, often you want to move columns around.  This is a pain to do with `[]`, but again `tidyverse` has a utility to move things around easily: `relocate()`.


```r
berry_data %>%
  relocate(`Sample Name`) # giving no other arguments will move to front
```

```
## # A tibble: 7,507 × 92
##    `Sample Name` `Subject Code` `Participant Name` Gender Age  
##    <chr>                  <dbl>              <dbl> <lgl>  <lgl>
##  1 raspberry 6             1001               1001 NA     NA   
##  2 raspberry 5             1001               1001 NA     NA   
##  3 raspberry 2             1001               1001 NA     NA   
##  4 raspberry 3             1001               1001 NA     NA   
##  5 raspberry 4             1001               1001 NA     NA   
##  6 raspberry 1             1001               1001 NA     NA   
##  7 raspberry 6             1002               1002 NA     NA   
##  8 raspberry 5             1002               1002 NA     NA   
##  9 raspberry 2             1002               1002 NA     NA   
## 10 raspberry 3             1002               1002 NA     NA   
## # ℹ 7,497 more rows
## # ℹ 87 more variables: `Start Time (UTC)` <chr>, `End Time (UTC)` <chr>,
## #   `Serving Position` <dbl>, `Sample Identifier` <dbl>,
## #   `9pt_appearance` <dbl>, pre_expectation <dbl>, jar_color <dbl>,
## #   jar_gloss <dbl>, jar_size <dbl>, cata_appearance_unevencolor <dbl>,
## #   cata_appearance_misshapen <dbl>, cata_appearance_creased <dbl>,
## #   cata_appearance_seedy <dbl>, cata_appearance_bruised <dbl>, …
```

You can also use `relocate()` to specify positions


```r
berry_data %>%
  relocate(Gender, Age, `Subject Code`, `Start Time (UTC)`, `End Time (UTC)`, `Sample Identifier`, .after = berry) # move repetitive and empty columns to the end
```

```
## # A tibble: 7,507 × 92
##    `Participant Name` `Serving Position` `Sample Name` `9pt_appearance`
##                 <dbl>              <dbl> <chr>                    <dbl>
##  1               1001                  5 raspberry 6                  4
##  2               1001                  3 raspberry 5                  8
##  3               1001                  2 raspberry 2                  4
##  4               1001                  1 raspberry 3                  7
##  5               1001                  4 raspberry 4                  7
##  6               1001                  6 raspberry 1                  7
##  7               1002                  3 raspberry 6                  6
##  8               1002                  1 raspberry 5                  8
##  9               1002                  4 raspberry 2                  8
## 10               1002                  2 raspberry 3                  7
## # ℹ 7,497 more rows
## # ℹ 88 more variables: pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>,
## #   jar_size <dbl>, cata_appearance_unevencolor <dbl>,
## #   cata_appearance_misshapen <dbl>, cata_appearance_creased <dbl>,
## #   cata_appearance_seedy <dbl>, cata_appearance_bruised <dbl>,
## #   cata_appearance_notfresh <dbl>, cata_appearance_fresh <dbl>,
## #   cata_appearance_goodshape <dbl>, cata_appearance_goodquality <dbl>, …
```

### Remove missing values

Missing values (the `NA`s you've been seeing so much) can be a huge pain, because they make more of themselves.


```r
mean(berry_data$price) #This column had no NAs, so we can take the average
```

```
## [1] 2.962896
```

```r
mean(berry_data$`9pt_overall`) #This column has some NAs, so we get NA
```

```
## [1] NA
```
Many base R functions that take a vector and return some mathematical function (e.g., `mean()`, `sum()`, `sd()`) have an argument called `na.rm` that can be set to just act as if the values aren't there at all.


```r
mean(berry_data$`9pt_overall`, na.rm = TRUE) #We get the average of only the valid numbers
```

```
## [1] 5.679346
```

```r
sum(berry_data$`9pt_overall`, na.rm = TRUE) /
  length(berry_data$`9pt_overall`) #The denominator is NOT the same as the total number of values anymore
```

```
## [1] 1.84974
```

```r
sum(berry_data$`9pt_overall`, na.rm = TRUE) /
  sum(!is.na(berry_data$`9pt_overall`)) #The denominator is the number of non-NA values
```

```
## [1] 5.679346
```
However, this isn't always convenient. Sometimes it may be easier to simply get rid of all observations with any missing values, which tidyverse has a handy `drop_na()` function for:


```r
berry_data %>%
  drop_na() #All of our rows have *some* NA values, so this returns nothing
```

```
## # A tibble: 0 × 92
## # ℹ 92 variables: Subject Code <dbl>, Participant Name <dbl>, Gender <lgl>,
## #   Age <lgl>, Start Time (UTC) <chr>, End Time (UTC) <chr>,
## #   Serving Position <dbl>, Sample Identifier <dbl>, Sample Name <chr>,
## #   9pt_appearance <dbl>, pre_expectation <dbl>, jar_color <dbl>,
## #   jar_gloss <dbl>, jar_size <dbl>, cata_appearance_unevencolor <dbl>,
## #   cata_appearance_misshapen <dbl>, cata_appearance_creased <dbl>,
## #   cata_appearance_seedy <dbl>, cata_appearance_bruised <dbl>, …
```

```r
berry_data %>%
  select(`Participant Name`, `Sample Name`, contains("9pt_")) %>%
  drop_na() #Now we get only respondants who answered all 9-point liking questions.
```

```
## # A tibble: 600 × 7
##    `Participant Name` `Sample Name` `9pt_appearance` `9pt_overall` `9pt_taste`
##                 <dbl> <chr>                    <dbl>         <dbl>       <dbl>
##  1               2001 Strawberry4                  5             5           4
##  2               2001 Strawberry1                  6             2           2
##  3               2001 Strawberry2                  1             6           6
##  4               2001 Strawberry6                  3             3           2
##  5               2001 Strawberry3                  8             7           8
##  6               2001 Strawberry5                  4             6           6
##  7               2002 Strawberry4                  2             4           3
##  8               2002 Strawberry1                  4             6           7
##  9               2002 Strawberry2                  3             6           6
## 10               2002 Strawberry6                  7             7           8
## # ℹ 590 more rows
## # ℹ 2 more variables: `9pt_texture` <dbl>, `9pt_aroma` <dbl>
```

Or you may want to remove any columns/variables that have some missing data, which is one of the most common uses of `where()`:


```r
berry_data %>%
  select(where(~none(.x, is.na))) #Only 38 columns with absolutely no missing values.
```

```
## # A tibble: 7,507 × 38
##    `Subject Code` `Participant Name` `Start Time (UTC)` `End Time (UTC)`
##             <dbl>              <dbl> <chr>              <chr>           
##  1           1001               1001 6/13/2019 21:05    6/13/2019 21:09 
##  2           1001               1001 6/13/2019 20:55    6/13/2019 20:59 
##  3           1001               1001 6/13/2019 20:49    6/13/2019 20:53 
##  4           1001               1001 6/13/2019 20:45    6/13/2019 20:48 
##  5           1001               1001 6/13/2019 21:00    6/13/2019 21:03 
##  6           1001               1001 6/13/2019 21:10    6/13/2019 21:13 
##  7           1002               1002 6/13/2019 20:08    6/13/2019 20:11 
##  8           1002               1002 6/13/2019 19:57    6/13/2019 20:01 
##  9           1002               1002 6/13/2019 20:13    6/13/2019 20:17 
## 10           1002               1002 6/13/2019 20:03    6/13/2019 20:07 
## # ℹ 7,497 more rows
## # ℹ 34 more variables: `Serving Position` <dbl>, `Sample Identifier` <dbl>,
## #   `Sample Name` <chr>, pre_expectation <dbl>, jar_color <dbl>,
## #   jar_size <dbl>, cata_appearance_unevencolor <dbl>,
## #   cata_appearance_misshapen <dbl>, cata_appearance_notfresh <dbl>,
## #   cata_appearance_fresh <dbl>, cata_appearance_goodquality <dbl>,
## #   cata_appearance_none <dbl>, grid_sweetness <dbl>, grid_tartness <dbl>, …
```

```r
#This loses all of the liking data.
```

Both of the above methods guarantee that you will have an output with absolutely no missing data, but may be over-zealous if, say, everyone answered overall liking on one of the three scales and we want to do some work to combine those later. `filter()` and `select()` can be combined to do infinitely complex missing value removal.


```r
berry_data %>%
  select(where(~!every(.x, is.na))) %>% #remove columns with no data
  filter(!(is.na(`9pt_aroma`) & is.na(lms_aroma) & is.na(us_aroma)))
```

```
## # A tibble: 1,986 × 90
##    `Subject Code` `Participant Name` `Start Time (UTC)` `End Time (UTC)`
##             <dbl>              <dbl> <chr>              <chr>           
##  1           2001               2001 6/24/2019 20:18    6/24/2019 20:22 
##  2           2001               2001 6/24/2019 20:30    6/24/2019 20:35 
##  3           2001               2001 6/24/2019 20:23    6/24/2019 20:28 
##  4           2001               2001 6/24/2019 20:14    6/24/2019 20:17 
##  5           2001               2001 6/24/2019 20:35    6/24/2019 20:39 
##  6           2001               2001 6/24/2019 20:08    6/24/2019 20:13 
##  7           2002               2002 6/24/2019 20:21    6/24/2019 20:25 
##  8           2002               2002 6/24/2019 20:14    6/24/2019 20:17 
##  9           2002               2002 6/24/2019 19:59    6/24/2019 20:04 
## 10           2002               2002 6/24/2019 20:09    6/24/2019 20:13 
## # ℹ 1,976 more rows
## # ℹ 86 more variables: `Serving Position` <dbl>, `Sample Identifier` <dbl>,
## #   `Sample Name` <chr>, `9pt_appearance` <dbl>, pre_expectation <dbl>,
## #   jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

```r
#You'll notice that only strawberries have any non-NA liking values, actually
```

### Counting categorical variables

Often, we'll want to count how many observations are in a group without having to actually count ourselves. Do we have enough observations for each sample? How many people in each demographic category do we have? Is it balanced?

You've already written code to do this, if you've been following along! `summarize()` is incredibly powerful, and it will happily use *any* function that takes a vector or vectors and returns a single value. This includes categorical or `chr` data!


```r
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(n_responses = n())
```

```
## # A tibble: 23 × 2
##    `Sample Name` n_responses
##    <chr>               <int>
##  1 Blackberry 1          299
##  2 Blackberry 2          299
##  3 Blackberry 3          299
##  4 Blackberry 4          299
##  5 Blackberry 5          299
##  6 Blueberry 1           313
##  7 Blueberry 2           313
##  8 Blueberry 3           313
##  9 Blueberry 4           313
## 10 Blueberry 5           313
## # ℹ 13 more rows
```

We can also do this with a little less typing using `count()`, which is handy if we're repeatedly doing a lot of counting observations in various categories (like for CATA tests and Correspondence Analyses):


```r
berry_data %>%
  count(`Sample Name`) #Counts the number of observations (rows) of each berry
```

```
## # A tibble: 23 × 2
##    `Sample Name`     n
##    <chr>         <int>
##  1 Blackberry 1    299
##  2 Blackberry 2    299
##  3 Blackberry 3    299
##  4 Blackberry 4    299
##  5 Blackberry 5    299
##  6 Blueberry 1     313
##  7 Blueberry 2     313
##  8 Blueberry 3     313
##  9 Blueberry 4     313
## 10 Blueberry 5     313
## # ℹ 13 more rows
```

```r
berry_data %>%
  count(berry) #Number of observations, *not necessarily* the number of participants!
```

```
## # A tibble: 4 × 2
##   berry          n
##   <chr>      <int>
## 1 blackberry  1495
## 2 blueberry   1878
## 3 raspberry   2148
## 4 strawberry  1986
```

Depending on the shape of your data, the number of rows may or may not be the count you actually want. Maybe we want to know how many people participated in each day of testing, but we have one row per *tasting event*.

We could use `pivot_wider()` to reshape our data first, so we have one row per *completed tasting session*, but since `count()` drops most columns anyways, we only really need one row for each thing we care about. `distinct()` can be handy here. It keeps one row for each **distinct** combination of the columns you give it, getting rid of all other columns so it doesn't have to worry about the fact that one person gave multiple different `9pt_overall` ratings per `test_day`.


```r
berry_data %>%
  distinct(test_day, `Subject Code`)
```

```
## # A tibble: 1,301 × 2
##    test_day        `Subject Code`
##    <chr>                    <dbl>
##  1 Raspberry Day 1           1001
##  2 Raspberry Day 1           1002
##  3 Raspberry Day 1           1004
##  4 Raspberry Day 1           1005
##  5 Raspberry Day 1           1006
##  6 Raspberry Day 1           1007
##  7 Raspberry Day 1           1008
##  8 Raspberry Day 1           1009
##  9 Raspberry Day 1           1010
## 10 Raspberry Day 1           1011
## # ℹ 1,291 more rows
```

```r
#Two columns, with one row for each completed tasting session
#(each reflects 5-6 rows in the initial data)

berry_data %>%
  distinct(test_day, `Subject Code`) %>%
  count(test_day)
```

```
## # A tibble: 12 × 2
##    test_day             n
##    <chr>            <int>
##  1 Blackberry Day 1   108
##  2 Blackberry Day 2    88
##  3 Blackberry Day 3   103
##  4 Blueberry Day 1    102
##  5 Blueberry Day 2    114
##  6 Blueberry Day 3     97
##  7 Raspberry Day 1    131
##  8 Raspberry Day 2    120
##  9 Raspberry Day 3    107
## 10 Strawberry Day 1   108
## 11 Strawberry Day 2   106
## 12 Strawberry Day 3   117
```

```r
#Counts the number of participants per testing day
```

### Sort your data

More frequently, we will want to rearrange our rows, which can be done with `arrange()`.  All you have to do is give `arrange()` one or more columns to sort the data by.  You can use either the `desc()` or the `-` shortcut to sort in reverse order. Whether ascending or descending, `arrange()` places missing values at the bottom.


```r
berry_data %>%
  arrange(desc(lms_overall)) %>% # which berries had the highest liking on the lms?
  select(`Sample Name`, `Participant Name`, lms_overall)
```

```
## # A tibble: 7,507 × 3
##    `Sample Name` `Participant Name` lms_overall
##    <chr>                      <dbl>       <dbl>
##  1 raspberry 2                 5135         100
##  2 raspberry 6                 7033         100
##  3 Blackberry 4                5273         100
##  4 Blackberry 4                7135         100
##  5 Blackberry 3                7135         100
##  6 Blackberry 5                7135         100
##  7 Blueberry 5                 5113         100
##  8 Blueberry 6                 5127         100
##  9 Blueberry 3                 7040         100
## 10 Strawberry1                 1273         100
## # ℹ 7,497 more rows
```

You can sort alphabetically as well:


```r
tibble(state_name = state.name, area = state.area) %>% # using a dataset of US States for demonstration
  arrange(desc(state_name))                            # sort states reverse-alphabetically
```

```
## # A tibble: 50 × 2
##    state_name      area
##    <chr>          <dbl>
##  1 Wyoming        97914
##  2 Wisconsin      56154
##  3 West Virginia  24181
##  4 Washington     68192
##  5 Virginia       40815
##  6 Vermont         9609
##  7 Utah           84916
##  8 Texas         267339
##  9 Tennessee      42244
## 10 South Dakota   77047
## # ℹ 40 more rows
```

It's not a bad idea to restart your R session here.  Make sure to save your work, but a clean `Environment` is great when we're shifting topics.

You can accomplish this by going to `Session > Restart R` in the menu.

Then, we want to make sure to re-load our packages and import our data.


```r
# The packages we're using
library(tidyverse)
library(ca)

# The dataset
berry_data <- read_csv("data/clt-berry-data.csv")
```

```
## Rows: 7507 Columns: 92
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (7): Start Time (UTC), End Time (UTC), Sample Name, verbal_likes, verba...
## dbl (83): Subject Code, Participant Name, Serving Position, Sample Identifie...
## lgl  (2): Gender, Age
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```
