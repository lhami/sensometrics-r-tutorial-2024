# Wrangling data with `tidyverse`



A common saying in data science is that about 90% of the effort in an analysis workflow is in getting data wrangled into the right format and shape, and 10% is actual analysis.  In a point and click program like SPSS or XLSTAT we don't think about this as much because the activity of reshaping the data--making it longer or wider as required, finding and cleaning missing values, selecting columns or rows, etc--is often temporally and programmatically separated from the "actual" analysis. 

In `R`, this can feel a bit different because we are using the same interface to manipulate our data and to analyze it.  Sometimes we'll want to jump back out to a spreadsheet program like Excel or even the command line (the "shell" like `bash` or `zsh`) to make some changes.  But in general the tools for manipulating data in `R` are both more powerful and more easily used than doing these activities by hand, and you will make yourself a much more effective analyst by mastering these basic tools.

Here, we are going to emphasize the set of tools from the [`tidyverse`](https://www.tidyverse.org/), which are extensively documented in Hadley Wickham's and Garrett Grolemund's book [*R for Data Science*](https://r4ds.had.co.nz/).  If you want to learn more, start there!

<center>

![The `tidyverse` is associated with this hexagonal iconography.](img/tidyverse-iconography.png)

</center>

Before we move on to actually learning the tools, let's make sure we've got our data loaded up.


```r
library(tidyverse)
beer_data <- read_csv("data/ba_2002.csv")
```

```
## Rows: 20359 Columns: 14
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (5): reviews, beer_name, brewery_name, style, user_id
## dbl (9): beer_id, brewery_id, abv, appearance, aroma, palate, taste, overall...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```


## Subsetting data

R's system for **indexing** data frames is clear and sensible for those who are used to programming languages, but it is not necessarily easy to read.  

A common situation in R is wanting to select some rows and some columns of our data--this is called "**subsetting**" our data.  But this is less easy than it might be for the beginner in R.  Happily, the `tidverse` methods are much easier to read (and modeled after syntax from **SQL**, which may be helpful for some users.)  We are going to focus on 

### `select()` for columns

The first thing we often want to do in a data analysis is to pick a subset of columns, which usually represent variables.  If we take a look at our beer data, we see that, for example, we have some columns that are data about our beers, and some columns that are user-generated responses:


```r
glimpse(beer_data)
```

```
## Rows: 20,359
## Columns: 14
## $ reviews      <chr> "This is a very good Irish ale. I'm not sure if it would …
## $ beer_name    <chr> "Caffrey's Irish Ale", "Caffrey's Irish Ale", "Caffrey's …
## $ beer_id      <dbl> 825, 825, 825, 825, 825, 825, 825, 825, 825, 825, 825, 82…
## $ brewery_name <chr> "Thomas Caffrey Brewing Co.", "Thomas Caffrey Brewing Co.…
## $ brewery_id   <dbl> 297, 297, 297, 297, 297, 297, 297, 297, 297, 297, 297, 29…
## $ style        <chr> "Irish Red Ale", "Irish Red Ale", "Irish Red Ale", "Irish…
## $ abv          <dbl> 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.…
## $ user_id      <chr> "jisurfer.1152", "allboutbierge.746", "frank4sail.48", "b…
## $ appearance   <dbl> 5.0, 5.0, 4.0, 3.5, 4.0, 4.0, 3.5, 4.0, 4.0, 4.0, 4.0, 2.…
## $ aroma        <dbl> 4.0, 3.5, 3.0, 3.5, 3.0, 3.0, 3.5, 3.0, 4.0, 3.0, 4.0, 2.…
## $ palate       <dbl> 4.0, 4.0, 3.0, 3.5, 4.0, 2.5, 4.0, 3.0, 4.0, 3.5, 3.0, 2.…
## $ taste        <dbl> 4.5, 3.5, 3.5, 3.5, 4.5, 3.0, 3.5, 3.0, 4.0, 3.0, 3.0, 2.…
## $ overall      <dbl> 5.0, 4.0, 3.0, 3.5, 3.5, 3.5, 3.5, 3.0, 4.0, 3.5, 3.5, 2.…
## $ rating       <dbl> 4.46, 3.74, 3.26, 3.50, 3.86, 3.11, 3.55, 3.06, 4.00, 3.2…
```

So, for example, we might want to try to reverse engineer the way that the `rating` is generated from the sub-modalities, in which case perhaps we only want the last 6 columns.  We learned previously that we can do this with numeric indexing:


```r
beer_data[, 9:14]
```

```
## # A tibble: 20,359 × 6
##    appearance aroma palate taste overall rating
##         <dbl> <dbl>  <dbl> <dbl>   <dbl>  <dbl>
##  1        5     4      4     4.5     5     4.46
##  2        5     3.5    4     3.5     4     3.74
##  3        4     3      3     3.5     3     3.26
##  4        3.5   3.5    3.5   3.5     3.5   3.5 
##  5        4     3      4     4.5     3.5   3.86
##  6        4     3      2.5   3       3.5   3.11
##  7        3.5   3.5    4     3.5     3.5   3.55
##  8        4     3      3     3       3     3.06
##  9        4     4      4     4       4     4   
## 10        4     3      3.5   3       3.5   3.21
## # ℹ 20,349 more rows
```

However, this is both difficult for novices to `R` and difficult to read if you are not intimately familiar with the data.  It is also rather fragile--what if someone else rearranged the data in your import file?  You're just selecting the last 6 columns, which are not guaranteed to contain the rating data you're interested in.


The `select()` function in `tidyverse` (actually from the `dplyr` package) is the smarter, easier way to do this.  It works on data frames, and it can be read as "from \<data frame\>, select the columns that meet the criteria we've set." 

`select(<data frame>, <column 1>, <column 2>, ...)`

The simplest way to use `select()` is just to name the columns you want!


```r
select(beer_data, appearance, aroma, palate, taste, overall, rating) # note the lack of quoting on the column names
```

```
## # A tibble: 20,359 × 6
##    appearance aroma palate taste overall rating
##         <dbl> <dbl>  <dbl> <dbl>   <dbl>  <dbl>
##  1        5     4      4     4.5     5     4.46
##  2        5     3.5    4     3.5     4     3.74
##  3        4     3      3     3.5     3     3.26
##  4        3.5   3.5    3.5   3.5     3.5   3.5 
##  5        4     3      4     4.5     3.5   3.86
##  6        4     3      2.5   3       3.5   3.11
##  7        3.5   3.5    4     3.5     3.5   3.55
##  8        4     3      3     3       3     3.06
##  9        4     4      4     4       4     4   
## 10        4     3      3.5   3       3.5   3.21
## # ℹ 20,349 more rows
```

This is much clearer to the reader.

You can also use `select()` with a number of helper functions, which use logic to select columns that meet whatever conditions you set.  For example, the `starts_with()` helper function lets us give a set of characters we want columns to start with:


```r
select(beer_data, starts_with("beer"))
```

```
## # A tibble: 20,359 × 2
##    beer_name           beer_id
##    <chr>                 <dbl>
##  1 Caffrey's Irish Ale     825
##  2 Caffrey's Irish Ale     825
##  3 Caffrey's Irish Ale     825
##  4 Caffrey's Irish Ale     825
##  5 Caffrey's Irish Ale     825
##  6 Caffrey's Irish Ale     825
##  7 Caffrey's Irish Ale     825
##  8 Caffrey's Irish Ale     825
##  9 Caffrey's Irish Ale     825
## 10 Caffrey's Irish Ale     825
## # ℹ 20,349 more rows
```

There are equivalents for the end of column names (`ends_with()`) and text found anywhere in the name (`contains()`). 

You can combine these statements together to get subsets of columns however you want:


```r
select(beer_data, starts_with("beer"), rating, abv)
```

```
## # A tibble: 20,359 × 4
##    beer_name           beer_id rating   abv
##    <chr>                 <dbl>  <dbl> <dbl>
##  1 Caffrey's Irish Ale     825   4.46   3.8
##  2 Caffrey's Irish Ale     825   3.74   3.8
##  3 Caffrey's Irish Ale     825   3.26   3.8
##  4 Caffrey's Irish Ale     825   3.5    3.8
##  5 Caffrey's Irish Ale     825   3.86   3.8
##  6 Caffrey's Irish Ale     825   3.11   3.8
##  7 Caffrey's Irish Ale     825   3.55   3.8
##  8 Caffrey's Irish Ale     825   3.06   3.8
##  9 Caffrey's Irish Ale     825   4      3.8
## 10 Caffrey's Irish Ale     825   3.21   3.8
## # ℹ 20,349 more rows
```

You can also use programmatic logic in `select()` by using the `where()` helper function, which gives you the ability to specify columns by any arbitrary function.


```r
select(beer_data, where(~is.numeric(.)))
```

```
## # A tibble: 20,359 × 9
##    beer_id brewery_id   abv appearance aroma palate taste overall rating
##      <dbl>      <dbl> <dbl>      <dbl> <dbl>  <dbl> <dbl>   <dbl>  <dbl>
##  1     825        297   3.8        5     4      4     4.5     5     4.46
##  2     825        297   3.8        5     3.5    4     3.5     4     3.74
##  3     825        297   3.8        4     3      3     3.5     3     3.26
##  4     825        297   3.8        3.5   3.5    3.5   3.5     3.5   3.5 
##  5     825        297   3.8        4     3      4     4.5     3.5   3.86
##  6     825        297   3.8        4     3      2.5   3       3.5   3.11
##  7     825        297   3.8        3.5   3.5    4     3.5     3.5   3.55
##  8     825        297   3.8        4     3      3     3       3     3.06
##  9     825        297   3.8        4     4      4     4       4     4   
## 10     825        297   3.8        4     3      3.5   3       3.5   3.21
## # ℹ 20,349 more rows
```

Besides being easier to write conditions for than indexing with `[]`, `select()` is code that is much closer to how you or I think about what we're actually doing, making code that is more human readable.

### `filter()` for rows

So `select()` lets us pick which columns we want.  Can we also use it to pick particular observations?  No.  But for that, there's `filter()`.

We learned that, using `[]` indexing, we'd specify a set of rows we want.  If we want the first 10 rows of `beer_data`, we'd write


```r
beer_data[1:10, ]
```

```
## # A tibble: 10 × 14
##    reviews         beer_name beer_id brewery_name brewery_id style   abv user_id
##    <chr>           <chr>       <dbl> <chr>             <dbl> <chr> <dbl> <chr>  
##  1 This is a very… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 jisurf…
##  2 Great head cre… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 allbou…
##  3 Wow what a dif… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 frank4…
##  4 Tried this one… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 beergl…
##  5 Caffrey's on-t… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 proc.1…
##  6 The nitro can … Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 zerk.4…
##  7 Nitro can...Ty… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 adr.263
##  8 Excellent pour… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 dogbri…
##  9 A very good Ir… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 goindo…
## 10 Looks very nic… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 irishr…
## # ℹ 6 more variables: appearance <dbl>, aroma <dbl>, palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>
```

Again, this is not very human readable, and if we reorganize our rows this won't be useful anymore.  The `tidyverse` answer to this approach is the `filter()` function, which lets you filter your dataset into specific rows according to *data stored in the table itself*.


```r
filter(beer_data, abv > 10) # let's get some heavy beers
```

```
## # A tibble: 571 × 14
##    reviews         beer_name beer_id brewery_name brewery_id style   abv user_id
##    <chr>           <chr>       <dbl> <chr>             <dbl> <chr> <dbl> <chr>  
##  1 This is a pers… Thomas H…     578 O'Hanlon Br…       1533 Old …  11.7 putnam…
##  2 While I a not … Thomas H…     578 O'Hanlon Br…       1533 Old …  11.7 proc.1…
##  3 1997. Head is … Thomas H…     578 O'Hanlon Br…       1533 Old …  11.7 nerofi…
##  4 Dark amber/bro… Thomas H…     578 O'Hanlon Br…       1533 Old …  11.7 john.1…
##  5 A brandy compa… Thomas H…     578 O'Hanlon Br…       1533 Old …  11.7 aracau…
##  6 Presentation: … Thomas H…     578 O'Hanlon Br…       1533 Old …  11.7 jason.3
##  7 pours out blac… Thomas H…     578 O'Hanlon Br…       1533 Old …  11.7 budgoo…
##  8 I know, I know… Thomas H…     578 O'Hanlon Br…       1533 Old …  11.7 mophie…
##  9 1988 must have… Harvest …     705 J.W. Lees &…        178 Engl…  11.5 maxpow…
## 10 1997 vintage. … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 suds.3…
## # ℹ 561 more rows
## # ℹ 6 more variables: appearance <dbl>, aroma <dbl>, palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>
```

When using `filter()`, we can specify multiple logical conditions.  For example, let's get only Barleywines that are more than 10% ABV.  If we wanted only exact matches, we could use the direct `==` operator:


```r
filter(beer_data, abv > 10, style == "American Barleywine")
```

```
## # A tibble: 99 × 14
##    reviews         beer_name beer_id brewery_name brewery_id style   abv user_id
##    <chr>           <chr>       <dbl> <chr>             <dbl> <chr> <dbl> <chr>  
##  1 For me, this i… Olde Deu…    2066 Alley Kat B…        711 Amer…  11   mab.734
##  2 2000 vintage.T… Beer Line    3048 Lakefront B…        741 Amer…  12.5 bighug…
##  3 A Barleywine m… Beer Line    3048 Lakefront B…        741 Amer…  12.5 zap.184
##  4 Well, Lagunita… Olde Gna…    1579 Lagunitas B…        220 Amer…  10.6 sinist…
##  5 Bottle reads 1… Olde Gna…    1579 Lagunitas B…        220 Amer…  10.6 bighug…
##  6 Presentation: … AleSmith…    6646 AleSmith Br…        396 Amer…  11   jason.3
##  7 This is for th… AleSmith…    6646 AleSmith Br…        396 Amer…  11   aracau…
##  8 It's golden br… AleSmith…    6646 AleSmith Br…        396 Amer…  11   mickey…
##  9 The color is a… John Bar…   20500 Mad River B…        266 Amer…  11.4 beerma…
## 10 Pours a slight… John Bar…   20500 Mad River B…        266 Amer…  11.4 murph.…
## # ℹ 89 more rows
## # ℹ 6 more variables: appearance <dbl>, aroma <dbl>, palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>
```

But this won't return, for example, any beer labeled as an "English Barleywine".  


```r
filter(beer_data, abv > 10, style == "American Barleywine" | style == "English Barleywine")
```

```
## # A tibble: 169 × 14
##    reviews         beer_name beer_id brewery_name brewery_id style   abv user_id
##    <chr>           <chr>       <dbl> <chr>             <dbl> <chr> <dbl> <chr>  
##  1 1988 must have… Harvest …     705 J.W. Lees &…        178 Engl…  11.5 maxpow…
##  2 1997 vintage. … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 suds.3…
##  3 2000 vintage. … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 shired…
##  4 [email&#160;pr… Harvest …     705 J.W. Lees &…        178 Engl…  11.5 zap.184
##  5 1997. Hazy che… Harvest …     705 J.W. Lees &…        178 Engl…  11.5 marc77…
##  6 2000 vintage. … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 bighug…
##  7 1999. Pours a … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 murph.…
##  8 Bottle reviews… Harvest …     705 J.W. Lees &…        178 Engl…  11.5 bierma…
##  9 I must say my … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 viking…
## 10 For me, this i… Olde Deu…    2066 Alley Kat B…        711 Amer…  11   mab.734
## # ℹ 159 more rows
## # ℹ 6 more variables: appearance <dbl>, aroma <dbl>, palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>
```

In `R`, the `|` means Boolean `OR`, and the `&` means Boolean `AND`.  We can use these to combine conditions for searching our data table.  But this can be a bit tedious.  The `stringr` package, part of `tidyverse`, gives a lot of utility functions that we can use instead of this effortful searching.


```r
filter(beer_data, abv > 10, str_detect(style, "Barleywine"))
```

```
## # A tibble: 169 × 14
##    reviews         beer_name beer_id brewery_name brewery_id style   abv user_id
##    <chr>           <chr>       <dbl> <chr>             <dbl> <chr> <dbl> <chr>  
##  1 1988 must have… Harvest …     705 J.W. Lees &…        178 Engl…  11.5 maxpow…
##  2 1997 vintage. … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 suds.3…
##  3 2000 vintage. … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 shired…
##  4 [email&#160;pr… Harvest …     705 J.W. Lees &…        178 Engl…  11.5 zap.184
##  5 1997. Hazy che… Harvest …     705 J.W. Lees &…        178 Engl…  11.5 marc77…
##  6 2000 vintage. … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 bighug…
##  7 1999. Pours a … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 murph.…
##  8 Bottle reviews… Harvest …     705 J.W. Lees &…        178 Engl…  11.5 bierma…
##  9 I must say my … Harvest …     705 J.W. Lees &…        178 Engl…  11.5 viking…
## 10 For me, this i… Olde Deu…    2066 Alley Kat B…        711 Amer…  11   mab.734
## # ℹ 159 more rows
## # ℹ 6 more variables: appearance <dbl>, aroma <dbl>, palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>
```

Here, the `str_detect()` function searched for any text that **contains** "Barleywine" in the `style` column.

## Combining steps with the pipe: `%>%`

It isn't hard to imagine a situation in which we want to **both** select some columns and filter some rows.  There are 3 ways we can do this, one of which is going to be the best for most situations.

Let's imagine we want to get only information about the beers, abv, and rating for stouts

First, we can nest functions:


```r
select(filter(beer_data, str_detect(style, "Stout")), contains("beer"), abv, rating)
```

```
## # A tibble: 1,666 × 4
##    beer_name                          beer_id   abv rating
##    <chr>                                <dbl> <dbl>  <dbl>
##  1 Kinmount Willie Oatmeal Stout          149   4.2   3.49
##  2 Kinmount Willie Oatmeal Stout          149   4.2   3.92
##  3 Kinmount Willie Oatmeal Stout          149   4.2   3.43
##  4 Kinmount Willie Oatmeal Stout          149   4.2   2.84
##  5 Kinmount Willie Oatmeal Stout          149   4.2   4.13
##  6 Kinmount Willie Oatmeal Stout          149   4.2   3.95
##  7 Dragonhead Stout                      5781   4     4.43
##  8 Le Coq Imperial Extra Double Stout     438  10     4.53
##  9 Le Coq Imperial Extra Double Stout     438  10     4.07
## 10 Le Coq Imperial Extra Double Stout     438  10     2.93
## # ℹ 1,656 more rows
```

The problem with this approach is that we have to read it "inside out".  First, `filter()` will happen and get us only beers that match "Stout" in their `style`.  Then `select()` will get columns that match "beer" in their names, `abv`, and `rating`.  Especially as your code gets complicated, this can be very hard to read.

So we might take the second approach: creating intermediates.  We might first `filter()`, store that step somewhere, then `select()`:


```r
beer_stouts <- filter(beer_data, str_detect(style, "Stout"))
select(beer_stouts, contains("beer"), abv, rating)
```

```
## # A tibble: 1,666 × 4
##    beer_name                          beer_id   abv rating
##    <chr>                                <dbl> <dbl>  <dbl>
##  1 Kinmount Willie Oatmeal Stout          149   4.2   3.49
##  2 Kinmount Willie Oatmeal Stout          149   4.2   3.92
##  3 Kinmount Willie Oatmeal Stout          149   4.2   3.43
##  4 Kinmount Willie Oatmeal Stout          149   4.2   2.84
##  5 Kinmount Willie Oatmeal Stout          149   4.2   4.13
##  6 Kinmount Willie Oatmeal Stout          149   4.2   3.95
##  7 Dragonhead Stout                      5781   4     4.43
##  8 Le Coq Imperial Extra Double Stout     438  10     4.53
##  9 Le Coq Imperial Extra Double Stout     438  10     4.07
## 10 Le Coq Imperial Extra Double Stout     438  10     2.93
## # ℹ 1,656 more rows
```

But now we have this intermediate we don't really need cluttering up our `Environment` tab.  This is fine for a single step, but if you have a lot of steps in your analysis this is going to get old (and confusing) fast.  You'll have to remove a lot of these using the `rm()` command to keep your code clean.

<font color="red">**warning**:</font> `rm()` will *permanently* delete whatever objects you run it on from your `Environment`, and you will only be able to restore them by rerunning the code that generated them in the first place.


```r
rm(beer_stouts)
```

The final method, and what is becoming standard in modern `R` coding, is the **pipe**, which is written in `tidyverse` as `%>%`.  This garbage-looking set of symbols is actually your best friend, you just don't know it yet.  I use this tool constantly in my R programming, but I've been avoiding it up to this point because it's not part of base R (in fact that's no longer strictly true, but it is kind of complicated at the moment).  


