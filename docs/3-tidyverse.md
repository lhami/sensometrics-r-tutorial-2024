# Wrangling data with `tidyverse`: Rows, Columns, and Groups



A common saying in data science is that about 90% of the effort in an analysis workflow is in getting data wrangled into the right format and shape, and 10% is actual analysis.  In a point and click program like SPSS or XLSTAT we don't think about this as much because the activity of reshaping the data--making it longer or wider as required, finding and cleaning missing values, selecting columns or rows, etc--is often temporally and programmatically separated from the "actual" analysis. 

In `R`, this can feel a bit different because we are using the same interface to manipulate our data and to analyze it.  Sometimes we'll want to jump back out to a spreadsheet program like Excel or even the command line (the "shell" like `bash` or `zsh`) to make some changes.  But in general the tools for manipulating data in `R` are both more powerful and more easily used than doing these activities by hand, and you will make yourself a much more effective analyst by mastering these basic tools.

Here, we are going to emphasize the set of tools from the [`tidyverse`](https://www.tidyverse.org/), which are extensively documented in Hadley Wickham and Garrett Grolemund's book [*R for Data Science*](https://r4ds.had.co.nz/).  If you want to learn more, start there!

<center>

![The `tidyverse` is associated with this hexagonal iconography.](img/tidyverse-iconography.png)

</center>

Before we move on to actually learning the tools, let's make sure we've got our data loaded up.


```r
library(tidyverse)
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


## Subsetting data

R's system for **indexing** data frames is clear and sensible for those who are used to programming languages, but not necessarily easy to read.  

A common situation in R is wanting to select some rows and some columns of our data--this is called "**subsetting**" our data.  But this is less easy than it might be for the beginner in R.  Happily, the `tidverse` methods are much easier to read (and modeled after syntax from **SQL**, which may be helpful for some users). Starting with...

### `select()` for columns

The first thing we often want to do in a data analysis is to pick a subset of columns, which usually represent variables.  If we take a look at our berry data, we see that, for example, we have some columns that contain the answers to survey questions, some columns that are about the test day or panelist, and some that identify the panelist or berry:


```r
glimpse(berry_data)
```

```
## Rows: 7,507
## Columns: 92
## $ `Subject Code`              <dbl> 1001, 1001, 1001, 1001, 1001, 1001, 1002, …
## $ `Participant Name`          <dbl> 1001, 1001, 1001, 1001, 1001, 1001, 1002, …
## $ Gender                      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ Age                         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ `Start Time (UTC)`          <chr> "6/13/2019 21:05", "6/13/2019 20:55", "6/1…
## $ `End Time (UTC)`            <chr> "6/13/2019 21:09", "6/13/2019 20:59", "6/1…
## $ `Serving Position`          <dbl> 5, 3, 2, 1, 4, 6, 3, 1, 4, 2, 6, 5, 2, 4, …
## $ `Sample Identifier`         <dbl> 1426, 3167, 4624, 5068, 7195, 9161, 1426, …
## $ `Sample Name`               <chr> "raspberry 6", "raspberry 5", "raspberry 2…
## $ `9pt_appearance`            <dbl> 4, 8, 4, 7, 7, 7, 6, 8, 8, 7, 9, 8, 5, 5, …
## $ pre_expectation             <dbl> 2, 4, 2, 4, 3, 4, 2, 3, 5, 3, 4, 5, 3, 3, …
## $ jar_color                   <dbl> 2, 3, 2, 2, 4, 4, 2, 3, 3, 2, 3, 4, 3, 3, …
## $ jar_gloss                   <dbl> 4, 3, 2, 3, 3, 3, 4, 3, 4, 4, 2, 4, 3, 3, …
## $ jar_size                    <dbl> 2, 3, 3, 4, 3, 3, 4, 3, 5, 3, 3, 4, 3, 3, …
## $ cata_appearance_unevencolor <dbl> 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, …
## $ cata_appearance_misshapen   <dbl> 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, …
## $ cata_appearance_creased     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, …
## $ cata_appearance_seedy       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
## $ cata_appearance_bruised     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, …
## $ cata_appearance_notfresh    <dbl> 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, …
## $ cata_appearance_fresh       <dbl> 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, …
## $ cata_appearance_goodshape   <dbl> 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, …
## $ cata_appearance_goodquality <dbl> 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, …
## $ cata_appearance_none        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
## $ `9pt_overall`               <dbl> 4, 9, 3, 7, 4, 4, 4, 7, 7, 9, 7, 2, 8, 7, …
## $ verbal_likes                <chr> "Out of the two, there was one that had a …
## $ verbal_dislikes             <chr> "There were different flavors coming from …
## $ `9pt_taste`                 <dbl> 4, 9, 3, 6, 3, 3, 4, 4, 6, 9, 6, 2, 8, 7, …
## $ grid_sweetness              <dbl> 3, 6, 3, 6, 2, 3, 3, 2, 2, 6, 4, 1, 6, 4, …
## $ grid_tartness               <dbl> 6, 5, 5, 3, 5, 6, 5, 5, 5, 2, 2, 7, 4, 5, …
## $ grid_raspberryflavor        <dbl> 4, 7, 2, 6, 2, 3, 2, 6, 2, 7, 2, 2, 6, 5, …
## $ jar_sweetness               <dbl> 2, 3, 2, 3, 2, 1, 1, 1, 1, 3, 2, 1, 3, 3, …
## $ jar_tartness                <dbl> 4, 3, 3, 3, 4, 5, 4, 4, 4, 3, 4, 5, 3, 3, …
## $ cata_taste_floral           <dbl> 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, …
## $ cata_taste_berry            <dbl> 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, …
## $ cata_taste_green            <dbl> 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, …
## $ cata_taste_grassy           <dbl> 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, …
## $ cata_taste_fermented        <dbl> 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
## $ cata_taste_tropical         <dbl> 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, …
## $ cata_taste_fruity           <dbl> 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, …
## $ cata_taste_citrus           <dbl> 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, …
## $ cata_taste_earthy           <dbl> 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, …
## $ cata_taste_candy            <dbl> 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, …
## $ cata_taste_none             <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
## $ `9pt_texture`               <dbl> 6, 8, 2, 8, 5, 6, 6, 9, 8, 7, 7, 7, 8, 7, …
## $ grid_seediness              <dbl> 3, 5, 6, 3, 5, 5, 6, 4, 6, 5, 6, 5, 4, 4, …
## $ grid_firmness               <dbl> 5, 5, 5, 2, 6, 5, 5, 6, 5, 3, 5, 5, 4, 5, …
## $ grid_juiciness              <dbl> 2, 5, 2, 2, 2, 4, 2, 4, 2, 3, 3, 2, 6, 5, …
## $ jar_firmness                <dbl> 3, 3, 4, 2, 4, 3, 3, 3, 3, 2, 3, 3, 3, 3, …
## $ jar_juciness                <dbl> 2, 3, 1, 2, 2, 2, 1, 2, 1, 3, 2, 1, 3, 3, …
## $ post_expectation            <dbl> 1, 5, 2, 4, 2, 2, 2, 2, 2, 5, 2, 1, 4, 3, …
## $ price                       <dbl> 1.99, 4.99, 2.99, 4.99, 2.99, 3.99, 3.99, …
## $ product_tier                <dbl> 1, 3, 2, 3, 1, 2, 2, 2, 1, 3, 2, 1, 2, 2, …
## $ purchase_intent             <dbl> 1, 5, 2, 4, 2, 2, 3, 4, 2, 5, 3, 1, 5, 5, …
## $ subject                     <dbl> 1031946, 1031946, 1031946, 1031946, 103194…
## $ test_day                    <chr> "Raspberry Day 1", "Raspberry Day 1", "Ras…
## $ us_appearance               <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ us_overall                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ us_taste                    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ us_texture                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ lms_appearance              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ lms_overall                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ lms_taste                   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ lms_texture                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_appearane_bruised      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_appearance_goodshapre  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_appearance_goodcolor   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ grid_blackberryflavor       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_cinnamon         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_lemon            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_clove            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_minty            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_grape            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ grid_crispness              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ jar_crispness               <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ jar_juiciness               <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_appearane_creased      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ grid_blueberryflavor        <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_piney            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_peachy           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ `9pt_aroma`                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ grid_strawberryflavor       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_caramel          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_grapey           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_melon            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ cata_taste_cherry           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ grid_crunchiness            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ jar_crunch                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ us_aroma                    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ lms_aroma                   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ berry                       <chr> "raspberry", "raspberry", "raspberry", "ra…
## $ sample                      <dbl> 6, 5, 2, 3, 4, 1, 6, 5, 2, 3, 4, 1, 6, 5, …
```

So, for example, we might want to determine whether there are differences in liking between the berries, test days, or scales, in which case perhaps we only want the columns starting with `us_`, `lms_`, and `9pt_` along with `berry` and `test_day`.  We learned previously that we can do this with numeric indexing:


```r
berry_data[, c(10,25,28,45,56:64,81,89:91)]
```

```
## # A tibble: 7,507 × 17
##    `9pt_appearance` `9pt_overall` `9pt_taste` `9pt_texture` test_day       
##               <dbl>         <dbl>       <dbl>         <dbl> <chr>          
##  1                4             4           4             6 Raspberry Day 1
##  2                8             9           9             8 Raspberry Day 1
##  3                4             3           3             2 Raspberry Day 1
##  4                7             7           6             8 Raspberry Day 1
##  5                7             4           3             5 Raspberry Day 1
##  6                7             4           3             6 Raspberry Day 1
##  7                6             4           4             6 Raspberry Day 1
##  8                8             7           4             9 Raspberry Day 1
##  9                8             7           6             8 Raspberry Day 1
## 10                7             9           9             7 Raspberry Day 1
## # ℹ 7,497 more rows
## # ℹ 12 more variables: us_appearance <dbl>, us_overall <dbl>, us_taste <dbl>,
## #   us_texture <dbl>, lms_appearance <dbl>, lms_overall <dbl>, lms_taste <dbl>,
## #   lms_texture <dbl>, `9pt_aroma` <dbl>, us_aroma <dbl>, lms_aroma <dbl>,
## #   berry <chr>
```

However, this is both difficult for novices to `R` and difficult to read if you are not intimately familiar with the data.  It is also rather fragile--what if someone else rearranged the data in your import file?  You're just selecting columns by their order, so column 91 is not guaranteed to contain the berry type every time. Not to mention all of the counting was annoying!

Subsetting using names is a little more stable, but still not that readable and takes a lot of typing.


```r
berry_data[, c("9pt_aroma","9pt_overall","9pt_taste","9pt_texture","9pt_appearance",
               "lms_aroma","lms_overall","lms_taste","lms_texture","lms_appearance",
               "us_aroma","us_overall","us_taste","us_texture","us_appearance",
               "berry","test_day")]
```

```
## # A tibble: 7,507 × 17
##    `9pt_aroma` `9pt_overall` `9pt_taste` `9pt_texture` `9pt_appearance`
##          <dbl>         <dbl>       <dbl>         <dbl>            <dbl>
##  1          NA             4           4             6                4
##  2          NA             9           9             8                8
##  3          NA             3           3             2                4
##  4          NA             7           6             8                7
##  5          NA             4           3             5                7
##  6          NA             4           3             6                7
##  7          NA             4           4             6                6
##  8          NA             7           4             9                8
##  9          NA             7           6             8                8
## 10          NA             9           9             7                7
## # ℹ 7,497 more rows
## # ℹ 12 more variables: lms_aroma <dbl>, lms_overall <dbl>, lms_taste <dbl>,
## #   lms_texture <dbl>, lms_appearance <dbl>, us_aroma <dbl>, us_overall <dbl>,
## #   us_taste <dbl>, us_texture <dbl>, us_appearance <dbl>, berry <chr>,
## #   test_day <chr>
```


The `select()` function in `tidyverse` (actually from the `dplyr` package) is the smarter, easier way to do this.  It works on data frames, and it can be read as "`select()` the columns from \<data frame\> that meet the criteria we've set."

`select(<data frame>, <column 1>, <column 2>, ...)`

The simplest way to use `select()` is just to name the columns you want!


```r
select(berry_data, berry, test_day,
       lms_aroma, lms_overall, lms_taste, lms_texture, lms_appearance) # note the lack of quoting on the column names
```

```
## # A tibble: 7,507 × 7
##    berry     test_day lms_aroma lms_overall lms_taste lms_texture lms_appearance
##    <chr>     <chr>        <dbl>       <dbl>     <dbl>       <dbl>          <dbl>
##  1 raspberry Raspber…        NA          NA        NA          NA             NA
##  2 raspberry Raspber…        NA          NA        NA          NA             NA
##  3 raspberry Raspber…        NA          NA        NA          NA             NA
##  4 raspberry Raspber…        NA          NA        NA          NA             NA
##  5 raspberry Raspber…        NA          NA        NA          NA             NA
##  6 raspberry Raspber…        NA          NA        NA          NA             NA
##  7 raspberry Raspber…        NA          NA        NA          NA             NA
##  8 raspberry Raspber…        NA          NA        NA          NA             NA
##  9 raspberry Raspber…        NA          NA        NA          NA             NA
## 10 raspberry Raspber…        NA          NA        NA          NA             NA
## # ℹ 7,497 more rows
```

This is much clearer to the reader.

Getting rid of the double quotes we previously saw around `"column names"` can have some consequences, though. R variable names can *only* contain letters, numbers, and underscores (_), no spaces ( ) or dashes (-), and can't start with numbers, but the tidyverse *will* let you make column names that break these rules. So if you try to do the exact same thing as before to get the data from the 9-point hedonic scale instead of the labeled magnitude scale:


```r
 # this will cause an error
select(berry_data, berry, test_day,
       9pt_aroma, 9pt_overall, 9pt_taste, 9pt_texture, 9pt_appearance)
```

You'll run into an error. The solution to this is a different kind of quote called a backtick (`) which is usually next to the number 1 key in the very top left of QWERTY (US and UK) keyboards. On QWERTZ and AZERTY keyboards, it may be next to the backspace key or one of the alternate characters made by the 7 key. Look [at this guide](https://superuser.com/questions/254076/how-do-i-type-the-tick-and-backtick-characters-on-windows) for help finding it in common international keyboard layouts.


```r
select(berry_data, berry, test_day, # these "syntactic" column names don't need escaping
       `9pt_aroma`, # only ones starting with numbers...
       `9pt_overall`, `9pt_taste`, `9pt_texture`, `9pt_appearance`,
       `Sample Name`) # or containing spaces
```

```
## # A tibble: 7,507 × 8
##    berry     test_day        `9pt_aroma` `9pt_overall` `9pt_taste` `9pt_texture`
##    <chr>     <chr>                 <dbl>         <dbl>       <dbl>         <dbl>
##  1 raspberry Raspberry Day 1          NA             4           4             6
##  2 raspberry Raspberry Day 1          NA             9           9             8
##  3 raspberry Raspberry Day 1          NA             3           3             2
##  4 raspberry Raspberry Day 1          NA             7           6             8
##  5 raspberry Raspberry Day 1          NA             4           3             5
##  6 raspberry Raspberry Day 1          NA             4           3             6
##  7 raspberry Raspberry Day 1          NA             4           4             6
##  8 raspberry Raspberry Day 1          NA             7           4             9
##  9 raspberry Raspberry Day 1          NA             7           6             8
## 10 raspberry Raspberry Day 1          NA             9           9             7
## # ℹ 7,497 more rows
## # ℹ 2 more variables: `9pt_appearance` <dbl>, `Sample Name` <chr>
```

The backticks are only necessary when a column name breaks one of the variable-naming rules, and RStudio will usually fill them in for you if you use tab autocompletion when writing your select() and other tidyverse functions.

You can also use `select()` with a number of helper functions, which use logic to select columns that meet whatever conditions you set.  For example, the `starts_with()` helper function lets us give a set of characters we want columns to start with:


```r
select(berry_data, starts_with("lms_")) #the double-quotes are back because this isn't a full column name
```

```
## # A tibble: 7,507 × 5
##    lms_appearance lms_overall lms_taste lms_texture lms_aroma
##             <dbl>       <dbl>     <dbl>       <dbl>     <dbl>
##  1             NA          NA        NA          NA        NA
##  2             NA          NA        NA          NA        NA
##  3             NA          NA        NA          NA        NA
##  4             NA          NA        NA          NA        NA
##  5             NA          NA        NA          NA        NA
##  6             NA          NA        NA          NA        NA
##  7             NA          NA        NA          NA        NA
##  8             NA          NA        NA          NA        NA
##  9             NA          NA        NA          NA        NA
## 10             NA          NA        NA          NA        NA
## # ℹ 7,497 more rows
```

There are equivalents for the end of column names (`ends_with()`) and text found anywhere in the name (`contains()`).

You can combine these statements together to get subsets of columns however you want:


```r
select(berry_data, starts_with("lms_"), starts_with("9pt_"), starts_with("us_"),
       berry, test_day)
```

```
## # A tibble: 7,507 × 17
##    lms_appearance lms_overall lms_taste lms_texture lms_aroma `9pt_appearance`
##             <dbl>       <dbl>     <dbl>       <dbl>     <dbl>            <dbl>
##  1             NA          NA        NA          NA        NA                4
##  2             NA          NA        NA          NA        NA                8
##  3             NA          NA        NA          NA        NA                4
##  4             NA          NA        NA          NA        NA                7
##  5             NA          NA        NA          NA        NA                7
##  6             NA          NA        NA          NA        NA                7
##  7             NA          NA        NA          NA        NA                6
##  8             NA          NA        NA          NA        NA                8
##  9             NA          NA        NA          NA        NA                8
## 10             NA          NA        NA          NA        NA                7
## # ℹ 7,497 more rows
## # ℹ 11 more variables: `9pt_overall` <dbl>, `9pt_taste` <dbl>,
## #   `9pt_texture` <dbl>, `9pt_aroma` <dbl>, us_appearance <dbl>,
## #   us_overall <dbl>, us_taste <dbl>, us_texture <dbl>, us_aroma <dbl>,
## #   berry <chr>, test_day <chr>
```

```r
select(berry_data, starts_with("jar_"), ends_with("_overall"),
       berry, test_day)
```

```
## # A tibble: 7,507 × 15
##    jar_color jar_gloss jar_size jar_sweetness jar_tartness jar_firmness
##        <dbl>     <dbl>    <dbl>         <dbl>        <dbl>        <dbl>
##  1         2         4        2             2            4            3
##  2         3         3        3             3            3            3
##  3         2         2        3             2            3            4
##  4         2         3        4             3            3            2
##  5         4         3        3             2            4            4
##  6         4         3        3             1            5            3
##  7         2         4        4             1            4            3
##  8         3         3        3             1            4            3
##  9         3         4        5             1            4            3
## 10         2         4        3             3            3            2
## # ℹ 7,497 more rows
## # ℹ 9 more variables: jar_juciness <dbl>, jar_crispness <dbl>,
## #   jar_juiciness <dbl>, jar_crunch <dbl>, `9pt_overall` <dbl>,
## #   us_overall <dbl>, lms_overall <dbl>, berry <chr>, test_day <chr>
```

If you're annoyed at the order that your columns are printing in and how far to the right you have to scroll in your previews, `select()` can also be used to rearrange your columns with a helper function called `everything()`:


```r
select(berry_data, everything()) #This selects everything--it doesn't change at all.
```

```
## # A tibble: 7,507 × 92
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
## # ℹ 7,497 more rows
## # ℹ 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

```r
select(berry_data, berry, contains("_overall"),
       everything()) #only type the columns you want to move to the front, and everything() will keep the rest
```

```
## # A tibble: 7,507 × 92
##    berry  `9pt_overall` us_overall lms_overall `Subject Code` `Participant Name`
##    <chr>          <dbl>      <dbl>       <dbl>          <dbl>              <dbl>
##  1 raspb…             4         NA          NA           1001               1001
##  2 raspb…             9         NA          NA           1001               1001
##  3 raspb…             3         NA          NA           1001               1001
##  4 raspb…             7         NA          NA           1001               1001
##  5 raspb…             4         NA          NA           1001               1001
##  6 raspb…             4         NA          NA           1001               1001
##  7 raspb…             4         NA          NA           1002               1002
##  8 raspb…             7         NA          NA           1002               1002
##  9 raspb…             7         NA          NA           1002               1002
## 10 raspb…             9         NA          NA           1002               1002
## # ℹ 7,497 more rows
## # ℹ 86 more variables: Gender <lgl>, Age <lgl>, `Start Time (UTC)` <chr>,
## #   `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>, …
```

`everything()` can be very useful for programming, but if you just need to rearrange an even easier function is `relocate()`, which moves whatever columns you specify to the "left" or "right" of the `data.frame`; you can even get more specific and move to the left or right of specific columns:


```r
# By default relocate() moves the selected column(s) to the left of the data.frame
relocate(berry_data, us_overall)
```

```
## # A tibble: 7,507 × 92
##    us_overall `Subject Code` `Participant Name` Gender Age   `Start Time (UTC)`
##         <dbl>          <dbl>              <dbl> <lgl>  <lgl> <chr>             
##  1         NA           1001               1001 NA     NA    6/13/2019 21:05   
##  2         NA           1001               1001 NA     NA    6/13/2019 20:55   
##  3         NA           1001               1001 NA     NA    6/13/2019 20:49   
##  4         NA           1001               1001 NA     NA    6/13/2019 20:45   
##  5         NA           1001               1001 NA     NA    6/13/2019 21:00   
##  6         NA           1001               1001 NA     NA    6/13/2019 21:10   
##  7         NA           1002               1002 NA     NA    6/13/2019 20:08   
##  8         NA           1002               1002 NA     NA    6/13/2019 19:57   
##  9         NA           1002               1002 NA     NA    6/13/2019 20:13   
## 10         NA           1002               1002 NA     NA    6/13/2019 20:03   
## # ℹ 7,497 more rows
## # ℹ 86 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

```r
# ".before/.after = " specify a position relative to another column
relocate(berry_data, `Subject Code`, .before = Gender)
```

```
## # A tibble: 7,507 × 92
##    `Participant Name` `Subject Code` Gender Age   `Start Time (UTC)`
##                 <dbl>          <dbl> <lgl>  <lgl> <chr>             
##  1               1001           1001 NA     NA    6/13/2019 21:05   
##  2               1001           1001 NA     NA    6/13/2019 20:55   
##  3               1001           1001 NA     NA    6/13/2019 20:49   
##  4               1001           1001 NA     NA    6/13/2019 20:45   
##  5               1001           1001 NA     NA    6/13/2019 21:00   
##  6               1001           1001 NA     NA    6/13/2019 21:10   
##  7               1002           1002 NA     NA    6/13/2019 20:08   
##  8               1002           1002 NA     NA    6/13/2019 19:57   
##  9               1002           1002 NA     NA    6/13/2019 20:13   
## 10               1002           1002 NA     NA    6/13/2019 20:03   
## # ℹ 7,497 more rows
## # ℹ 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```


You may sometimes want to select columns where the data meets some criteria, rather than the column name or position. The `where()` helper function allows you to insert this kind of programmatic logic into `select()` statements, which gives you the ability to specify columns using any arbitrary function.


```r
 #a few functions return one logical value per vector
select(berry_data, where(is.numeric))
```

```
## # A tibble: 7,507 × 83
##    `Subject Code` `Participant Name` `Serving Position` `Sample Identifier`
##             <dbl>              <dbl>              <dbl>               <dbl>
##  1           1001               1001                  5                1426
##  2           1001               1001                  3                3167
##  3           1001               1001                  2                4624
##  4           1001               1001                  1                5068
##  5           1001               1001                  4                7195
##  6           1001               1001                  6                9161
##  7           1002               1002                  3                1426
##  8           1002               1002                  1                3167
##  9           1002               1002                  4                4624
## 10           1002               1002                  2                5068
## # ℹ 7,497 more rows
## # ℹ 79 more variables: `9pt_appearance` <dbl>, pre_expectation <dbl>,
## #   jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>,
## #   cata_appearance_fresh <dbl>, cata_appearance_goodshape <dbl>, …
```

```r
 #otherwise we can use "lambda" functions
select(berry_data, where(~!any(is.na(.))))
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

The little squiggly symbol, called a tilde (`~`), is above the backtick on QWERTY keyboards, and it turns everything that comes after it into a "lambda function". We'll talk more about lambda functions later, when we talk about `across()`. You can read it the above as "`select()` the columns from `berry_data` `where()` there are not (`!`) `any()` NA values (`is.na(.)`)".

Besides being easier to write conditions for than indexing with `[]`, `select()` is code that is much closer to how you or I think about what we're actually doing, making code that is more human readable.

### `filter()` for rows

So `select()` lets us pick which columns we want.  Can we also use it to pick particular observations?  No.  For that, there's `filter()`.

We learned that, using `[]` indexing, we'd specify a set of rows we want.  If we want the first 10 rows of `berry_data`, we'd write


```r
berry_data[1:10, ]
```

```
## # A tibble: 10 × 92
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
## # ℹ 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>,
## #   cata_appearance_fresh <dbl>, cata_appearance_goodshape <dbl>, …
```

Again, this is not very human readable, and if we reorganize our rows this won't be useful anymore.  The `tidyverse` answer to this approach is the `filter()` function, which lets you filter your dataset into specific rows according to *data stored in the table itself*.


```r
# let's get survey responses with had a higher-than-average expectation
filter(berry_data, pre_expectation > 3)
```

```
## # A tibble: 2,192 × 92
##    `Subject Code` `Participant Name` Gender Age   `Start Time (UTC)`
##             <dbl>              <dbl> <lgl>  <lgl> <chr>             
##  1           1001               1001 NA     NA    6/13/2019 20:55   
##  2           1001               1001 NA     NA    6/13/2019 20:45   
##  3           1001               1001 NA     NA    6/13/2019 21:10   
##  4           1002               1002 NA     NA    6/13/2019 20:13   
##  5           1002               1002 NA     NA    6/13/2019 20:21   
##  6           1002               1002 NA     NA    6/13/2019 20:18   
##  7           1004               1004 NA     NA    6/13/2019 21:09   
##  8           1004               1004 NA     NA    6/13/2019 20:58   
##  9           1004               1004 NA     NA    6/13/2019 20:50   
## 10           1005               1005 NA     NA    6/13/2019 20:13   
## # ℹ 2,182 more rows
## # ℹ 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

When using `filter()`, we can specify multiple logical conditions.  For example, let's get only raspberries with initially high expectations.  If we want only exact matches, we can use the direct `==` operator:


```r
filter(berry_data, pre_expectation > 3, berry == "raspberry")
```

```
## # A tibble: 709 × 92
##    `Subject Code` `Participant Name` Gender Age   `Start Time (UTC)`
##             <dbl>              <dbl> <lgl>  <lgl> <chr>             
##  1           1001               1001 NA     NA    6/13/2019 20:55   
##  2           1001               1001 NA     NA    6/13/2019 20:45   
##  3           1001               1001 NA     NA    6/13/2019 21:10   
##  4           1002               1002 NA     NA    6/13/2019 20:13   
##  5           1002               1002 NA     NA    6/13/2019 20:21   
##  6           1002               1002 NA     NA    6/13/2019 20:18   
##  7           1004               1004 NA     NA    6/13/2019 21:09   
##  8           1004               1004 NA     NA    6/13/2019 20:58   
##  9           1004               1004 NA     NA    6/13/2019 20:50   
## 10           1005               1005 NA     NA    6/13/2019 20:13   
## # ℹ 699 more rows
## # ℹ 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

But this won't return, for example, any berries labeled as "Raspberry", with an uppercase R.


```r
filter(berry_data, pre_expectation > 3, berry == "Raspberry")
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

Luckily, we don't have a mix of raspberries and Raspberries. Maybe we want both raspberries and strawberries that panelists had high expectations of:


```r
filter(berry_data, pre_expectation > 3, berry == "raspberry" | berry == "strawberry")
```

```
## # A tibble: 1,104 × 92
##    `Subject Code` `Participant Name` Gender Age   `Start Time (UTC)`
##             <dbl>              <dbl> <lgl>  <lgl> <chr>             
##  1           1001               1001 NA     NA    6/13/2019 20:55   
##  2           1001               1001 NA     NA    6/13/2019 20:45   
##  3           1001               1001 NA     NA    6/13/2019 21:10   
##  4           1002               1002 NA     NA    6/13/2019 20:13   
##  5           1002               1002 NA     NA    6/13/2019 20:21   
##  6           1002               1002 NA     NA    6/13/2019 20:18   
##  7           1004               1004 NA     NA    6/13/2019 21:09   
##  8           1004               1004 NA     NA    6/13/2019 20:58   
##  9           1004               1004 NA     NA    6/13/2019 20:50   
## 10           1005               1005 NA     NA    6/13/2019 20:13   
## # ℹ 1,094 more rows
## # ℹ 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

In `R`, the `|` means Boolean `OR`, and the `&` means Boolean `AND`. If you're trying to figure out which one to use, phrase what you want to do with your `filter()` statement by starting "keep only rows that have...". We may want to look at raspberries *and* strawberries, but we want to "keep only rows that have a `berry` type of raspberry *or* strawberry".

We can combine any number of conditions with `&` and `|` to search within our data table.  But this can be a bit tedious.  The `stringr` package, part of `tidyverse`, gives a lot of utility functions that we can use to reduce the number of options we're individually writing out, similar to `starts_with()` or `contains()` for columns. Maybe we want the results from the first day of each berry type:


```r
filter(berry_data, str_detect(test_day, "Day 1"))
```

```
## # A tibble: 2,586 × 92
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
## # ℹ 2,576 more rows
## # ℹ 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

Here, the `str_detect()` function searched for any text that **contains** "Day 1" in the `test_day` column.

## Combining steps with the pipe: `%>%`

It isn't hard to imagine a situation in which we want to **both** `select()` some columns and `filter()` some rows.  There are 3 ways we can do this, one of which is going to be the best for most situations.

Let's imagine we want to get only information about the berries, overall liking, and CATA attributes for blackberries.

First, we can nest functions:


```r
select(filter(berry_data, berry == "blackberry"), `Sample Name`, contains("_overall"), contains("cata_"))
```

```
## # A tibble: 1,495 × 40
##    `Sample Name` `9pt_overall` us_overall lms_overall cata_appearance_unevenco…¹
##    <chr>                 <dbl>      <dbl>       <dbl>                      <dbl>
##  1 Blackberry 4              2         NA          NA                          0
##  2 Blackberry 2              5         NA          NA                          0
##  3 Blackberry 1              8         NA          NA                          0
##  4 Blackberry 3              6         NA          NA                          0
##  5 Blackberry 5              8         NA          NA                          0
##  6 Blackberry 4              6         NA          NA                          0
##  7 Blackberry 2              1         NA          NA                          0
##  8 Blackberry 1              8         NA          NA                          0
##  9 Blackberry 3              8         NA          NA                          0
## 10 Blackberry 5              8         NA          NA                          0
## # ℹ 1,485 more rows
## # ℹ abbreviated name: ¹​cata_appearance_unevencolor
## # ℹ 35 more variables: cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>,
## #   cata_appearance_fresh <dbl>, cata_appearance_goodshape <dbl>,
## #   cata_appearance_goodquality <dbl>, cata_appearance_none <dbl>, …
```

The problem with this approach is that we have to read it "inside out".  First, `filter()` will happen and get us only berries whose `berry` is exactly "blackberry".  Then `select()` will get `Sample Name` along with columns that match "_overall" or "cata_ in their names.  Especially as your code gets complicated, this can be very hard to read (and in the bookdown, doesn't even fit on one line!).

So we might take the second approach: creating intermediates.  We might first `filter()`, store that step somewhere, then `select()`:


```r
blackberries <- filter(berry_data, berry == "blackberry")
select(blackberries, `Sample Name`, contains("_overall"), contains("cata_"))
```

```
## # A tibble: 1,495 × 40
##    `Sample Name` `9pt_overall` us_overall lms_overall cata_appearance_unevenco…¹
##    <chr>                 <dbl>      <dbl>       <dbl>                      <dbl>
##  1 Blackberry 4              2         NA          NA                          0
##  2 Blackberry 2              5         NA          NA                          0
##  3 Blackberry 1              8         NA          NA                          0
##  4 Blackberry 3              6         NA          NA                          0
##  5 Blackberry 5              8         NA          NA                          0
##  6 Blackberry 4              6         NA          NA                          0
##  7 Blackberry 2              1         NA          NA                          0
##  8 Blackberry 1              8         NA          NA                          0
##  9 Blackberry 3              8         NA          NA                          0
## 10 Blackberry 5              8         NA          NA                          0
## # ℹ 1,485 more rows
## # ℹ abbreviated name: ¹​cata_appearance_unevencolor
## # ℹ 35 more variables: cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>,
## #   cata_appearance_fresh <dbl>, cata_appearance_goodshape <dbl>,
## #   cata_appearance_goodquality <dbl>, cata_appearance_none <dbl>, …
```

But now we have this intermediate we don't really need cluttering up our `Environment` tab.  This is fine for a single step, but if you have a lot of steps in your analysis this is going to get old (and confusing) fast.  You'll have to remove a lot of these using the `rm()` command to keep your code clean.

<font color="red">**warning**:</font> `rm()` will *permanently* delete whatever objects you run it on from your `Environment`, and you will only be able to restore them by rerunning the code that generated them in the first place.


```r
rm(blackberries)
```

The final method, and what is becoming standard in modern `R` coding, is the **pipe**, which is written in `tidyverse` as `%>%`.  This garbage-looking set of symbols is actually your best friend, you just don't know it yet.  I use this tool constantly in my R programming, but I've been avoiding it up to this point because it wasn't a part of base R for the vast majority of its history.

OK, enough background, what the heck _is_ a pipe?  The term "pipe" comes from what it does: like a pipe, `%>%` let's whatever is on it's left side flow through to the right hand side.  It is easiest to read `%>%` as "**AND THEN**". 


```r
berry_data %>%                             # Start with the berry_data
  filter(berry == "blackberry") %>%        # AND THEN filter to blackberries
  select(`Sample Name`,                    # AND THEN select sample name, overall liking...
         contains("_overall"), 
         contains("cata_"))
```

```
## # A tibble: 1,495 × 40
##    `Sample Name` `9pt_overall` us_overall lms_overall cata_appearance_unevenco…¹
##    <chr>                 <dbl>      <dbl>       <dbl>                      <dbl>
##  1 Blackberry 4              2         NA          NA                          0
##  2 Blackberry 2              5         NA          NA                          0
##  3 Blackberry 1              8         NA          NA                          0
##  4 Blackberry 3              6         NA          NA                          0
##  5 Blackberry 5              8         NA          NA                          0
##  6 Blackberry 4              6         NA          NA                          0
##  7 Blackberry 2              1         NA          NA                          0
##  8 Blackberry 1              8         NA          NA                          0
##  9 Blackberry 3              8         NA          NA                          0
## 10 Blackberry 5              8         NA          NA                          0
## # ℹ 1,485 more rows
## # ℹ abbreviated name: ¹​cata_appearance_unevencolor
## # ℹ 35 more variables: cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>,
## #   cata_appearance_fresh <dbl>, cata_appearance_goodshape <dbl>,
## #   cata_appearance_goodquality <dbl>, cata_appearance_none <dbl>, …
```

In this example, each place there is a `%>%` I've added a comment saying "AND THEN".  This is because that's exactly what the pipe does: it passes whatever happened in the previous step to the next function.  Specifically, `%>%` passes the **results** of the previous line to the **first argument** of the next line.

### Pipes require that the lefthand side be a single functional command

This means that we can't directly do something like rewrite `sqrt(1 + 2)` with `%>%`:


```r
1 + 2 %>% sqrt # this is instead computing 1 + sqrt(2)
```

```
## [1] 2.414214
```

Instead, if we want to pass binary operators in a pipe, we need to enclose them in `()` on the line they are in:


```r
(1 + 2) %>% sqrt() # Now this computes sqrt(1 + 2) = sqrt(3)
```

```
## [1] 1.732051
```

More complex piping is possible using the curly braces (`{}`), which create new R environments, but this is more advanced than you will generally need to be.

### Pipes always pass the result of the lefthand side to the *first* argument of the righthand side

This sounds like a weird logic puzzle, but it's not, as we can see if we look at some simple math.  Let's define a function for use in a pipe that computes the difference between two numbers:


```r
subtract <- function(a, b) a - b
subtract(5, 4)
```

```
## [1] 1
```

If we want to rewrite that as a pipe, we can write:


```r
5 %>% subtract(4)
```

```
## [1] 1
```

But we can't write 


```r
4 %>% subtract(5) # this is actually making subtract(4, 5)
```

```
## [1] -1
```

We can explicitly force the pipe to work the way we want it to by using `.` **as the placeholder for the result of the lefthand side**:


```r
4 %>% subtract(5, .) # now this properly computes subtract(5, 4)
```

```
## [1] 1
```

So, when you're using pipes, make sure that the output of the lefthand side *should* be going into the first argument of the righthand side--this is often but not always the case, especially with non-`tidyverse` functions.

### Pipes are a pain to type

Typing `%>%` is no fun.  But, happily, RStudio builds in a shortcut for you: macOS is `cmd + shift + M`, Windows is `ctrl + shift + M`.

## Make new columns: `mutate()`

You hopefully are starting to be excited by the relative ease of doing some things in R with `tidyverse` that are otherwise a little bit abstruse.  Here's where I think things get really, really cool.  The `mutate()` function *creates a new column in the existing dataset*. 

We can do this in base R by setting a new name for a column and using the assign (`<-`) operator, but this is clumsy and often requires care to maintain the proper ordering of rows. Often, we want to create a new column temporarily, or to combine several existing columns.  We can do this using the `mutate()` function.

Let's say that we want to create a quick categorical variable that tells us whether a berry was rated higher after the actual tasting event than the pre-tasting expectation.

We know that we can use `filter()` to get just the berries with `post_expectation > pre_expectation`:



```r
berry_data %>%
  filter(post_expectation > pre_expectation)
```

```
## # A tibble: 1,612 × 92
##    `Subject Code` `Participant Name` Gender Age   `Start Time (UTC)`
##             <dbl>              <dbl> <lgl>  <lgl> <chr>             
##  1           1001               1001 NA     NA    6/13/2019 20:55   
##  2           1002               1002 NA     NA    6/13/2019 20:03   
##  3           1004               1004 NA     NA    6/13/2019 20:54   
##  4           1005               1005 NA     NA    6/13/2019 20:08   
##  5           1005               1005 NA     NA    6/13/2019 19:54   
##  6           1006               1006 NA     NA    6/13/2019 18:49   
##  7           1007               1007 NA     NA    6/13/2019 18:52   
##  8           1009               1009 NA     NA    6/13/2019 20:39   
##  9           1010               1010 NA     NA    6/13/2019 20:02   
## 10           1010               1010 NA     NA    6/13/2019 20:14   
## # ℹ 1,602 more rows
## # ℹ 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, …
```

But what if we want to be able to just see this?


```r
berry_data %>%
  mutate(improved = post_expectation > pre_expectation) %>%
  # We'll select just a few columns to help us see the result
  select(`Participant Name`, `Sample Name`, pre_expectation, post_expectation, improved)
```

```
## # A tibble: 7,507 × 5
##    `Participant Name` `Sample Name` pre_expectation post_expectation improved
##                 <dbl> <chr>                   <dbl>            <dbl> <lgl>   
##  1               1001 raspberry 6                 2                1 FALSE   
##  2               1001 raspberry 5                 4                5 TRUE    
##  3               1001 raspberry 2                 2                2 FALSE   
##  4               1001 raspberry 3                 4                4 FALSE   
##  5               1001 raspberry 4                 3                2 FALSE   
##  6               1001 raspberry 1                 4                2 FALSE   
##  7               1002 raspberry 6                 2                2 FALSE   
##  8               1002 raspberry 5                 3                2 FALSE   
##  9               1002 raspberry 2                 5                2 FALSE   
## 10               1002 raspberry 3                 3                5 TRUE    
## # ℹ 7,497 more rows
```

What does the above function do?

`mutate()` is a very easy way to edit your data mid-pipe.  So we might want to do some calculations, create a temporary variable using `mutate()`, and then continue our pipe.  **Unless we use `<-` to store our `mutate()`'d data, the results will be only temporary.**

We can use the same kind of functional logic we've been using in other `tidyverse` commands in `mutate()` to get real, powerful results.  For example, it might be easier to interpret the individual ratings on the 9-point scale if we can compare them to the `mean()` of all berry ratings.  We can do this easily using `mutate()`:


```r
# Let's find out the average (mean) rating for the berries on the 9-point scale
berry_data$`9pt_overall` %>% #we need the backticks for $ subsetting whenever we'd need them for tidy-selecting 
  mean(na.rm = TRUE)
```

```
## [1] 5.679346
```

```r
# Now, let's create a column that tells us how far each rating is from to the average
berry_data %>%
  mutate(difference_from_average = `9pt_overall` - mean(`9pt_overall`, na.rm = TRUE)) %>%
  # Again, let's select just a few columns
  select(`Sample Name`, `9pt_overall`, difference_from_average)
```

```
## # A tibble: 7,507 × 3
##    `Sample Name` `9pt_overall` difference_from_average
##    <chr>                 <dbl>                   <dbl>
##  1 raspberry 6               4                   -1.68
##  2 raspberry 5               9                    3.32
##  3 raspberry 2               3                   -2.68
##  4 raspberry 3               7                    1.32
##  5 raspberry 4               4                   -1.68
##  6 raspberry 1               4                   -1.68
##  7 raspberry 6               4                   -1.68
##  8 raspberry 5               7                    1.32
##  9 raspberry 2               7                    1.32
## 10 raspberry 3               9                    3.32
## # ℹ 7,497 more rows
```
## Split-apply-combine analyses

Many basic data analyses can be described as *split-apply-combine*: *split* the data into groups, *apply* some analysis into groups, and then *combine* the results.

For example, in our `berry_data` we might want to split the data by each berry sample, calculate the average overall rating and standard deviation of the rating for each, and the generate a summary table telling us these results.  Using the `filter()` and `select()` commands we've learned so far, you could probably cobble together this analysis without further tools.

However, `tidyverse` provides two powerful tools to do this kind of analysis:

    1.  The `group_by()` function takes a data table and groups it by **categorical** values of any column (generally don't try to use `group_by()` on a numeric variable)
    2.  The `summarize()` function is like `mutate()` for groups created with `group_by()`: 
        1.  First, you specify 1 or more new columns you want to calculate for each group
        2.  Second, the function produces 1 value for each group for each new column

### Groups of data: Split-apply

The first of these tools is `group_by()`, which you *can* use with `mutate()` if you want to use both individual observed values (one per row) and groupwise summary statistics to calculate a new column.

If we wanted to make a column that shows how each individual person's rating differs from the mean of *that specific berry sample*:


```r
berry_data %>%
  group_by(`Sample Name`) %>%
  mutate(difference_from_average = `9pt_overall` - mean(`9pt_overall`, na.rm = TRUE)) %>%
  # Again, let's select just a few columns
  select(`Sample Name`, `9pt_overall`, difference_from_average)
```

```
## # A tibble: 7,507 × 3
## # Groups:   Sample Name [23]
##    `Sample Name` `9pt_overall` difference_from_average
##    <chr>                 <dbl>                   <dbl>
##  1 raspberry 6               4                  -2.30 
##  2 raspberry 5               9                   3.04 
##  3 raspberry 2               3                  -2.86 
##  4 raspberry 3               7                   0.832
##  5 raspberry 4               4                  -1.82 
##  6 raspberry 1               4                  -0.968
##  7 raspberry 6               4                  -2.30 
##  8 raspberry 5               7                   1.04 
##  9 raspberry 2               7                   1.14 
## 10 raspberry 3               9                   2.83 
## # ℹ 7,497 more rows
```

You might notice that the `mutate()` call hasn't been changed at all from when we did this in the last code chunk using the global average, but that the numbers are in fact different. The tibble also now tells us that it has `Groups: Sample Name[23]`, because of our group_by() call.

It's good practice to `ungroup()` as soon as you're done calculating groupwise statistics, so you don't cause unexpected problems later in the analysis.


```r
berry_data %>%
  select(`Sample Name`, `9pt_overall`) %>%
  group_by(`Sample Name`) %>%
  mutate(group_average = mean(`9pt_overall`, na.rm = TRUE),
         difference_from_average = `9pt_overall` - group_average) %>%
  ungroup() %>%
  mutate(grand_average = mean(`9pt_overall`, na.rm = TRUE))
```

```
## # A tibble: 7,507 × 5
##    `Sample Name` `9pt_overall` group_average difference_from_average
##    <chr>                 <dbl>         <dbl>                   <dbl>
##  1 raspberry 6               4          6.30                  -2.30 
##  2 raspberry 5               9          5.96                   3.04 
##  3 raspberry 2               3          5.86                  -2.86 
##  4 raspberry 3               7          6.17                   0.832
##  5 raspberry 4               4          5.82                  -1.82 
##  6 raspberry 1               4          4.97                  -0.968
##  7 raspberry 6               4          6.30                  -2.30 
##  8 raspberry 5               7          5.96                   1.04 
##  9 raspberry 2               7          5.86                   1.14 
## 10 raspberry 3               9          6.17                   2.83 
## # ℹ 7,497 more rows
## # ℹ 1 more variable: grand_average <dbl>
```

You'll see that the `Groups` info at the top of the tibble is gone, and that thanks to `ungroup()` every single row has the same grand average.

### Split-apply-combine in fewer steps with `summarize()`

So why would we want to use `summarize()`? Well, it's not very convenient to have repeated data if we just want the average rating of each group (or any other groupwise **summary**).

Use `mutate()` when you want to add a **new column with one number for each current row**. Use `summarize()` when you need to use data from **multiple rows to create a summary**.

To accomplish the example above, we'd do the following:


```r
berry_summary <- 
  berry_data %>%
  filter(!is.na(`9pt_overall`)) %>%                    # only rows with 9-point ratings
  group_by(`Sample Name`) %>%                          # we will create a group for each berry sample
  summarize(n_responses = n(),                         # n() counts number of ratings for each berry
            mean_rating = mean(`9pt_overall`),         # the mean rating for each species
            sd_rating = sd(`9pt_overall`),             # the standard deviation in rating
            se_rating = sd(`9pt_overall`) / sqrt(n())) # multiple functions in 1 row

berry_summary
```

```
## # A tibble: 23 × 5
##    `Sample Name` n_responses mean_rating sd_rating se_rating
##    <chr>               <int>       <dbl>     <dbl>     <dbl>
##  1 Blackberry 1           93        5.12      2.23     0.231
##  2 Blackberry 2           93        4.66      2.24     0.232
##  3 Blackberry 3           93        5.65      2.14     0.222
##  4 Blackberry 4           93        5.82      2.10     0.217
##  5 Blackberry 5           93        5.94      1.99     0.207
##  6 Blueberry 1           105        5.75      1.91     0.186
##  7 Blueberry 2           105        5.85      1.93     0.188
##  8 Blueberry 3           105        5.61      1.92     0.188
##  9 Blueberry 4           105        5.70      2.08     0.203
## 10 Blueberry 5           105        5.38      2.17     0.212
## # ℹ 13 more rows
```

We can use this approach to even get a summary stats table - for example, confidence limits according to the normal distribution:


```r
berry_summary %>%
  mutate(lower_limit = mean_rating - 1.96 * se_rating,
         upper_limit = mean_rating + 1.96 * se_rating)
```

```
## # A tibble: 23 × 7
##    `Sample Name` n_responses mean_rating sd_rating se_rating lower_limit
##    <chr>               <int>       <dbl>     <dbl>     <dbl>       <dbl>
##  1 Blackberry 1           93        5.12      2.23     0.231        4.67
##  2 Blackberry 2           93        4.66      2.24     0.232        4.20
##  3 Blackberry 3           93        5.65      2.14     0.222        5.21
##  4 Blackberry 4           93        5.82      2.10     0.217        5.39
##  5 Blackberry 5           93        5.94      1.99     0.207        5.53
##  6 Blueberry 1           105        5.75      1.91     0.186        5.39
##  7 Blueberry 2           105        5.85      1.93     0.188        5.48
##  8 Blueberry 3           105        5.61      1.92     0.188        5.24
##  9 Blueberry 4           105        5.70      2.08     0.203        5.31
## 10 Blueberry 5           105        5.38      2.17     0.212        4.97
## # ℹ 13 more rows
## # ℹ 1 more variable: upper_limit <dbl>
```

Note that in the above example we use `mutate()`, *not* `summarize()`, because we had saved our summarized data.  We could also have calculated `lower_limit` and `upper_limit` directly as part of the `summarize()` statement if we hadn't saved the intermediate.

## Groups of columns and across()

It's more common to have groups of **observations** in tidy data, reflected by categorical variables--each `Subject Code` is a group, each `berry` type is a group, each `testing_day` is a group, etc. But we can also have groups of **variables**, as we do in the `berry_data` we've been using!

We have a group of `cata_` variables, a group of liking data with subtypes `9_pt`, `lms_`, `us_`, `_overall`, `_appearance`, etc...

What if we want to count the total number of times each `cata_` attribute was used for one of the berries?

Well, we *can* do this with `summarize()`, but we'd have to type out the names of all 36 columns manually. This is what `select()` helpers are for, and we *can* use them in functions that operate on rows or groups like `filter()`, `mutate()`, and `summarize()` if we use the new `across()` function.


```r
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(.cols = starts_with("cata_"),
                   .fns = sum))
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

You might read this as: `summarize()` `across()` every `.col` that `starts_with("cata_")` by taking the `sum()`. 

We can easily expand this to take multiple kinds of summaries for each column, in which case it helps to **name** the functions. `across()` uses **lists** to work with more than one function, so it will look at the **list names** (lefthand-side of the arguments in `list()`) to name the output columns:


```r
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(.cols = starts_with("cata_"),
                              #the sum of binary cata data gives the citation frequency
                   .fns = list(frequency = sum,
                              #meanwhile, the mean gives the percentage.
                               percentage = mean)))
```

```
## # A tibble: 23 × 73
##    `Sample Name` cata_appearance_unevencolor_frequency cata_appearance_unevenc…¹
##    <chr>                                         <dbl>                     <dbl>
##  1 Blackberry 1                                     28                    0.0936
##  2 Blackberry 2                                     32                    0.107 
##  3 Blackberry 3                                     25                    0.0836
##  4 Blackberry 4                                     46                    0.154 
##  5 Blackberry 5                                     32                    0.107 
##  6 Blueberry 1                                      46                    0.147 
##  7 Blueberry 2                                      48                    0.153 
##  8 Blueberry 3                                      34                    0.109 
##  9 Blueberry 4                                      29                    0.0927
## 10 Blueberry 5                                      22                    0.0703
## # ℹ 13 more rows
## # ℹ abbreviated name: ¹​cata_appearance_unevencolor_percentage
## # ℹ 70 more variables: cata_appearance_misshapen_frequency <dbl>,
## #   cata_appearance_misshapen_percentage <dbl>,
## #   cata_appearance_creased_frequency <dbl>,
## #   cata_appearance_creased_percentage <dbl>,
## #   cata_appearance_seedy_frequency <dbl>, …
```

`across()` is capable of taking arbitrarily complicated functions, but you'll notice that we didn't include the parentheses we usually see after a function name for `sum()` and `mean()`. `across()` will just pipe in each column to the `.fns` as the first argument. That means, however, that there's nowhere for us to put additional arguments like `na.rm`.

We can use **lambda functions** to . This basically just means starting each function off with a tilde (~) and telling `across()` where we want our `.cols` to go manually using `.x`.

Remember, the tilde is usually above the backtick on QWERTY keyboards. Try the instructions [here](https://apple.stackexchange.com/questions/286197/typing-the-tilde-character-on-a-pc-keyboard) and [here](https://www.liquisearch.com/tilde/keyboards) to type a tilde if you have a non-QWERTY keyboard. If those methods don't work, try [this guide for Italian keyboards](https://superuser.com/questions/667622/italian-keyboard-entering-tilde-and-backtick-characters-without-changin), [this guide for Spanish keyboards](https://apple.stackexchange.com/q/219603/5472), [this guide for German](https://apple.stackexchange.com/q/395677/5472), [this guide for Norwegian](https://apple.stackexchange.com/q/141066/5472), or [this guide for Swedish](https://apple.stackexchange.com/q/329085/5472) keyboards.

This will be necessary if we want to take the average of our various liking columns without those pesky `NA`s propogating.


```r
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(.cols = starts_with("9pt_"),
                   .fns = list(mean = mean,
                               sd = sd))) #All NA
