# Untidy Data Analysis



## Correspondence Analysis Overview

Remember what we said about most of the work of analysis being data wrangling? Now that we're about 2/3 of the way through this workshop, it's finally time to talk **data analysis**. The shape you need to wrangle your data *into* is determined by the analysis you want to run. Today, we have a bunch of **categorical data** and we want to understand the overall patterns within it. Which berries are **similar** and which are **different** from each other? Which sensory attributes are driving those differences?

One analysis well-suited to answer these questions for CATA and other categorical data is **Correspondence Analysis**. It's a singular value decomposition-based dimensionality-reduction method, so it's similar to Principal Component Analysis, but can be used when individual observations don't have numerical responses, or when the distances between those numbers (e.g., rankings) aren't meaningful.

We're using Correspondence Analysis as an example, so you can see the tidyverse in action! This is not intended to be a statistics lesson. If you want to understand the theoretical and mathematical underpinnings of Correspondence Analysis and its variations, we recommend Michael Greenacre's book [*Correspondence Analysis in Practice*](https://doi.org/10.1201/9781315369983). It was written by the author of the R package we'll be using today (`ca`), and includes R code in the appendix.

### The CA package

Let's take a look at this `ca` package!


```r
library(ca)

?ca
```

The first thing you'll see is that it wants, specifically, a data frame or matrix as `obj`. We'll be ignoring the `formula` option, because a frequency table stored as a matrix is more flexible: you can use it in other functions like those in the `FactoMineR` package.

A **frequency table** or **contingency table** is one way of numerically representing multiple categorical variables measured on the same set of observations. Each row represents one group of observations, each column represents one level of a given categorical variable, and the cells are filled with the number of observations in that group that fall into that level of the categorical variable.

The help file shows us an example of a frequency table included in base R, so we can take a look at the shape we need to match:


```r
data("author")
str(author)
```

```
##  num [1:12, 1:26] 550 515 590 557 589 541 517 592 576 557 ...
##  - attr(*, "dimnames")=List of 2
##   ..$ : chr [1:12] "three daughters (buck)" "drifters (michener)" "lost world (clark)" "east wind (buck)" ...
##   ..$ : chr [1:26] "a" "b" "c" "d" ...
```

```r
head(author)
```

```
##                                a   b   c   d    e   f   g   h   i j  k   l   m
## three daughters (buck)       550 116 147 374 1015 131 131 493 442 2 52 302 159
## drifters (michener)          515 109 172 311  827 167 136 376 432 8 61 280 146
## lost world (clark)           590 112 181 265  940 137 119 419 514 6 46 335 176
## east wind (buck)             557 129 128 343  996 158 129 571 555 4 76 291 247
## farewell to arms (hemingway) 589  72 129 339  866 108 159 449 472 7 59 264 158
## sound and fury 7 (faulkner)  541 109 136 228  763 126 129 401 520 5 72 280 209
##                                n   o   p q   r   s   t   u   v   w  x   y  z
## three daughters (buck)       534 516 115 4 409 467 632 174  66 155  5 150  3
## drifters (michener)          470 561 140 4 368 387 632 195  60 156 14 137  5
## lost world (clark)           403 505 147 8 395 464 670 224 113 146 13 162 10
## east wind (buck)             479 509  92 3 413 533 632 181  68 187 10 184  4
## farewell to arms (hemingway) 504 542  95 0 416 314 691 197  64 225  1 155  2
## sound and fury 7 (faulkner)  471 589  84 2 324 454 672 247  71 160 11 280  1
```

Now let's take a look at the **tidy** CATA data we need to convert into a frequency table:


```r
berry_data %>%
  select(`Sample Name`, `Subject Code`, starts_with("cata_"))
```

```
## # A tibble: 7,507 × 38
##    `Sample Name` `Subject Code` cata_appearance_unevenc…¹ cata_appearance_miss…²
##    <chr>                  <dbl>                     <dbl>                  <dbl>
##  1 raspberry 6             1001                         0                      1
##  2 raspberry 5             1001                         0                      0
##  3 raspberry 2             1001                         0                      0
##  4 raspberry 3             1001                         0                      0
##  5 raspberry 4             1001                         1                      1
##  6 raspberry 1             1001                         0                      0
##  7 raspberry 6             1002                         0                      0
##  8 raspberry 5             1002                         1                      0
##  9 raspberry 2             1002                         1                      0
## 10 raspberry 3             1002                         1                      0
## # ℹ 7,497 more rows
## # ℹ abbreviated names: ¹​cata_appearance_unevencolor, ²​cata_appearance_misshapen
## # ℹ 34 more variables: cata_appearance_creased <dbl>,
## #   cata_appearance_seedy <dbl>, cata_appearance_bruised <dbl>,
## #   cata_appearance_notfresh <dbl>, cata_appearance_fresh <dbl>,
## #   cata_appearance_goodshape <dbl>, cata_appearance_goodquality <dbl>,
## #   cata_appearance_none <dbl>, cata_taste_floral <dbl>, …
```

This is a pretty typical way for data collection software to save data from categorical questions like CATA and ordinal questions like JAR: one column per attribute. It's also, currently, a `tibble`, which is not in the list of objects that the `ca()` function will take.

We need to **untidy** our data to do this analysis, which is pretty common, but the `tidyverse` functions are still going to make it much easier than trying to reshape the data in base R. The makers of the packages have included some helpful functions for converting data *out of the tidyverse*, which we'll cover in a few minutes.

## Categorical, Character, Binomial, Binary, and Count data

Now, you might notice that, for categorical data, there are an awful lot of numbers in both of these tables. Without giving a whole statistics lesson, I want to take a minute to stress that the **data type** in R or another statistical software (`logical > integer > numeric > character`) is **not** necessarily the same as your statistical **level of measurement** (categorical/numerical or nominal/ordinal/interval/ratio).

It is your job as a sensory scientist and data analyst to understand what kind of data you have *based on how it was collected*, and select appropriate analyses accordingly.

In `berry_data$cata_*`, the data is represented as a 1 if that panelist checked that attribute for that sample, and a 0 otherwise. This could also be represented as a logical `TRUE` or `FALSE`, but the 0 and 1 convention makes binomial statistics most common, so you'll see it a lot.

You can also pretty easily convert between binomial/binary data stored as `numeric` 0s and 1s and `logical` data.


```r
testlogic <- c(TRUE,FALSE,FALSE)
testlogic
```

```
## [1]  TRUE FALSE FALSE
```

```r
class(testlogic) #We start with logical data
```

```
## [1] "logical"
```

```r
testnums <- as.numeric(testlogic) #as.numeric() turns FALSE to 0 and TRUE to 1
testnums
```

```
## [1] 1 0 0
```

```r
class(testnums) #Now it's numeric
```

```
## [1] "numeric"
```

```r
as.logical(testnums) #We can turn numeric to logical data the same way
```

```
## [1]  TRUE FALSE FALSE
```

```r
as.logical(c(0,1,2,3)) #Be careful with non-binary data, though!
```

```
## [1] FALSE  TRUE  TRUE  TRUE
```
You may also have your categorical data stored as a `character` type, namely if the categories are **mutually exclusive** or if you have free response data where there were not a finite/fixed set of options. The latter can quickly become thorny to deal with, because every single respondent could have their own unique categories that don't align with any others. Julia Silge and David Robinson's book [*Text Mining with R*](https://www.tidytextmining.com/) is a good primer for tidying and doing basic analysis of text data.

The first type of `character` data (with a limited number of mutually exclusive categories), thankfully, is much easier to deal with. We could turn the `berry` type variable into four separate **indicator variables** with 0s and 1s, if the analysis called for it, using `pivot_wider()`. Because we're turning *one column* into *multiple columns*, we're making the data wider, even though we don't actually want to make it any shorter.


```r
berry_data %>%
  mutate(presence = 1) %>%
  pivot_wider(names_from = berry,
              values_from = presence, values_fill = 0) %>%
  #The rest is just for visibility:
  select(ends_with("berry"), `Sample Name`, everything()) %>%
  arrange(lms_overall)
```

```
## # A tibble: 7,507 × 95
##    cata_taste_berry raspberry blackberry blueberry strawberry `Sample Name`
##               <dbl>     <dbl>      <dbl>     <dbl>      <dbl> <chr>        
##  1                0         1          0         0          0 raspberry 2  
##  2                0         0          0         0          1 Strawberry2  
##  3                0         1          0         0          0 raspberry 2  
##  4                0         1          0         0          0 raspberry 1  
##  5                0         1          0         0          0 raspberry 5  
##  6                0         0          1         0          0 Blackberry 1 
##  7                0         0          1         0          0 Blackberry 2 
##  8                0         0          0         1          0 Blueberry 2  
##  9                0         0          0         1          0 Blueberry 4  
## 10                0         0          0         0          1 Strawberry1  
## # ℹ 7,497 more rows
## # ℹ 89 more variables: `Subject Code` <dbl>, `Participant Name` <dbl>,
## #   Gender <lgl>, Age <lgl>, `Start Time (UTC)` <chr>, `End Time (UTC)` <chr>,
## #   `Serving Position` <dbl>, `Sample Identifier` <dbl>,
## #   `9pt_appearance` <dbl>, pre_expectation <dbl>, jar_color <dbl>,
## #   jar_gloss <dbl>, jar_size <dbl>, cata_appearance_unevencolor <dbl>,
## #   cata_appearance_misshapen <dbl>, cata_appearance_creased <dbl>, …
```

And we can see here that `pivot_wider()` increased the number of columns without decreasing the number of rows. By default, it will only combine rows where every column other than the `names_from` and `values_from` columns are identical.

It's often possible to convert between data types by changing the scope of your focus. **Summary tables** of categorical data can include numerical statistics (and this might give you a clue as to which `tidyverse` verb we're going to be using the most in this chapter). The most common kind of summary statistic for categorical variables is the **count** or **frequency**, which is where frequency tables get their name.


```r
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(starts_with("cata_"), sum))
```

```
## # A tibble: 23 × 37
##    `Sample Name` cata_appearance_unevencolor cata_appearance_misshapen
##    <chr>                               <dbl>                     <dbl>
##  1 Blackberry 1                           28                        67
##  2 Blackberry 2                           32                        72
##  3 Blackberry 3                           25                        50
##  4 Blackberry 4                           46                       114
##  5 Blackberry 5                           32                       144
##  6 Blueberry 1                            46                        13
##  7 Blueberry 2                            48                        25
##  8 Blueberry 3                            34                        37
##  9 Blueberry 4                            29                        26
## 10 Blueberry 5                            22                        35
## # ℹ 13 more rows
## # ℹ 34 more variables: cata_appearance_creased <dbl>,
## #   cata_appearance_seedy <dbl>, cata_appearance_bruised <dbl>,
## #   cata_appearance_notfresh <dbl>, cata_appearance_fresh <dbl>,
## #   cata_appearance_goodshape <dbl>, cata_appearance_goodquality <dbl>,
## #   cata_appearance_none <dbl>, cata_taste_floral <dbl>,
## #   cata_taste_berry <dbl>, cata_taste_green <dbl>, cata_taste_grassy <dbl>, …
```

Note that the there are some attributes with NA counts. If we reran the analysis with `na.rm = TRUE`, we'd see that these attributes have zero citations for the berries that were `NA` before. This is because some attributes were only relevant for some of the berries. You will have to think about whether and how to include any of these variables in your analysis.

For now, we'll just drop those terms.


```r
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(starts_with("cata_"), sum)) %>%
  select(where(~ none(.x, is.na))) -> berry_tidy_contingency

berry_tidy_contingency
```

```
## # A tibble: 23 × 14
##    `Sample Name` cata_appearance_unevencolor cata_appearance_misshapen
##    <chr>                               <dbl>                     <dbl>
##  1 Blackberry 1                           28                        67
##  2 Blackberry 2                           32                        72
##  3 Blackberry 3                           25                        50
##  4 Blackberry 4                           46                       114
##  5 Blackberry 5                           32                       144
##  6 Blueberry 1                            46                        13
##  7 Blueberry 2                            48                        25
##  8 Blueberry 3                            34                        37
##  9 Blueberry 4                            29                        26
## 10 Blueberry 5                            22                        35
## # ℹ 13 more rows
## # ℹ 11 more variables: cata_appearance_notfresh <dbl>,
## #   cata_appearance_fresh <dbl>, cata_appearance_goodquality <dbl>,
## #   cata_appearance_none <dbl>, cata_taste_floral <dbl>,
## #   cata_taste_berry <dbl>, cata_taste_grassy <dbl>,
## #   cata_taste_fermented <dbl>, cata_taste_fruity <dbl>,
## #   cata_taste_earthy <dbl>, cata_taste_none <dbl>
```

## Untidy Analysis
We have our contingency table now, right? That wasn't so hard! Let's do CA!


```r
berry_tidy_contingency %>%
  ca()
```

To explain why this error happens, we're going to need to talk a bit more about base R, since `ca` and many other data analysis packages aren't part of the `tidyverse`. Specifically, we need to talk about matrices and row names.

### Untidying Data

Let's take another look at the ways the example `author` dataset are different from our data.


```r
class(author)
```

```
## [1] "matrix" "array"
```

```r
dimnames(author)
```

```
## [[1]]
##  [1] "three daughters (buck)"       "drifters (michener)"         
##  [3] "lost world (clark)"           "east wind (buck)"            
##  [5] "farewell to arms (hemingway)" "sound and fury 7 (faulkner)" 
##  [7] "sound and fury 6 (faulkner)"  "profiles of future (clark)"  
##  [9] "islands (hemingway)"          "pendorric 3 (holt)"          
## [11] "asia (michener)"              "pendorric 2 (holt)"          
## 
## [[2]]
##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"
## [20] "t" "u" "v" "w" "x" "y" "z"
```

```r
class(berry_tidy_contingency)
```

```
## [1] "tbl_df"     "tbl"        "data.frame"
```

```r
dimnames(berry_tidy_contingency)
```

```
## [[1]]
##  [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10" "11" "12" "13" "14" "15"
## [16] "16" "17" "18" "19" "20" "21" "22" "23"
## 
## [[2]]
##  [1] "Sample Name"                 "cata_appearance_unevencolor"
##  [3] "cata_appearance_misshapen"   "cata_appearance_notfresh"   
##  [5] "cata_appearance_fresh"       "cata_appearance_goodquality"
##  [7] "cata_appearance_none"        "cata_taste_floral"          
##  [9] "cata_taste_berry"            "cata_taste_grassy"          
## [11] "cata_taste_fermented"        "cata_taste_fruity"          
## [13] "cata_taste_earthy"           "cata_taste_none"
```

The example data we're trying to replicate is a `matrix`. This is another kind of tabular data, similar to a `tibble` or `data.frame`. The thing that sets matrices apart is that *every single cell in a matrix has the same data type*. This is a property that a lot of matrix algebra relies upon, like the math underpinning Correspondence Analysis.

Because they're tabular, it's very easy to turn a `data.frame` *into* a `matrix`, like the `ca()` function alludes to in the help files.


```r
as.matrix(berry_tidy_contingency)
```

```
##       Sample Name    cata_appearance_unevencolor cata_appearance_misshapen
##  [1,] "Blackberry 1" " 28"                       " 67"                    
##  [2,] "Blackberry 2" " 32"                       " 72"                    
##  [3,] "Blackberry 3" " 25"                       " 50"                    
##  [4,] "Blackberry 4" " 46"                       "114"                    
##  [5,] "Blackberry 5" " 32"                       "144"                    
##  [6,] "Blueberry 1"  " 46"                       " 13"                    
##  [7,] "Blueberry 2"  " 48"                       " 25"                    
##  [8,] "Blueberry 3"  " 34"                       " 37"                    
##  [9,] "Blueberry 4"  " 29"                       " 26"                    
## [10,] "Blueberry 5"  " 22"                       " 35"                    
## [11,] "Blueberry 6"  " 43"                       " 45"                    
## [12,] "Strawberry1"  "192"                       " 18"                    
## [13,] "Strawberry2"  "213"                       " 51"                    
## [14,] "Strawberry3"  "139"                       " 24"                    
## [15,] "Strawberry4"  "144"                       " 25"                    
## [16,] "Strawberry5"  "160"                       " 32"                    
## [17,] "Strawberry6"  "197"                       " 87"                    
## [18,] "raspberry 1"  "126"                       " 52"                    
## [19,] "raspberry 2"  " 99"                       " 58"                    
## [20,] "raspberry 3"  "184"                       "100"                    
## [21,] "raspberry 4"  "112"                       " 56"                    
## [22,] "raspberry 5"  "121"                       " 43"                    
## [23,] "raspberry 6"  "116"                       " 45"                    
##       cata_appearance_notfresh cata_appearance_fresh
##  [1,] " 27"                    "191"                
##  [2,] " 37"                    "197"                
##  [3,] "  9"                    "222"                
##  [4,] " 38"                    "170"                
##  [5,] " 16"                    "197"                
##  [6,] " 20"                    "223"                
##  [7,] " 30"                    "203"                
##  [8,] " 40"                    "196"                
##  [9,] " 24"                    "219"                
## [10,] " 39"                    "209"                
## [11,] " 30"                    "198"                
## [12,] " 99"                    "129"                
## [13,] "155"                    " 65"                
## [14,] " 55"                    "185"                
## [15,] " 73"                    "156"                
## [16,] " 80"                    "168"                
## [17,] "226"                    " 38"                
## [18,] " 60"                    "228"                
## [19,] " 57"                    "216"                
## [20,] "111"                    "145"                
## [21,] " 75"                    "199"                
## [22,] " 59"                    "219"                
## [23,] " 61"                    "218"                
##       cata_appearance_goodquality cata_appearance_none cata_taste_floral
##  [1,] "172"                       " 3"                 "48"             
##  [2,] "170"                       " 2"                 "32"             
##  [3,] "204"                       " 4"                 "56"             
##  [4,] "152"                       " 1"                 "56"             
##  [5,] "161"                       " 3"                 "56"             
##  [6,] "208"                       " 3"                 "54"             
##  [7,] "202"                       " 3"                 "24"             
##  [8,] "189"                       " 1"                 "64"             
##  [9,] "198"                       " 3"                 "57"             
## [10,] "193"                       " 2"                 "49"             
## [11,] "201"                       " 5"                 "61"             
## [12,] " 92"                       " 0"                 "56"             
## [13,] " 63"                       " 4"                 "36"             
## [14,] "159"                       " 4"                 "39"             
## [15,] "121"                       " 1"                 "39"             
## [16,] "141"                       " 3"                 "34"             
## [17,] " 43"                       " 0"                 "46"             
## [18,] "206"                       " 1"                 "48"             
## [19,] "190"                       " 4"                 "63"             
## [20,] "127"                       " 1"                 "74"             
## [21,] "181"                       " 7"                 "60"             
## [22,] "196"                       " 3"                 "67"             
## [23,] "169"                       "12"                 "60"             
##       cata_taste_berry cata_taste_grassy cata_taste_fermented cata_taste_fruity
##  [1,] "155"            " 55"             "72"                 " 88"            
##  [2,] "127"            " 79"             "70"                 " 71"            
##  [3,] "161"            " 66"             "64"                 "107"            
##  [4,] "167"            " 53"             "21"                 "129"            
##  [5,] "183"            " 61"             "47"                 "115"            
##  [6,] "156"            " 69"             "22"                 "116"            
##  [7,] "182"            " 48"             "17"                 "134"            
##  [8,] "172"            " 73"             "33"                 "111"            
##  [9,] "171"            " 44"             "35"                 "125"            
## [10,] "180"            " 56"             "21"                 "120"            
## [11,] "218"            " 45"             "19"                 "155"            
## [12,] "204"            " 55"             "53"                 "172"            
## [13,] "144"            "113"             "59"                 "105"            
## [14,] "171"            " 77"             "37"                 "148"            
## [15,] "137"            "125"             "35"                 "111"            
## [16,] "201"            " 81"             "53"                 "164"            
## [17,] " 84"            "113"             "66"                 " 82"            
## [18,] "173"            "102"             "36"                 "122"            
## [19,] "217"            " 78"             "31"                 "156"            
## [20,] "266"            " 29"             "20"                 "213"            
## [21,] "198"            " 67"             "28"                 "151"            
## [22,] "231"            " 59"             "20"                 "175"            
## [23,] "268"            " 36"             "15"                 "212"            
##       cata_taste_earthy cata_taste_none
##  [1,] " 92"             "13"           
##  [2,] "102"             "24"           
##  [3,] " 82"             "13"           
##  [4,] " 51"             "36"           
##  [5,] " 72"             "19"           
##  [6,] " 67"             "19"           
##  [7,] " 35"             "25"           
##  [8,] " 67"             "11"           
##  [9,] " 55"             " 9"           
## [10,] " 60"             "24"           
## [11,] " 41"             " 6"           
## [12,] " 64"             "13"           
## [13,] "101"             "24"           
## [14,] " 57"             "26"           
## [15,] "100"             "24"           
## [16,] " 69"             "11"           
## [17,] "109"             "23"           
## [18,] " 90"             "19"           
## [19,] "100"             "21"           
## [20,] " 48"             "13"           
## [21,] " 82"             "17"           
## [22,] " 68"             "19"           
## [23,] " 47"             "14"
```

This is what the `ca()` function does for us when we give it a `data.frame` or `tibble`. It follows the hierarchy of data types, so you'll see that now every single number is surrounded by quotation marks now ("). It's been converted into the least-restrictive data type in `berry_tidy_contingency`, which is `character`.

Unfortunately, you can't do math on `character` vectors.


```r
1 + 2
"1" + "2"
```

It's important to know which row corresponds to which berry, though, so we want to keep the `Sample Name` column *somehow*! This is where `rownames` come in handy, which the `author` data has but our `berry_tidy_contingency` doesn't.

The `tidyverse` doesn't really use row names (it is technically *possible* to have a tibble with `rownames`, but extremely error-prone). The theory is that whatever information you *could* use as `rownames` could be added as another column, and that you may have multiple variables whose combined levels define each row (say the sample and the participant IDs) rather than needing a single less-informative ID unique to each row.

Row names are important to numeric matrices, though, because we can't do math on a matrix of character variables!

The `tidyverse` provides a handy function for this, `column_to_rownames()`:


```r
berry_tidy_contingency %>%
  column_to_rownames("Sample Name") -> berry_contingency_df

class(berry_contingency_df)
```

```
## [1] "data.frame"
```

```r
dimnames(berry_contingency_df)
```

```
## [[1]]
##  [1] "Blackberry 1" "Blackberry 2" "Blackberry 3" "Blackberry 4" "Blackberry 5"
##  [6] "Blueberry 1"  "Blueberry 2"  "Blueberry 3"  "Blueberry 4"  "Blueberry 5" 
## [11] "Blueberry 6"  "Strawberry1"  "Strawberry2"  "Strawberry3"  "Strawberry4" 
## [16] "Strawberry5"  "Strawberry6"  "raspberry 1"  "raspberry 2"  "raspberry 3" 
## [21] "raspberry 4"  "raspberry 5"  "raspberry 6" 
## 
## [[2]]
##  [1] "cata_appearance_unevencolor" "cata_appearance_misshapen"  
##  [3] "cata_appearance_notfresh"    "cata_appearance_fresh"      
##  [5] "cata_appearance_goodquality" "cata_appearance_none"       
##  [7] "cata_taste_floral"           "cata_taste_berry"           
##  [9] "cata_taste_grassy"           "cata_taste_fermented"       
## [11] "cata_taste_fruity"           "cata_taste_earthy"          
## [13] "cata_taste_none"
```
Note that you have to double-quote ("") column names for `column_to_rownames()`. No idea why. I just do what `?column_to_rownames` tells me.

`berry_contingency_df` is all set for the `ca()` function now, but if you run into any functions (like many of those in `FactoMineR` and other packages) that need matrices, you can always use `as.matrix()` on the results of `column_to_rownames()`.

`column_to_rownames()` will almost always be the cleanest way to untidy your data, but there are some other functions that may be handy if you need a different data format, like a vector. You already know about $-subsetting, but you can also use `pull()` to pull one column out of a `tibble` as a vector using tidyverse syntax, so it fits easily at the end or in the middle of a series of piped steps.


```r
berry_data %>%
  pivot_longer(starts_with("cata_"),
               names_to = "attribute",
               values_to = "presence") %>%
  filter(presence == 1) %>%
  count(attribute) %>%
  #Arranges the highest-cited CATA terms first
  arrange(desc(n)) %>% 
  #Pulls the attribute names as a vector, in the order above
  pull(attribute)      
```

```
##  [1] "cata_appearance_fresh"       "cata_taste_berry"           
##  [3] "cata_appearance_goodquality" "cata_appearance_goodshape"  
##  [5] "cata_taste_fruity"           "cata_appearance_goodcolor"  
##  [7] "cata_appearance_unevencolor" "cata_taste_earthy"          
##  [9] "cata_taste_grassy"           "cata_appearance_notfresh"   
## [11] "cata_taste_citrus"           "cata_appearance_misshapen"  
## [13] "cata_taste_floral"           "cata_appearance_bruised"    
## [15] "cata_taste_fermented"        "cata_appearance_goodshapre" 
## [17] "cata_appearance_seedy"       "cata_taste_peachy"          
## [19] "cata_taste_none"             "cata_taste_tropical"        
## [21] "cata_taste_candy"            "cata_taste_green"           
## [23] "cata_appearance_creased"     "cata_taste_piney"           
## [25] "cata_taste_lemon"            "cata_taste_grapey"          
## [27] "cata_taste_cherry"           "cata_appearane_bruised"     
## [29] "cata_taste_melon"            "cata_taste_grape"           
## [31] "cata_taste_clove"            "cata_taste_caramel"         
## [33] "cata_appearance_none"        "cata_appearane_creased"     
## [35] "cata_taste_minty"            "cata_taste_cinnamon"
```

In summary:
- Reshape your data in the `tidyverse` and then change it as needed for analysis.
- If you need a `data.frame` or `matrix` with `rownames` set, use `column_to_rownames()`.
- Use `as.matrix()` carefully, only on tabular data with **all the same data type**.
- `as.matrix()` may not work on `tibble`s *at all* in older versions of the `tidyverse`, so it's always safest to go `tibble` -> `data.frame` -> `matrix`.
- If you need a vector, use `pull()`.

### Data Analysis

Okay, are you ready? Our data is *finally* in the shape and format we needed. You're ready to run multivariate statistics in R.

Ready?

Are you sure?


```r
ca(berry_contingency_df) -> berry_ca_res
```

Yep, that's it.

There are other options you can read about in the help files, if you need a more sophisticated analysis, but most of the time, if I need to change something, it's with the way I'm arranging my data *before* analysis rather than fundamentally changing the `ca()` call.

In general, I find it easiest to do all of the filtering and selecting *on the tibble* so I can use the handy `tidyverse` functions, before I untidy the data, but you can also include extra rows or columns in your contingency table (as long as they're also numbers!!) and then tell the `ca()` function which columns are active and supplemental. This may be an easier way to compare a few different analyses with different variables or levels of summarization, rather than having to make a bunch of different contingency matrices for each.


```r
berry_data %>%
  select(`Sample Name`, contains(c("cata_", "9pt_", "lms_", "us_"))) %>%
  summarize(across(contains("cata_"), ~ sum(.x, na.rm = TRUE)),
            across(contains(c("9pt_","lms_","us_")), ~ mean(.x, na.rm = TRUE)), .by = `Sample Name`) %>%
  column_to_rownames("Sample Name") %>%
  #You have to know the NUMERIC indices to do it this way.
  ca(supcol = 37:51) 
```

```
## 
##  Principal inertias (eigenvalues):
##            1        2        3        4        5        6        7       
## Value      0.295123 0.148008 0.109166 0.033574 0.016535 0.010195 0.007532
## Percentage 46.03%   23.09%   17.03%   5.24%    2.58%    1.59%    1.17%   
##            8       9        10       11      12       13       14      
## Value      0.00576 0.003221 0.002931 0.00244 0.001342 0.001226 0.001024
## Percentage 0.9%    0.5%     0.46%    0.38%   0.21%    0.19%    0.16%   
##            15       16       17       18      19       20       21      
## Value      0.000914 0.000631 0.000562 0.00036 0.000227 0.000155 0.000123
## Percentage 0.14%    0.1%     0.09%    0.06%   0.04%    0.02%    0.02%   
##            22     
## Value      4.8e-05
## Percentage 0.01%  
## 
## 
##  Rows:
##         raspberry 6 raspberry 5 raspberry 2 raspberry 3 raspberry 4 raspberry 1
## Mass       0.047104    0.047309    0.046566    0.048898    0.046797    0.046745
## ChiDist    0.701154    0.597664    0.544036    0.778030    0.603364    0.588880
## Inertia    0.023157    0.016899    0.013782    0.029599    0.017036    0.016210
## Dim. 1     0.539265    0.541430    0.498086    0.695131    0.597405    0.528684
## Dim. 2     0.936377    0.758876    0.559180    0.455674    0.602968    0.588395
##         Blackberry 4 Blackberry 2 Blackberry 1 Blackberry 3 Blackberry 5
## Mass        0.038160     0.039979     0.040569     0.041850     0.039672
## ChiDist     0.987037     1.105960     1.166375     1.113777     0.910491
## Inertia     0.037177     0.048901     0.055191     0.051915     0.032888
## Dim. 1     -1.589369    -1.864827    -1.959700    -1.884164    -1.525017
## Dim. 2     -0.699024    -0.999143    -1.019725    -0.767436    -0.525974
##         Blueberry 1 Blueberry 4 Blueberry 2 Blueberry 3 Blueberry 5 Blueberry 6
## Mass       0.040774    0.041235    0.040979    0.042209    0.041363    0.043234
## ChiDist    0.703408    0.648461    0.608480    0.638924    0.636871    0.635531
## Inertia    0.020174    0.017339    0.015172    0.017231    0.016777    0.017462
## Dim. 1    -0.284508   -0.300322   -0.151757   -0.294232   -0.287190   -0.261262
## Dim. 2     1.230837    1.164323    1.114938    1.095328    1.124883    1.167484
##         Strawberry4 Strawberry1 Strawberry2 Strawberry6 Strawberry3 Strawberry5
## Mass       0.043875    0.046643    0.043849    0.043824    0.043106    0.045259
## ChiDist    0.711993    1.037185    0.879538    1.102282    0.613945    0.636763
## Inertia    0.022242    0.050176    0.033921    0.053247    0.016248    0.018351
## Dim. 1     0.915361    1.082511    1.092504    1.155009    0.762252    0.816533
## Dim. 2    -0.968446   -1.424927   -1.542342   -1.688415   -0.549006   -0.794523
## 
## 
##  Columns:
##         cata_appearance_unevencolor cata_appearance_misshapen
## Mass                       0.056074                  0.031240
## ChiDist                    0.624470                  0.632738
## Inertia                    0.021867                  0.012507
## Dim. 1                     0.954959                 -0.541613
## Dim. 2                    -0.794647                 -0.478410
##         cata_appearance_creased cata_appearance_seedy cata_appearance_bruised
## Mass                   0.006663              0.015838                0.027986
## ChiDist                1.107665              1.738786                1.105926
## Inertia                0.008175              0.047884                0.034228
## Dim. 1                 1.443844              1.752834                1.463469
## Dim. 2                -0.717471             -2.632660               -1.526336
##         cata_appearance_notfresh cata_appearance_fresh
## Mass                    0.036417              0.107406
## ChiDist                 0.754184              0.277362
## Inertia                 0.020714              0.008263
## Dim. 1                  0.889423             -0.307694
## Dim. 2                 -1.022464              0.452318
##         cata_appearance_goodshape cata_appearance_goodquality
## Mass                     0.093311                    0.095797
## ChiDist                  0.550292                    0.296273
## Inertia                  0.028257                    0.008409
## Dim. 1                   0.660358                   -0.332910
## Dim. 2                   0.965680                    0.529804
##         cata_appearance_none cata_taste_floral cata_taste_berry
## Mass                0.001794          0.030215         0.106766
## ChiDist             0.789222          0.223386         0.192937
## Inertia             0.001117          0.001508         0.003974
## Dim. 1             -0.037264         -0.093179        -0.001625
## Dim. 2              0.690895          0.230931         0.291399
##         cata_taste_green cata_taste_grassy cata_taste_fermented
## Mass            0.007945          0.040595             0.022399
## ChiDist         1.679549          0.354579             0.501741
## Inertia         0.022411          0.005104             0.005639
## Dim. 1          1.022314          0.128887            -0.319566
## Dim. 2          1.693699         -0.500564            -1.022115
##         cata_taste_tropical cata_taste_fruity cata_taste_citrus
## Mass               0.010687          0.078985          0.032471
## ChiDist            1.669061          0.225740          0.650213
## Inertia            0.029771          0.004025          0.013728
## Dim. 1             1.067362          0.148197          0.820933
## Dim. 2             1.699332          0.249386          0.714076
##         cata_taste_earthy cata_taste_candy cata_taste_none
## Mass             0.042517         0.008278        0.010841
## ChiDist          0.298491         1.656958        0.405144
## Inertia          0.003788         0.022727        0.001779
## Dim. 1          -0.072856         1.067984       -0.127751
## Dim. 2          -0.463882         1.685638       -0.298570
##         cata_appearane_bruised cata_appearance_goodshapre
## Mass                  0.004869                   0.020169
## ChiDist               2.101907                   2.040213
## Inertia               0.021513                   0.083953
## Dim. 1               -3.226349                  -3.308097
## Dim. 2               -2.103976                  -2.154730
##         cata_appearance_goodcolor cata_taste_cinnamon cata_taste_lemon
## Mass                     0.058944            0.000948         0.006023
## ChiDist                  1.107046            2.121291         2.088847
## Inertia                  0.072239            0.004267         0.026278
## Dim. 1                  -1.735961           -3.328963        -3.317694
## Dim. 2                   0.698509           -2.141693        -2.201850
##         cata_taste_clove cata_taste_minty cata_taste_grape
## Mass            0.002383         0.001256         0.003998
## ChiDist         2.103524         2.036370         2.072312
## Inertia         0.010546         0.005207         0.017169
## Dim. 1         -3.313433        -3.286100        -3.318432
## Dim. 2         -2.132266        -2.105219        -2.191008
##         cata_appearane_creased cata_taste_piney cata_taste_peachy
## Mass                  0.001281         0.006407          0.011353
## ChiDist               1.920294         1.831149          1.144327
## Inertia               0.004725         0.021483          0.014867
## Dim. 1               -0.489183        -0.500874          0.309423
## Dim. 2                2.954184         3.007418          0.883482
##         cata_taste_caramel cata_taste_grapey cata_taste_melon cata_taste_cherry
## Mass              0.001896          0.005843         0.004767          0.005638
## ChiDist           1.794449          1.668738         1.711006          1.718018
## Inertia           0.006107          0.016271         0.013955          0.016641
## Dim. 1            1.768170          1.775356         1.792723          1.761788
## Dim. 2           -2.946463         -2.971754        -3.038976         -2.919189
##         9pt_appearance (*) 9pt_overall (*) 9pt_taste (*) 9pt_texture (*)
## Mass                    NA              NA            NA              NA
## ChiDist           0.130697        0.102893      0.113246        0.096145
## Inertia                 NA              NA            NA              NA
## Dim. 1           -0.186168       -0.075320     -0.076711       -0.101059
## Dim. 2            0.143741        0.095335      0.129310        0.066306
##         9pt_aroma (*) lms_appearance (*) lms_overall (*) lms_taste (*)
## Mass               NA                 NA              NA            NA
## ChiDist           NaN           0.463025        0.502031      0.687212
## Inertia            NA                 NA              NA            NA
## Dim. 1            NaN          -0.588691        0.019500      0.024678
## Dim. 2            NaN           0.687830        0.735511      1.065640
##         lms_texture (*) lms_aroma (*) us_appearance (*) us_overall (*)
## Mass                 NA            NA                NA             NA
## ChiDist        0.331814           NaN          0.169497       0.128866
## Inertia              NA            NA                NA             NA
## Dim. 1        -0.198320           NaN         -0.234714      -0.084274
## Dim. 2         0.436500           NaN          0.211381       0.195086
##         us_taste (*) us_texture (*) us_aroma (*)
## Mass              NA             NA           NA
## ChiDist     0.149586       0.111795          NaN
## Inertia           NA             NA           NA
## Dim. 1     -0.070870      -0.117917          NaN
## Dim. 2      0.225916       0.128712          NaN
```

### Retidying Data

What does the `ca()` function actually give us?


```r
berry_ca_res %>%
  str()
```

```
## List of 16
##  $ sv        : num [1:12] 0.2958 0.1659 0.133 0.0724 0.0647 ...
##  $ nd        : logi NA
##  $ rownames  : chr [1:23] "Blackberry 1" "Blackberry 2" "Blackberry 3" "Blackberry 4" ...
##  $ rowmass   : num [1:23] 0.0392 0.0394 0.0412 0.0401 0.0429 ...
##  $ rowdist   : num [1:23] 0.364 0.399 0.376 0.379 0.468 ...
##  $ rowinertia: num [1:23] 0.00519 0.00625 0.00583 0.00575 0.00941 ...
##  $ rowcoord  : num [1:23, 1:12] -0.676 -0.461 -1.025 -0.476 -0.738 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:23] "Blackberry 1" "Blackberry 2" "Blackberry 3" "Blackberry 4" ...
##   .. ..$ : chr [1:12] "Dim1" "Dim2" "Dim3" "Dim4" ...
##  $ rowsup    : logi(0) 
##  $ colnames  : chr [1:13] "cata_appearance_unevencolor" "cata_appearance_misshapen" "cata_appearance_notfresh" "cata_appearance_fresh" ...
##  $ colmass   : num [1:13] 0.0848 0.0473 0.0551 0.1625 0.1449 ...
##  $ coldist   : num [1:13] 0.618 0.599 0.755 0.285 0.31 ...
##  $ colinertia: num [1:13] 0.0324 0.017 0.0314 0.0132 0.0139 ...
##  $ colcoord  : num [1:13, 1:12] 1.9366 0.0589 2.4533 -0.9373 -0.9973 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:13] "cata_appearance_unevencolor" "cata_appearance_misshapen" "cata_appearance_notfresh" "cata_appearance_fresh" ...
##   .. ..$ : chr [1:12] "Dim1" "Dim2" "Dim3" "Dim4" ...
##  $ colsup    : logi(0) 
##  $ N         : num [1:23, 1:13] 28 32 25 46 32 46 48 34 29 22 ...
##  $ call      : language ca.matrix(obj = as.matrix(obj))
##  - attr(*, "class")= chr "ca"
```
It's a list with many useful things. You can think of a list as kinda like a data frame, because each item has a **name** (like columns in data frames), except they can be any length/size/shape. It's *not* tabular, so you can't use [1,2] for indexing rows and columns, but you *can* use $ indexing if you know the name of the data you're after.

You're unlikely to need to worry about the specifics. Just remember that lists can be $-indexed.

There are a few things we may want out of the list that `ca()` gives us, and we can see descriptions of them in plain English by typing `?ca`. These are the ones we'll be using:


```r
berry_ca_res$rowcoord #the standard coordinates of the row variable (berry)
```

```
##                      Dim1        Dim2        Dim3       Dim4         Dim5
## Blackberry 1 -0.676422039  1.55801517  0.02889809 -2.1207457  0.421035244
## Blackberry 2 -0.460988133  2.16220762  0.44500036 -0.6763648 -0.401344347
## Blackberry 3 -1.025439995  1.02861582  0.58873600 -1.5512728  0.149090611
## Blackberry 4 -0.475531553  0.73822421 -2.14355819  1.8024546 -1.054134662
## Blackberry 5 -0.737948756  1.55341431 -2.29069697 -0.3768377 -1.478964909
## Blueberry 1  -0.942208700 -0.16697306  1.34533986  0.9721393  0.341902827
## Blueberry 2  -0.891383712 -0.73549822  0.46896273  1.3567656 -0.058683995
## Blueberry 3  -0.693395862  0.30840131  0.49784640  0.2667007  1.452589890
## Blueberry 4  -1.062846799 -0.19768031  0.54029846 -0.6011662  1.453852344
## Blueberry 5  -0.903946503  0.01258835  0.29565501  1.3192008  1.250783134
## Blueberry 6  -0.911518977 -0.80933135 -0.45676687 -0.1166850  1.177305333
## Strawberry1   1.123787175 -1.29134698  0.30029870 -1.9371408 -0.269928992
## Strawberry2   2.186526847  0.39020970  0.46639303 -0.0688568 -0.454494991
## Strawberry3   0.216458365 -0.68408859  0.84099468  0.1817546 -1.474293484
## Strawberry4   0.779921416  0.31126088  1.56706081  1.0718960 -1.737282915
## Strawberry5   0.595885377 -0.65590705  0.58277734 -1.2198681 -0.852687372
## Strawberry6   2.890807350  1.51710457 -0.40231055  0.8846827  2.338783198
## raspberry 1   0.002784249  0.24770479  0.77952820  0.7647137 -0.914998126
## raspberry 2  -0.181932219 -0.05470297  0.05660525  0.2948372 -0.159554062
## raspberry 3   0.714829561 -1.32650761 -2.11426476 -0.3861240  0.086736116
## raspberry 4   0.041631118 -0.30336432 -0.10035713  0.3256547  0.412286985
## raspberry 5  -0.177484391 -0.92080171 -0.04037283  0.3511281 -0.003814396
## raspberry 6  -0.239619991 -1.64119492 -0.69498878 -0.3495728  0.259177191
##                      Dim6         Dim7        Dim8        Dim9      Dim10
## Blackberry 1  0.416339437 -0.087205574  0.55527540  0.66487134  0.7992141
## Blackberry 2  1.353241139 -0.143661403  0.31809116  0.82018151  1.3393069
## Blackberry 3 -0.154464899 -0.009161493  0.17303241 -0.07476922 -1.5859313
## Blackberry 4  0.604303775  1.121173149  1.61580941 -0.44455523 -1.3036853
## Blackberry 5 -0.652553200 -0.503141105 -0.95611885 -0.76061578 -0.2891770
## Blueberry 1  -0.708842996  0.275826588  0.50857290  0.94363142 -1.0496073
## Blueberry 2   3.082539058  0.538179530 -1.16634324 -0.43368257  1.1514695
## Blueberry 3  -1.525570006  0.767208280 -0.17612888 -1.96339520 -0.1572088
## Blueberry 4  -0.121844931  0.606785673 -0.26607669  0.49314835 -0.9894949
## Blueberry 5   0.820976326  0.475499585  1.30639341 -0.73014319  1.4665355
## Blueberry 6  -0.582502705 -0.563767160 -1.33239601 -1.94597487 -0.2792107
## Strawberry1   0.003367573  1.980558028  1.56631289 -0.17821445 -0.0413237
## Strawberry2   0.333203747 -1.237545485  0.45004439 -0.95562013  0.1394031
## Strawberry3   1.174373617  0.381298231  0.06195272  0.41063042 -2.2704383
## Strawberry4  -1.577928830 -0.329844134  0.71300614 -1.32879302  0.5226638
## Strawberry5   0.761511155  0.054789811 -1.58761812 -1.24962440  0.5416557
## Strawberry6   0.483756496  0.160111078 -0.57887026  0.34590501 -0.8335918
## raspberry 1  -0.901156816  0.498483211 -2.30064883  1.53815305  0.2120347
## raspberry 2  -1.041068949 -0.750258551  1.07509047  0.55799211  1.7404352
## raspberry 3  -0.577370181  1.175513729 -0.54472390  0.75571365  0.9693176
## raspberry 4  -0.435287990 -1.543719337 -0.11575622  1.57370723 -0.2755199
## raspberry 5  -0.678042187  0.444107106  0.28159320  1.09950507  0.3868386
## raspberry 6   0.697218086 -2.755894177  0.71155298  0.04135319 -0.5673104
##                    Dim11        Dim12
## Blackberry 1 -0.95983642 -0.009253265
## Blackberry 2  0.68731238  0.267060332
## Blackberry 3 -0.69717059 -1.168003875
## Blackberry 4 -0.22875124 -0.894559086
## Blackberry 5  0.74883806  1.156346478
## Blueberry 1  -0.33120184 -0.408429808
## Blueberry 2  -0.67185606 -0.519204536
## Blueberry 3  -0.29921710  1.327706362
## Blueberry 4   1.24943134  0.309664418
## Blueberry 5   0.54425299  1.516555388
## Blueberry 6  -1.24454179 -1.159488529
## Strawberry1   0.49720288  0.715403472
## Strawberry2  -2.84848835  1.293593154
## Strawberry3  -0.36073715  0.084475487
## Strawberry4   1.45255686 -0.678893230
## Strawberry5   1.25779330 -1.359994255
## Strawberry6   1.22987860 -0.669642985
## raspberry 1  -0.04656501  1.543167644
## raspberry 2  -0.10284611 -1.758554927
## raspberry 3  -0.40241340 -0.328363440
## raspberry 4  -0.43059527 -0.823009716
## raspberry 5  -0.56755742  0.383635858
## raspberry 6   1.44742716  1.252192647
```

```r
berry_ca_res$colcoord #the standard coordinates of the column variable (attribute)
```

```
##                                   Dim1        Dim2        Dim3       Dim4
## cata_appearance_unevencolor  1.9366137 -1.17322492  0.32072486 -0.3691085
## cata_appearance_misshapen    0.0589441  2.05113772 -3.66060544  0.3531013
## cata_appearance_notfresh     2.4532684  0.16152199 -0.22489458  0.9952467
## cata_appearance_fresh       -0.9372699  0.02467928  0.44045357  0.1240773
## cata_appearance_goodquality -0.9973472  0.08087827  0.50595892  0.4849384
## cata_appearance_none        -0.7937563 -1.48244462 -0.16563013 -1.4180918
## cata_taste_floral           -0.2815016 -0.15570463 -0.66082635 -0.2243516
## cata_taste_berry            -0.3325407 -0.79022119 -0.46021047 -0.4352527
## cata_taste_grassy            0.5978264  1.20258057  1.48981642  1.2955302
## cata_taste_fermented         0.4853398  2.23871239  0.82509530 -3.9589988
## cata_taste_fruity           -0.1224089 -1.18256562 -0.46550861 -0.2273194
## cata_taste_earthy            0.3549054  1.43796995  0.85550318 -0.3491357
## cata_taste_none              0.1207429  0.96539923 -0.03486454  3.5345743
##                                    Dim5       Dim6         Dim7       Dim8
## cata_appearance_unevencolor -1.62005938 -0.3774736   0.30154586 -0.6335252
## cata_appearance_misshapen   -1.00603555 -0.2124960  -0.23927488 -1.0951641
## cata_appearance_notfresh     2.86890300  1.0263872  -0.05545059 -0.3850610
## cata_appearance_fresh       -0.10863293  0.1414962   0.04397075 -0.2062730
## cata_appearance_goodquality  0.52975420  0.3327724   0.34250974 -1.0731454
## cata_appearance_none         0.69017805  3.2913350 -17.00616406  1.3294917
## cata_taste_floral            1.49728372 -2.8193315   0.86406459  1.8336607
## cata_taste_berry             0.03456135  0.0893703  -0.21406092  0.2679412
## cata_taste_grassy           -0.96800100 -1.0235468  -0.48915622 -0.7017379
## cata_taste_fermented         0.10594194  1.8898178   1.03877228  0.3000662
## cata_taste_fruity           -0.14530173  0.2930711   0.08434588  0.4291713
## cata_taste_earthy           -0.01891776 -1.2013919  -0.99644609  1.3593894
## cata_taste_none             -2.05265315  3.7122409   1.34673737  4.8331118
##                                    Dim9      Dim10       Dim11       Dim12
## cata_appearance_unevencolor  1.22816392 -0.4084541 -0.62254913  0.31727241
## cata_appearance_misshapen    0.26709095 -0.1111936  0.11384684 -0.11854340
## cata_appearance_notfresh     0.06475031  0.2590012  0.65050805  0.36937808
## cata_appearance_fresh        0.81170689 -0.1700575  1.47757553  1.05774152
## cata_appearance_goodquality  0.47718892 -0.1537466 -1.36294181 -0.79924373
## cata_appearance_none         1.45853357 -7.0630004 -2.76411379  0.82437204
## cata_taste_floral            0.12638909 -2.2281270 -0.79295431  0.61533873
## cata_taste_berry            -0.98297215  1.2341189 -0.68568963  0.98439275
## cata_taste_grassy           -2.52321861 -0.6268628  0.30656609  0.11219358
## cata_taste_fermented        -0.78605241 -1.2096748 -0.26064110  0.09947975
## cata_taste_fruity           -0.65205090 -0.3340588  1.11961579 -1.89705359
## cata_taste_earthy            1.24888861  2.0332988  0.06165682 -1.23209187
## cata_taste_none              0.41381134 -0.8624509 -1.47668343  0.52466551
```

```r
berry_ca_res$sv       #the singular value for each dimension
```

```
##  [1] 0.295838428 0.165865288 0.132976201 0.072363931 0.064690580 0.044807235
##  [7] 0.038031617 0.029774848 0.024918839 0.021300214 0.014415082 0.008117431
```

```r
berry_ca_res$sv %>%   #which are useful in calculating the % inertia of each dimension
  {.^2 / sum(.^2)}
```

```
##  [1] 0.5920550825 0.1861075348 0.1196191706 0.0354239712 0.0283096845
##  [6] 0.0135815468 0.0097845873 0.0059972484 0.0042005733 0.0030691695
## [11] 0.0014056824 0.0004457488
```

```r
#The column and row masses (in case you want to add your own supplementary variables
#after the fact):

#the row masses
berry_ca_res$rowmass  
```

```
##  [1] 0.03919516 0.03935024 0.04121113 0.04008684 0.04287819 0.03938901
##  [7] 0.03783826 0.03985423 0.03857486 0.03915639 0.04136621 0.04446771
## [13] 0.04392494 0.04345972 0.04229666 0.04640614 0.04318834 0.04896488
## [19] 0.05001163 0.05160115 0.04780181 0.04962394 0.04935256
```

```r
#the column masses
berry_ca_res$colmass  
```

```
##  [1] 0.084825929 0.047259052 0.055090331 0.162479646 0.144917423 0.002713809
##  [7] 0.045708304 0.161510429 0.061409630 0.033883849 0.119485152 0.064317283
## [13] 0.016399163
```

The *main* results of CA are the row and column coordinates, which are in two matrices with the same columns. We can tidy them with the reverse of `column_to_rownames()`, `rownames_to_column()`, and then we can use `bind_rows()` to combine them.


```r
berry_row_coords <- berry_ca_res$rowcoord %>%
  #rownames_to_column() works on data.frames, not matrices
  as.data.frame() %>% 
  #This has to be the same for both to use bind_rows()!
  rownames_to_column("Variable") 

#Equivalent to the above, and works on matrices
berry_col_coords <- berry_ca_res$colcoord %>%
  as_tibble(rownames = "Variable")

berry_ca_coords <- bind_rows(Berry = berry_row_coords,
                             Attribute = berry_col_coords,
                             .id = "Type")

berry_ca_coords
```

```
##         Type                    Variable         Dim1        Dim2        Dim3
## 1      Berry                Blackberry 1 -0.676422039  1.55801517  0.02889809
## 2      Berry                Blackberry 2 -0.460988133  2.16220762  0.44500036
## 3      Berry                Blackberry 3 -1.025439995  1.02861582  0.58873600
## 4      Berry                Blackberry 4 -0.475531553  0.73822421 -2.14355819
## 5      Berry                Blackberry 5 -0.737948756  1.55341431 -2.29069697
## 6      Berry                 Blueberry 1 -0.942208700 -0.16697306  1.34533986
## 7      Berry                 Blueberry 2 -0.891383712 -0.73549822  0.46896273
## 8      Berry                 Blueberry 3 -0.693395862  0.30840131  0.49784640
## 9      Berry                 Blueberry 4 -1.062846799 -0.19768031  0.54029846
## 10     Berry                 Blueberry 5 -0.903946503  0.01258835  0.29565501
## 11     Berry                 Blueberry 6 -0.911518977 -0.80933135 -0.45676687
## 12     Berry                 Strawberry1  1.123787175 -1.29134698  0.30029870
## 13     Berry                 Strawberry2  2.186526847  0.39020970  0.46639303
## 14     Berry                 Strawberry3  0.216458365 -0.68408859  0.84099468
## 15     Berry                 Strawberry4  0.779921416  0.31126088  1.56706081
## 16     Berry                 Strawberry5  0.595885377 -0.65590705  0.58277734
## 17     Berry                 Strawberry6  2.890807350  1.51710457 -0.40231055
## 18     Berry                 raspberry 1  0.002784249  0.24770479  0.77952820
## 19     Berry                 raspberry 2 -0.181932219 -0.05470297  0.05660525
## 20     Berry                 raspberry 3  0.714829561 -1.32650761 -2.11426476
## 21     Berry                 raspberry 4  0.041631118 -0.30336432 -0.10035713
## 22     Berry                 raspberry 5 -0.177484391 -0.92080171 -0.04037283
## 23     Berry                 raspberry 6 -0.239619991 -1.64119492 -0.69498878
## 24 Attribute cata_appearance_unevencolor  1.936613700 -1.17322492  0.32072486
## 25 Attribute   cata_appearance_misshapen  0.058944103  2.05113772 -3.66060544
## 26 Attribute    cata_appearance_notfresh  2.453268365  0.16152199 -0.22489458
## 27 Attribute       cata_appearance_fresh -0.937269938  0.02467928  0.44045357
## 28 Attribute cata_appearance_goodquality -0.997347176  0.08087827  0.50595892
## 29 Attribute        cata_appearance_none -0.793756318 -1.48244462 -0.16563013
## 30 Attribute           cata_taste_floral -0.281501563 -0.15570463 -0.66082635
## 31 Attribute            cata_taste_berry -0.332540749 -0.79022119 -0.46021047
## 32 Attribute           cata_taste_grassy  0.597826399  1.20258057  1.48981642
## 33 Attribute        cata_taste_fermented  0.485339794  2.23871239  0.82509530
## 34 Attribute           cata_taste_fruity -0.122408859 -1.18256562 -0.46550861
## 35 Attribute           cata_taste_earthy  0.354905352  1.43796995  0.85550318
## 36 Attribute             cata_taste_none  0.120742891  0.96539923 -0.03486454
##          Dim4         Dim5         Dim6          Dim7        Dim8        Dim9
## 1  -2.1207457  0.421035244  0.416339437  -0.087205574  0.55527540  0.66487134
## 2  -0.6763648 -0.401344347  1.353241139  -0.143661403  0.31809116  0.82018151
## 3  -1.5512728  0.149090611 -0.154464899  -0.009161493  0.17303241 -0.07476922
## 4   1.8024546 -1.054134662  0.604303775   1.121173149  1.61580941 -0.44455523
## 5  -0.3768377 -1.478964909 -0.652553200  -0.503141105 -0.95611885 -0.76061578
## 6   0.9721393  0.341902827 -0.708842996   0.275826588  0.50857290  0.94363142
## 7   1.3567656 -0.058683995  3.082539058   0.538179530 -1.16634324 -0.43368257
## 8   0.2667007  1.452589890 -1.525570006   0.767208280 -0.17612888 -1.96339520
## 9  -0.6011662  1.453852344 -0.121844931   0.606785673 -0.26607669  0.49314835
## 10  1.3192008  1.250783134  0.820976326   0.475499585  1.30639341 -0.73014319
## 11 -0.1166850  1.177305333 -0.582502705  -0.563767160 -1.33239601 -1.94597487
## 12 -1.9371408 -0.269928992  0.003367573   1.980558028  1.56631289 -0.17821445
## 13 -0.0688568 -0.454494991  0.333203747  -1.237545485  0.45004439 -0.95562013
## 14  0.1817546 -1.474293484  1.174373617   0.381298231  0.06195272  0.41063042
## 15  1.0718960 -1.737282915 -1.577928830  -0.329844134  0.71300614 -1.32879302
## 16 -1.2198681 -0.852687372  0.761511155   0.054789811 -1.58761812 -1.24962440
## 17  0.8846827  2.338783198  0.483756496   0.160111078 -0.57887026  0.34590501
## 18  0.7647137 -0.914998126 -0.901156816   0.498483211 -2.30064883  1.53815305
## 19  0.2948372 -0.159554062 -1.041068949  -0.750258551  1.07509047  0.55799211
## 20 -0.3861240  0.086736116 -0.577370181   1.175513729 -0.54472390  0.75571365
## 21  0.3256547  0.412286985 -0.435287990  -1.543719337 -0.11575622  1.57370723
## 22  0.3511281 -0.003814396 -0.678042187   0.444107106  0.28159320  1.09950507
## 23 -0.3495728  0.259177191  0.697218086  -2.755894177  0.71155298  0.04135319
## 24 -0.3691085 -1.620059383 -0.377473620   0.301545855 -0.63352523  1.22816392
## 25  0.3531013 -1.006035553 -0.212496004  -0.239274881 -1.09516405  0.26709095
## 26  0.9952467  2.868903004  1.026387237  -0.055450592 -0.38506099  0.06475031
## 27  0.1240773 -0.108632925  0.141496178   0.043970746 -0.20627303  0.81170689
## 28  0.4849384  0.529754205  0.332772420   0.342509736 -1.07314538  0.47718892
## 29 -1.4180918  0.690178046  3.291335009 -17.006164060  1.32949174  1.45853357
## 30 -0.2243516  1.497283724 -2.819331519   0.864064594  1.83366072  0.12638909
## 31 -0.4352527  0.034561355  0.089370302  -0.214060919  0.26794118 -0.98297215
## 32  1.2955302 -0.968001002 -1.023546788  -0.489156221 -0.70173788 -2.52321861
## 33 -3.9589988  0.105941940  1.889817842   1.038772276  0.30006618 -0.78605241
## 34 -0.2273194 -0.145301727  0.293071101   0.084345882  0.42917126 -0.65205090
## 35 -0.3491357 -0.018917764 -1.201391871  -0.996446089  1.35938942  1.24888861
## 36  3.5345743 -2.052653151  3.712240877   1.346737365  4.83311179  0.41381134
##         Dim10       Dim11        Dim12
## 1   0.7992141 -0.95983642 -0.009253265
## 2   1.3393069  0.68731238  0.267060332
## 3  -1.5859313 -0.69717059 -1.168003875
## 4  -1.3036853 -0.22875124 -0.894559086
## 5  -0.2891770  0.74883806  1.156346478
## 6  -1.0496073 -0.33120184 -0.408429808
## 7   1.1514695 -0.67185606 -0.519204536
## 8  -0.1572088 -0.29921710  1.327706362
## 9  -0.9894949  1.24943134  0.309664418
## 10  1.4665355  0.54425299  1.516555388
## 11 -0.2792107 -1.24454179 -1.159488529
## 12 -0.0413237  0.49720288  0.715403472
## 13  0.1394031 -2.84848835  1.293593154
## 14 -2.2704383 -0.36073715  0.084475487
## 15  0.5226638  1.45255686 -0.678893230
## 16  0.5416557  1.25779330 -1.359994255
## 17 -0.8335918  1.22987860 -0.669642985
## 18  0.2120347 -0.04656501  1.543167644
## 19  1.7404352 -0.10284611 -1.758554927
## 20  0.9693176 -0.40241340 -0.328363440
## 21 -0.2755199 -0.43059527 -0.823009716
## 22  0.3868386 -0.56755742  0.383635858
## 23 -0.5673104  1.44742716  1.252192647
## 24 -0.4084541 -0.62254913  0.317272405
## 25 -0.1111936  0.11384684 -0.118543402
## 26  0.2590012  0.65050805  0.369378079
## 27 -0.1700575  1.47757553  1.057741523
## 28 -0.1537466 -1.36294181 -0.799243733
## 29 -7.0630004 -2.76411379  0.824372037
## 30 -2.2281270 -0.79295431  0.615338734
## 31  1.2341189 -0.68568963  0.984392755
## 32 -0.6268628  0.30656609  0.112193577
## 33 -1.2096748 -0.26064110  0.099479751
## 34 -0.3340588  1.11961579 -1.897053591
## 35  2.0332988  0.06165682 -1.232091871
## 36 -0.8624509 -1.47668343  0.524665515
```

We could also add on any columns that have one value for each product *and* each attribute (or fill in the gaps with `NA`s). Maybe we want a column with the `rowmass`es and `colmass`es. These are vectors, so it would be handy if we could wrangle them into tibbles first.

You can use either `tibble()` or `data.frame()` to make vectors in the same order into a table. They have basically the same usage. Just make sure you name your columns!


```r
berry_rowmass <- tibble(Variable = berry_ca_res$rownames,
                        Mass = berry_ca_res$rowmass)

berry_rowmass
```

```
## # A tibble: 23 × 2
##    Variable       Mass
##    <chr>         <dbl>
##  1 Blackberry 1 0.0392
##  2 Blackberry 2 0.0394
##  3 Blackberry 3 0.0412
##  4 Blackberry 4 0.0401
##  5 Blackberry 5 0.0429
##  6 Blueberry 1  0.0394
##  7 Blueberry 2  0.0378
##  8 Blueberry 3  0.0399
##  9 Blueberry 4  0.0386
## 10 Blueberry 5  0.0392
## # ℹ 13 more rows
```

If you have an already-named vector, `enframe()` is a handy shortcut to making a two-column tibble, but unfortunately this isn't how the `ca` package structures its output.


```r
named_colmasses <- berry_ca_res$colmass
names(named_colmasses) <- berry_ca_res$colnames

berry_colmass <- named_colmasses %>%
  enframe(name = "Variable",
          value = "Mass")

berry_colmass
```

```
## # A tibble: 13 × 2
##    Variable                       Mass
##    <chr>                         <dbl>
##  1 cata_appearance_unevencolor 0.0848 
##  2 cata_appearance_misshapen   0.0473 
##  3 cata_appearance_notfresh    0.0551 
##  4 cata_appearance_fresh       0.162  
##  5 cata_appearance_goodquality 0.145  
##  6 cata_appearance_none        0.00271
##  7 cata_taste_floral           0.0457 
##  8 cata_taste_berry            0.162  
##  9 cata_taste_grassy           0.0614 
## 10 cata_taste_fermented        0.0339 
## 11 cata_taste_fruity           0.119  
## 12 cata_taste_earthy           0.0643 
## 13 cata_taste_none             0.0164
```

And now we can use `bind_rows()` and `left_join()` to jigsaw these together.


```r
bind_rows(berry_colmass, berry_rowmass) %>%
  left_join(berry_ca_coords, by = "Variable")
```

```
## # A tibble: 36 × 15
##    Variable    Mass Type     Dim1    Dim2   Dim3   Dim4    Dim5    Dim6     Dim7
##    <chr>      <dbl> <chr>   <dbl>   <dbl>  <dbl>  <dbl>   <dbl>   <dbl>    <dbl>
##  1 cata_ap… 0.0848  Attr…  1.94   -1.17    0.321 -0.369 -1.62   -0.377    0.302 
##  2 cata_ap… 0.0473  Attr…  0.0589  2.05   -3.66   0.353 -1.01   -0.212   -0.239 
##  3 cata_ap… 0.0551  Attr…  2.45    0.162  -0.225  0.995  2.87    1.03    -0.0555
##  4 cata_ap… 0.162   Attr… -0.937   0.0247  0.440  0.124 -0.109   0.141    0.0440
##  5 cata_ap… 0.145   Attr… -0.997   0.0809  0.506  0.485  0.530   0.333    0.343 
##  6 cata_ap… 0.00271 Attr… -0.794  -1.48   -0.166 -1.42   0.690   3.29   -17.0   
##  7 cata_ta… 0.0457  Attr… -0.282  -0.156  -0.661 -0.224  1.50   -2.82     0.864 
##  8 cata_ta… 0.162   Attr… -0.333  -0.790  -0.460 -0.435  0.0346  0.0894  -0.214 
##  9 cata_ta… 0.0614  Attr…  0.598   1.20    1.49   1.30  -0.968  -1.02    -0.489 
## 10 cata_ta… 0.0339  Attr…  0.485   2.24    0.825 -3.96   0.106   1.89     1.04  
## # ℹ 26 more rows
## # ℹ 5 more variables: Dim8 <dbl>, Dim9 <dbl>, Dim10 <dbl>, Dim11 <dbl>,
## #   Dim12 <dbl>
```

In summary:
- Many analyses will give you **lists** full of every possible piece of data you could need, which aren't necessarily tabular.
- If you need to turn a **tabular data** with `rownames` into a tibble, use `rownames_to_column()` or `as_tibble()`.
- If you need to turn a **named vector** into a two-column table, use `enframe()`
- If you need to turn **multiple vectors** into a table, use `tibble()` or `data.frame()`.
- You can combine multiple tables together using `bind_rows()` and `left_join()`, if you manage your column names and the orders of your vectors carefully.

Like with our *untidying* process, the shape you need to get your data into during *retidying* is ultimately decided by what you want to do with it next. Correspondence Analysis is primarily a graphical method, so next we're going to talk about graphing functions in R in our last substantive chapter. By the end, you will be able to make the plots we showed in the beginning!

Let's take a quick moment to **save our data** before we move on, though, so we don't have to rerun our `ca()` whenever we restart `R` to make more changes to our graph.

As we've shown before, you can save tabular data easily:


```r
berry_ca_coords %>%
  write_csv("data/berry_ca_coords.csv")

berry_col_coords %>%
  write_csv("data/berry_ca_col_coords.csv")

berry_row_coords %>%
  write_csv("data/berry_ca_row_coords.csv")
```

But `.csv` is a **tabular format**, so it's a little harder to save the whole non-tabular list of `berry_ca_res` as a table. There's a lot of stuff we may need later, though, so just in case we can save it as an `.Rds` file:


```r
berry_ca_res %>%
  write_rds("data/berry_ca_results.rds")
```