OK, enough background, what the heck _is_ a pipe?  The term "pipe" comes from what it does: like a pipe, `%>%` let's whatever is on it's left side flow through to the right hand side.  It is easiest to read `%>%` as "**AND THEN**".  


```r
beer_data %>%                              # Start with the beer_data
  filter(str_detect(style, "Stout")) %>%   # AND THEN filter to stouts
  select(contains("beer"), abv, rating)    # AND THEN select the beer columns, etc
```

```
## # A tibble: 1,666 × 4
##    beer_name                          beer_id   abv rating
##    <chr>                                <dbl> <dbl>  <dbl>
##  1 Kinmount Willie Oatmeal Stout          149   4.2   3.49
##  2 Kinmount Willie Oatmeal Stout          149   4.2   3.92
##  3 Kinmount Willie Oatmeal Stout          149   4.2   3.43
##  4 Kinmount Willie Oatmeal Stout          149   4.2   2.84
##  5 Kinmount Willie Oatmeal Stout          149   4.2   4.13
##  6 Kinmount Willie Oatmeal Stout          149   4.2   3.95
##  7 Dragonhead Stout                      5781   4     4.43
##  8 Le Coq Imperial Extra Double Stout     438  10     4.53
##  9 Le Coq Imperial Extra Double Stout     438  10     4.07
## 10 Le Coq Imperial Extra Double Stout     438  10     2.93
## # ℹ 1,656 more rows
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

Instead, if we want to pass binary operationse in a pipe, we need to enclose them in `()` on the line they are in:


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

We can do this easily in base R by setting a new name for a column and using the assign (`<-`) operator, but this is clumsy. Often, we want to create a new column temporarily, or to combine several existing columns.  We can do this using the `mutate()` function.

Let's say that we want to create a quick categorical variable that tells us whether a beer was rated as more than the central value (2.5) in the 5-pt rating scale.  This is kind of like doing a median split, which we'll get to in a moment.

We know that we can use `filter()` to get just the beers with `rating > 2.5`:



```r
beer_data %>%
  filter(rating > 2.5)