```

```
## # A tibble: 23 × 11
##    `Sample Name` `9pt_appearance_mean` `9pt_appearance_sd` `9pt_overall_mean`
##    <chr>                         <dbl>               <dbl>              <dbl>
##  1 Blackberry 1                     NA                  NA                 NA
##  2 Blackberry 2                     NA                  NA                 NA
##  3 Blackberry 3                     NA                  NA                 NA
##  4 Blackberry 4                     NA                  NA                 NA
##  5 Blackberry 5                     NA                  NA                 NA
##  6 Blueberry 1                      NA                  NA                 NA
##  7 Blueberry 2                      NA                  NA                 NA
##  8 Blueberry 3                      NA                  NA                 NA
##  9 Blueberry 4                      NA                  NA                 NA
## 10 Blueberry 5                      NA                  NA                 NA
## # ℹ 13 more rows
## # ℹ 7 more variables: `9pt_overall_sd` <dbl>, `9pt_taste_mean` <dbl>,
## #   `9pt_taste_sd` <dbl>, `9pt_texture_mean` <dbl>, `9pt_texture_sd` <dbl>,
## #   `9pt_aroma_mean` <dbl>, `9pt_aroma_sd` <dbl>
```

```r
berry_data %>%
  group_by(`Sample Name`) %>%
  summarize(across(.cols = starts_with("9pt_"),
                   .fns = list(mean = ~ mean(.x, na.rm = TRUE),
                               sd = ~ sd(.x, na.rm = TRUE))))