```

```
## # A tibble: 18,782 × 14
##    reviews         beer_name beer_id brewery_name brewery_id style   abv user_id
##    <chr>           <chr>       <dbl> <chr>             <dbl> <chr> <dbl> <chr>  
##  1 This is a very… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 jisurf…
##  2 Great head cre… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 allbou…
##  3 Wow what a dif… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 frank4…
##  4 Tried this one… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 beergl…
##  5 Caffrey's on-t… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 proc.1…
##  6 The nitro can … Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 zerk.4…
##  7 Nitro can...Ty… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 adr.263
##  8 Excellent pour… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 dogbri…
##  9 A very good Ir… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 goindo…
## 10 Looks very nic… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 irishr…
## # ℹ 18,772 more rows
## # ℹ 6 more variables: appearance <dbl>, aroma <dbl>, palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>
```

But what if we want to be able to just see this?


```r
beer_data %>%
  mutate(better_than_2.5 = rating > 2.5) %>%
  # We'll select just a few columns to help us see the result
  select(beer_name, rating, better_than_2.5) 
```

```
## # A tibble: 20,359 × 3
##    beer_name           rating better_than_2.5
##    <chr>                <dbl> <lgl>          
##  1 Caffrey's Irish Ale   4.46 TRUE           
##  2 Caffrey's Irish Ale   3.74 TRUE           
##  3 Caffrey's Irish Ale   3.26 TRUE           
##  4 Caffrey's Irish Ale   3.5  TRUE           
##  5 Caffrey's Irish Ale   3.86 TRUE           
##  6 Caffrey's Irish Ale   3.11 TRUE           
##  7 Caffrey's Irish Ale   3.55 TRUE           
##  8 Caffrey's Irish Ale   3.06 TRUE           
##  9 Caffrey's Irish Ale   4    TRUE           
## 10 Caffrey's Irish Ale   3.21 TRUE           
## # ℹ 20,349 more rows
```

What does the above function do?

`mutate()` is a very easy way to edit your data mid-pipe.  So we might want to do some calculations, create a temporary variable using `mutate()`, and then continue our pipe.  **Unless we use `<-` to store our `mutate()`d data, the results will be only temporary.**

We can use the same kind of functional logic we've been using in other `tidyverse` commands in `mutate()` to get real, powerful results.  For example, we might want to know if a beer is rated better than the `mean()` of the ratings.  We can do this easily using `mutate()`:


```r
# Let's find out the average (mean) rating for these beers
beer_data$rating %>% 
  mean() 
```

```
## [1] 3.719406
```

```r
# Now, let's create a column that tells us if a beer is rated > average
beer_data %>%
  mutate(better_than_average = rating > mean(rating)) %>%
  # Again, let's select just a few columns
  select(beer_name, rating, better_than_average)
```

```
## # A tibble: 20,359 × 3
##    beer_name           rating better_than_average
##    <chr>                <dbl> <lgl>              
##  1 Caffrey's Irish Ale   4.46 TRUE               
##  2 Caffrey's Irish Ale   3.74 TRUE               
##  3 Caffrey's Irish Ale   3.26 FALSE              
##  4 Caffrey's Irish Ale   3.5  FALSE              
##  5 Caffrey's Irish Ale   3.86 TRUE               
##  6 Caffrey's Irish Ale   3.11 FALSE              
##  7 Caffrey's Irish Ale   3.55 FALSE              
##  8 Caffrey's Irish Ale   3.06 FALSE              
##  9 Caffrey's Irish Ale   4    TRUE               
## 10 Caffrey's Irish Ale   3.21 FALSE              
## # ℹ 20,349 more rows
```

## Split-apply-combine analyses with `group_by()` and `summarize()`

Many basic data analyses can be described as *split-apply-combine*: *split* the data into groups, *apply* some analysis into groups, and then *combine* the results.  

For example, in our `beer_data` we might want to split the data into beer styles, calculate the average overall rating and standard deviation of the rating for each beer style, and the generate a summary table telling us these results.  Using the `filter()` and `select()` commands we've learned so far, you could probably cobble together this analysis without further tools.

However, `tidyverse` provides two powerful tools to do this kind of analysis:

1.  The `group_by()` function takes a data table and groups it by **categorical** values of any column (generally don't try to use `group_by()` on a numeric variable)
2.  The `summarize()` function is like `mutate()` for groups created with `group_by()`: 
  1.  First, you specify 1 or more new columns you want to calculate for each group
  2.  Second, the function produces 1 value for each group for each new column
  
To accomplish the example above, we'd do the following:


```r
beer_summary <- 
  beer_data %>%
  group_by(style) %>%                           # we will create a group for each unique style
  summarize(n_beers = n(),                      # n() counts rows in each style
            mean_rating = mean(rating),         # the mean rating for each style
            sd_rating = sd(rating),             # the standard deviation in rating
            se_rating = sd(rating) / sqrt(n())) # multiple functions in 1 row