```

```
## # A tibble: 23 × 11
##    `Sample Name` `9pt_appearance_mean` `9pt_appearance_sd` `9pt_overall_mean`
##    <chr>                         <dbl>               <dbl>              <dbl>
##  1 Blackberry 1                   6.57                1.64               5.12
##  2 Blackberry 2                   6.43                1.61               4.66
##  3 Blackberry 3                   6.96                1.37               5.65
##  4 Blackberry 4                   5.90                1.97               5.82
##  5 Blackberry 5                   5.99                1.82               5.94
##  6 Blueberry 1                    6.75                1.55               5.75
##  7 Blueberry 2                    6.61                1.53               5.85
##  8 Blueberry 3                    6.4                 1.68               5.61
##  9 Blueberry 4                    6.45                1.72               5.70
## 10 Blueberry 5                    6.39                1.74               5.38
## # ℹ 13 more rows
## # ℹ 7 more variables: `9pt_overall_sd` <dbl>, `9pt_taste_mean` <dbl>,
## #   `9pt_taste_sd` <dbl>, `9pt_texture_mean` <dbl>, `9pt_texture_sd` <dbl>,
## #   `9pt_aroma_mean` <dbl>, `9pt_aroma_sd` <dbl>
```

The `across()` function is very powerful and also pretty new to the tidyverse. It's probably the least intuitive thing we're covering today other than graphs, in my opinion, but it's also leagues better than the `summarize_at()`, `summarize_if()`, and `summarize_all()` functions that came before.

You can also use `across()` to `filter()` rows based on multiple columns or `mutate()` multiple columns at once, but you don't need to worry about `across()` at all if you know exactly what columns you're working with and don't mind typing them all out!