beer_summary
```

```
## # A tibble: 99 × 5
##    style                          n_beers mean_rating sd_rating se_rating
##    <chr>                            <int>       <dbl>     <dbl>     <dbl>
##  1 Altbier                            186        3.87     0.499    0.0366
##  2 American Adjunct Lager             961        2.55     0.752    0.0243
##  3 American Amber / Red Ale           653        3.74     0.563    0.0220
##  4 American Amber / Red Lager         235        3.29     0.698    0.0455
##  5 American Barleywine                187        4.25     0.478    0.0349
##  6 American Black Ale                  10        3.98     0.490    0.155 
##  7 American Blonde Ale                251        3.52     0.608    0.0383
##  8 American Brown Ale                 166        3.95     0.503    0.0391
##  9 American Dark Wheat Ale             11        3.67     0.453    0.136 
## 10 American Double / Imperial IPA     151        4.34     0.479    0.0390
## # ℹ 89 more rows
```

We can use this approach to even get a summary stats table - for example, confidence limits according to the normal distribution:


```r
beer_summary %>%
  mutate(lower_limit = mean_rating - 1.96 * se_rating,
         upper_limit = mean_rating + 1.96 * se_rating)
```

```
## # A tibble: 99 × 7
##    style         n_beers mean_rating sd_rating se_rating lower_limit upper_limit
##    <chr>           <int>       <dbl>     <dbl>     <dbl>       <dbl>       <dbl>
##  1 Altbier           186        3.87     0.499    0.0366        3.79        3.94
##  2 American Adj…     961        2.55     0.752    0.0243        2.50        2.60
##  3 American Amb…     653        3.74     0.563    0.0220        3.70        3.79
##  4 American Amb…     235        3.29     0.698    0.0455        3.20        3.38
##  5 American Bar…     187        4.25     0.478    0.0349        4.19        4.32
##  6 American Bla…      10        3.98     0.490    0.155         3.67        4.28
##  7 American Blo…     251        3.52     0.608    0.0383        3.45        3.60
##  8 American Bro…     166        3.95     0.503    0.0391        3.88        4.03
##  9 American Dar…      11        3.67     0.453    0.136         3.40        3.94
## 10 American Dou…     151        4.34     0.479    0.0390        4.27        4.42
## # ℹ 89 more rows
```

Note that in the above example we use `mutate()`, *not* `summarize()`, because we had saved our summarized data.  We could also have calculated `lower_limit` and `upper_limit` directly as part of the `summarize()` statement if we hadn't saved the intermediate.

## Utilities for data management

Honestly, the amount of power in `tidyverse` is way more than we can cover today, and is covered more comprehensively (obviously) by [Wickham and Grolemund](https://r4ds.had.co.nz/).  However, I want to name 4 more utilities we will make a lot of use of today (and you will want to know about for your own work).  

### Rename your columns

Often you will import data with bad column names or you'll realize you need to rename variables during your workflow.  For this, you can use the `rename()` function:


```r
names(beer_data)
```

```
##  [1] "reviews"      "beer_name"    "beer_id"      "brewery_name" "brewery_id"  
##  [6] "style"        "abv"          "user_id"      "appearance"   "aroma"       
## [11] "palate"       "taste"        "overall"      "rating"
```

```r
beer_data %>%
  rename(review_text = reviews)
```

```
## # A tibble: 20,359 × 14
##    review_text     beer_name beer_id brewery_name brewery_id style   abv user_id
##    <chr>           <chr>       <dbl> <chr>             <dbl> <chr> <dbl> <chr>  
##  1 This is a very… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 jisurf…
##  2 Great head cre… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 allbou…
##  3 Wow what a dif… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 frank4…
##  4 Tried this one… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 beergl…
##  5 Caffrey's on-t… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 proc.1…
##  6 The nitro can … Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 zerk.4…
##  7 Nitro can...Ty… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 adr.263
##  8 Excellent pour… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 dogbri…
##  9 A very good Ir… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 goindo…
## 10 Looks very nic… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 irishr…
## # ℹ 20,349 more rows
## # ℹ 6 more variables: appearance <dbl>, aroma <dbl>, palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>
```

You can also rename by position, which is helpful for quick changes:


```r
beer_data %>%
  rename(review_text = 1)
```

```
## # A tibble: 20,359 × 14
##    review_text     beer_name beer_id brewery_name brewery_id style   abv user_id
##    <chr>           <chr>       <dbl> <chr>             <dbl> <chr> <dbl> <chr>  
##  1 This is a very… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 jisurf…
##  2 Great head cre… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 allbou…
##  3 Wow what a dif… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 frank4…
##  4 Tried this one… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 beergl…
##  5 Caffrey's on-t… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 proc.1…
##  6 The nitro can … Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 zerk.4…
##  7 Nitro can...Ty… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 adr.263
##  8 Excellent pour… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 dogbri…
##  9 A very good Ir… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 goindo…
## 10 Looks very nic… Caffrey'…     825 Thomas Caff…        297 Iris…   3.8 irishr…
## # ℹ 20,349 more rows
## # ℹ 6 more variables: appearance <dbl>, aroma <dbl>, palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>
```

### Relocate your columns

If you `mutate()` columns or just have a big data set with a lot of variables, often you want to move columns around.  This is a pain to do with `[]`, but again `tidyverse` has a utility to move things around easily: `relocate()`.


```r
beer_data %>%
  relocate(beer_name) # giving no other arguments will move to front
```

```
## # A tibble: 20,359 × 14
##    beer_name         reviews beer_id brewery_name brewery_id style   abv user_id
##    <chr>             <chr>     <dbl> <chr>             <dbl> <chr> <dbl> <chr>  
##  1 Caffrey's Irish … This i…     825 Thomas Caff…        297 Iris…   3.8 jisurf…
##  2 Caffrey's Irish … Great …     825 Thomas Caff…        297 Iris…   3.8 allbou…
##  3 Caffrey's Irish … Wow wh…     825 Thomas Caff…        297 Iris…   3.8 frank4…
##  4 Caffrey's Irish … Tried …     825 Thomas Caff…        297 Iris…   3.8 beergl…
##  5 Caffrey's Irish … Caffre…     825 Thomas Caff…        297 Iris…   3.8 proc.1…
##  6 Caffrey's Irish … The ni…     825 Thomas Caff…        297 Iris…   3.8 zerk.4…
##  7 Caffrey's Irish … Nitro …     825 Thomas Caff…        297 Iris…   3.8 adr.263
##  8 Caffrey's Irish … Excell…     825 Thomas Caff…        297 Iris…   3.8 dogbri…
##  9 Caffrey's Irish … A very…     825 Thomas Caff…        297 Iris…   3.8 goindo…
## 10 Caffrey's Irish … Looks …     825 Thomas Caff…        297 Iris…   3.8 irishr…
## # ℹ 20,349 more rows
## # ℹ 6 more variables: appearance <dbl>, aroma <dbl>, palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>
```

You can also use `relocate()` to specify positions


```r
beer_data %>%
  relocate(reviews, .after = rating) # move the long text to the end
```

```
## # A tibble: 20,359 × 14
##    beer_name      beer_id brewery_name brewery_id style   abv user_id appearance
##    <chr>            <dbl> <chr>             <dbl> <chr> <dbl> <chr>        <dbl>
##  1 Caffrey's Iri…     825 Thomas Caff…        297 Iris…   3.8 jisurf…        5  
##  2 Caffrey's Iri…     825 Thomas Caff…        297 Iris…   3.8 allbou…        5  
##  3 Caffrey's Iri…     825 Thomas Caff…        297 Iris…   3.8 frank4…        4  
##  4 Caffrey's Iri…     825 Thomas Caff…        297 Iris…   3.8 beergl…        3.5
##  5 Caffrey's Iri…     825 Thomas Caff…        297 Iris…   3.8 proc.1…        4  
##  6 Caffrey's Iri…     825 Thomas Caff…        297 Iris…   3.8 zerk.4…        4  
##  7 Caffrey's Iri…     825 Thomas Caff…        297 Iris…   3.8 adr.263        3.5
##  8 Caffrey's Iri…     825 Thomas Caff…        297 Iris…   3.8 dogbri…        4  
##  9 Caffrey's Iri…     825 Thomas Caff…        297 Iris…   3.8 goindo…        4  
## 10 Caffrey's Iri…     825 Thomas Caff…        297 Iris…   3.8 irishr…        4  
## # ℹ 20,349 more rows
## # ℹ 6 more variables: aroma <dbl>, palate <dbl>, taste <dbl>, overall <dbl>,
## #   rating <dbl>, reviews <chr>
```

### Sort your data

More frequently, we will want to rearrange our rows, which can be done with `arrange()`.  All you have to do is give `arrange()` one or more columns to sort the data by.  You can use either the `desc()` or the `-` shortcut to sort in reverse order.


```r
beer_data %>%
  arrange(desc(rating)) %>% # what are the highest rated beers?
  select(beer_name, rating)
```

```
## # A tibble: 20,359 × 2
##    beer_name                     rating
##    <chr>                          <dbl>
##  1 McEwan's India Pale Ale            5
##  2 Samuel Smith's Imperial Stout      5
##  3 Samuel Smith's Imperial Stout      5
##  4 Samuel Smith's Imperial Stout      5
##  5 Samuel Smith's Oatmeal Stout       5
##  6 Samuel Smith's Oatmeal Stout       5
##  7 Samuel Smith's Oatmeal Stout       5
##  8 Young's Ram Rod                    5
##  9 Fuller's 1845                      5
## 10 Mackeson Triple XXX Stout          5
## # ℹ 20,349 more rows
```

You can sort alphabetically as well:


```r
beer_data %>%
  arrange(brewery_name, beer_name) %>% # get beers sorted within breweries
  select(brewery_name, beer_name) %>%  # show only relevant columns
  distinct()                           # discard duplicate rows
```

```
## # A tibble: 4,734 × 2
##    brewery_name           beer_name                          
##    <chr>                  <chr>                              
##  1 21st Amendment Brewery Hell Or High Watermelon Wheat Beer 
##  2 3 Floyds Brewing Co.   Alpha King                         
##  3 3 Floyds Brewing Co.   Alpha Klaus Christmas (Xmas) Porter
##  4 3 Floyds Brewing Co.   Behemoth Blonde Barleywine         
##  5 3 Floyds Brewing Co.   Black Sun Stout                    
##  6 3 Floyds Brewing Co.   Burnham Pilsner                    
##  7 3 Floyds Brewing Co.   Calumet Queen                      
##  8 3 Floyds Brewing Co.   Dark Lord Imperial Stout           
##  9 3 Floyds Brewing Co.   Dreadnaught IPA                    
## 10 3 Floyds Brewing Co.   Extra Pale Ale                     
## # ℹ 4,724 more rows
```

### Pivot tables

Users of Excel may be familiar with the idea of pivot tables.  These are functions that let us make our data tidier.  To quote Wickham and Grolemund:

> here are three interrelated rules which make a dataset tidy:
>
> 1.  Each variable must have its own column.
> 2.  Each observation must have its own row.
> 3.  Each value must have its own cell.

While these authors present "tidiness" of data as an objective property, I'd argue that data is always tidy **for a specific purpose**.  For example, our data is relatively tidy here, except our numerical ratings: we have 6 different ratings for each beer, which means we have encoded an **implicit variable** in the column names: `rating type`.  If we want to use our data for summarization, the form we have is fine.  But if we want to make plots and do some other modeling, this form may be no good to us.

We can use the `pivot_longer()` function to change our data to make the implicit variable explicit and to make our data tidier.


```r
beer_data %>%
  select(beer_name, user_id, appearance:rating) %>% # for clarity
  pivot_longer(cols = appearance:rating,
               names_to = "rating_type",
               values_to = "rating")
```

```
## # A tibble: 122,154 × 4
##    beer_name           user_id           rating_type rating
##    <chr>               <chr>             <chr>        <dbl>
##  1 Caffrey's Irish Ale jisurfer.1152     appearance    5   
##  2 Caffrey's Irish Ale jisurfer.1152     aroma         4   
##  3 Caffrey's Irish Ale jisurfer.1152     palate        4   
##  4 Caffrey's Irish Ale jisurfer.1152     taste         4.5 
##  5 Caffrey's Irish Ale jisurfer.1152     overall       5   
##  6 Caffrey's Irish Ale jisurfer.1152     rating        4.46
##  7 Caffrey's Irish Ale allboutbierge.746 appearance    5   
##  8 Caffrey's Irish Ale allboutbierge.746 aroma         3.5 
##  9 Caffrey's Irish Ale allboutbierge.746 palate        4   
## 10 Caffrey's Irish Ale allboutbierge.746 taste         3.5 
## # ℹ 122,144 more rows
```

Now for each unique combination of `beer_name` and `user_id`, we have 6 rows, one for each type of rating they can generate.

Sometimes we want to have "wider" or "untidy" data.  We can use `pivot_wider()` to reverse the effects of `pivot_longer()`.

While the ideas of pivoting can seem simple, they are both powerful and subtly confusing.  We'll be using these tools throughout the rest of the tutorial, so I wanted to give exposure, but mastering them takes trial and error.  I recommend taking a look at the [relevant chapter in Wickham and Grolemund](https://r4ds.had.co.nz/tidy-data.html) for details.

