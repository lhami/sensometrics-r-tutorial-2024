# How to work with R



Now that we've all got R up and running, we're going to quickly go over the basic functionality of `R` to make sure everyone is on the same page.  If you have ever used `R`, this might include some review, but my hope is that this will be helpful to everyone and get us all on the same page before we launch into some more advanced applications.

We're going to speed through the basics of the console (working interactively with `R`) and then some of the "programming"/"coding" capabilities in `R`.

## Doing math and creating objects in `R`

At it's most basic, `R` can be a calculator.  If you type math into the `Console` and hit `return` it will do math for you!


```r
2 + 5
```

```
## [1] 7
```


```r
1000 / 3.5
```

```
## [1] 285.7143
```

To get the most out of R, though, we are going to want to use its abilities as a programming language.  Among some other topics that I won't explicitly cover today, this means using `R` to store values (and later objects that contain multiple lines of values, like you'd get in an Excel spreadsheet).  

This set of characters is the **assignment operator**: `<-`. It works like this:


```r
x <- 100
hi <- "hello world"
data_set <- rnorm(n = 100, mean = 0, sd = 1)
```

... but that didn't do anything! Where's the output? Well, we can do two things. First, look at the "Environment" tab in your RStudio after you run the above code chunk. You'll notice that there are 3 new things there: `x`, `hi`, and `data_set`. In general I am going to call those **objects**--they are stored variables, which R now knows about by name. How did it learn about them? You guessed it: the assignment operator: `<-`.

To be explicit: `x <- 100` can be read in English as "x gets 100" (what a lot of programmers like to say) or, in a clearer but longer way, "assign 100 to a variable called x".

**NB**: R also allows you to use `=` as an assignment operator. **DO NOT DO THIS!**. There are two good reasons.

1.  It is ambiguous, because it is not directional (how are you sure what is getting assigned where?)
2.  This makes your code super confusing because `=` is the *only* assignment operator for *arguments* in functions (as in `print(quote = FALSE)` see below for more on this)
3.  Anyone who has used R for a while who sees you do this will roll their eyes and kind of make fun of you a little bit

**NB2**: Because it is directional, it is actually possible to use `->` as an assignment operator as well. What do you think it does? Check and find out.

If you find typing `<-` a pain (reasonably), RStudio provides a keyboard shortcut: either `option + -` on Mac or `Alt + -` on PC.

I am going to use the terms "object" and "variable" interchangeably in this workshop--in other programming languages there are hard distinctions between these concepts, and even in some `R` packages this can be important, but for our purposes I mean the same thing if I am sloppy.

The advantage of storing values into objects is that we can do math with them, change them, and duplicate and store them elsewhere.


```r
x / 10
```

```
## [1] 10
```


```r
x + 1
```

```
## [1] 101
```

Note that doing math with a variable doesn't change the variable itself.  To do that, you have to use the assignment `<-` to change the value of the variable again:


```r
x
```

```
## [1] 100
```

```r
x <- 100 + 1
x
```

```
## [1] 101
```

## Functions and their arguments in `R`

Obviously if we're using `R` as a calculator we might want to do more than basic arithmetic.  What about taking the square root of `x`?


```r
sqrt(x)
```

```
## [1] 10.04988
```

In fact, we can ask R to do lots of neat stuff, like generate random numbers for us. For example, here are 100 random numbers from a normal distribution with mean of 0 and standard deviation of 1.


```r
rnorm(n = 100, mean = 0, sd = 1)
```

```
##   [1]  0.345477131  0.980522012 -1.646108939  0.789273441  0.588575374
##   [6] -0.840615802 -0.183580463  2.347837007  0.412548727  0.437937223
##  [11] -0.494995645  0.123278208  0.581768360 -0.619064459  2.606144224
##  [16]  2.669685085 -1.810848868 -0.464502321  1.404273053 -1.032336241
##  [21] -0.804892382  1.493468351 -1.073011136  1.381392871 -0.288892813
##  [26] -0.872661670 -0.002264557  1.414330740  0.675473392  0.058544261
##  [31]  0.157263986 -1.610116736  0.727981769  0.240847863 -2.392679206
##  [36] -0.281271730 -0.881364329 -0.693101220  1.180794172 -0.362510834
##  [41] -0.238654992  0.064657909  0.659104228 -1.468985291  1.563339017
##  [46]  0.208818244  1.862116562 -0.296224711  0.041330052  0.789999514
##  [51]  0.676728538  0.194613495 -0.148085350  1.200402580  0.100133117
##  [56] -1.299382999  0.136666207 -1.313510621 -0.569443174  0.042197153
##  [61] -0.294162080  2.706499018  0.525496767 -1.229283014 -0.626673897
##  [66] -0.674399204  0.057759595 -0.344622900  0.225548251  0.971518426
##  [71] -0.618616109 -0.527658156 -0.159331092 -1.684389833  0.239420229
##  [76] -1.295576885  0.834939354  0.593294536  0.639470763  1.012536597
##  [81]  0.444366484 -0.245744403 -0.293493361 -1.276656942  2.503484826
##  [86]  0.680518940 -0.892837696 -1.236959660  0.551934855 -0.122402358
##  [91]  0.238884861 -0.454698562 -0.655102652  1.982483855  0.356808512
##  [96]  0.706573543 -1.140966219  1.091496012  0.087510741 -0.546832471
```

These forms are called a **function** in R.  Functions lie at the heart of `R`'s power: they are pre-written scripts that are included with base `R` or added in packages, like the ones we installed.  In general, an `R` function will have a form like `<name>(<argument>, <argument>, ...)`.  In other words, the function will have a name (that lets `R` know what you're trying to do) followed by an open parenthesis, and inside that a list of arguments, which are variables, objects, values, etc that you "pass" to the function, finally followed by a close parenthesis.  In the case of our `sqrt()` function, there is only a single argument: a variable to which the square-root operation will be applied.  In the case of the `rnorm()` function there are 3 arguments: the number of values we want, `n`, and the `mean` and standard deviation `sd` of the normal distribution we wish to sample from.

Functions are the `R` tools for which you can make the most use of the help operator: `?`.  Try typing `?rnorm` into your console, and when you hit `return` you'll see the help page for the function.

Notice that in the `rnorm()` example we *named* the arguments--we told `R` which was the `n`, `mean`, and `sd`.  This is because if we name arguments, we can give them in any order.  Otherwise, `R` will try to match the provided values to the arguments **in the order in which they are given in the help file**.  This is a major source of errors for newer `R` users!


```r
# This will give us 1 value from the normal distribution with mean = 0 and sd = 100
rnorm(1, 0, 100)
```

```
## [1] 87.75298
```

```r
# But we can also use named arguments to provide them in any order we wish!
rnorm(sd = 1, n = 100, mean = 0)
```

```
##   [1] -0.8269308999 -0.8047660168  0.1686005173 -0.8421607616  0.1331253254
##   [6]  0.0050991364 -1.0177158110 -0.2966759054  0.3064235259  0.5792753052
##  [11]  0.5526052378 -1.4259188919  0.1118249555 -1.5314923773  0.4409071803
##  [16] -0.0626855572 -0.9466201095 -0.5443097980  0.9798542771 -0.4797551490
##  [21] -0.2578884954  1.2929740593 -0.5186002364 -2.4238664044  0.9241549983
##  [26] -0.6685919684 -0.3050214757  0.0493426521 -0.9484598338 -0.1464115279
##  [31] -1.1380297769  0.6556073676 -1.3131251968 -0.8617715140 -1.4725571409
##  [36] -0.3505562684 -0.0731572532 -1.7304670038 -1.1578081293 -1.7487255723
##  [41] -0.1402461936  0.9801960030  0.9813258909  0.0237587942 -1.4038050803
##  [46] -0.6148958405  0.2987850027  0.0004008438 -1.6580741308  0.3819960376
##  [51]  0.3388729550 -0.6515914119  2.0167458602 -0.0556741321  0.2054710761
##  [56]  0.7025629210 -0.8769743044  1.4826125131  0.0828522437  0.7621720364
##  [61]  1.1027720221 -0.6412934746 -0.3960426235 -1.7726265074 -0.5141865003
##  [66]  1.2173423198 -0.0365198102  1.0281748825  1.6127779975 -0.9167061862
##  [71]  0.8364365716  1.0047756682  0.3155779860 -1.1859904243  0.4975187251
##  [76] -1.2754659217 -0.0823367198 -0.2966888681  0.7885800955 -1.7269445694
##  [81] -0.0103362349  1.0010691217  0.1763109242 -0.1865399414 -0.8341769822
##  [86] -1.7628719651  0.2277525417 -1.7053271112 -0.0190101993  0.3985744819
##  [91] -0.3783263201 -0.6131862654  1.1212849661  1.0228065449 -2.2964497007
##  [96] -1.9279338882  0.7932239361 -0.0319025589  0.5254378450 -0.8982829927
```

Programming languages like `R` are very literal, and we need to be as literal as we can to make them work the way we want them to.

## Reading data into `R`

So far we've only done very basic things with `R`, which probably haven't sold you on its power and utility.  Let's try doing some things that will hopefully get us a little further towards actual, useful applications.  

First off, make sure you have the `tidyverse` package loaded by using the `library()` function.


```r
library(tidyverse)
```

Now, we're going to read in the data we're going to use for this workshop using the function `read_csv()`.  If you want to learn about this function, use the `?read_csv` command to get some details.

In the workshop archive you downloaded, the `data/` directory has a file called `ba_2002.csv`.  If you double-click this in your file browser, it will (most likely) open in Excel, and you can take a look at it.  It is 20,000 reviews of beer, posted in the year 2002.  This is an edited (not original) and very delimited version of the dataset (which had >1 million reviews), as the original one has been removed from the web at the original website owner's request.  It will be the training dataset we use for today.

To get this data into `R`, we have to tell `R` where it lives on your computer, and what kind of data it is.

### Where the data lives

We touched on **working directories** because this is how `R` "sees" your computer.  It will look first in the working directory, and then you will have to tell it where the file is *relative* to that directory.  If you have been following along and opened up the `.Rproj` file in the downloaded archive, your working directory should be the archive's top level, which will mean that we only need to point `R` towards the `data/` folder and then the `ba_2002.csv` file.  We can check the working directory with the `getwd()` function.


```r
getwd()
```

```
## [1] "/Users/jake/Dropbox/Work/Documents/Conferences/Eurosense 2022/Sensometrics Tutorial/eurosense-tutorial-2022"
```

Therefore, **relative to the working directory**, the file path to this data is `data/ba_2002.csv`.  Please note that this is the UNIX convention for file paths: in Windows, the backslash `\` is used to separate directories.  Happily, RStudio will translate between the two conventions, so you can just follow along with the macOS/UNIX convention in this workshop.

### What kind of file are we importing?

The first step is to notice this is a `.csv` file, which stands for **c**omma-**s**eparated **v**alue.  This means our data, in raw format, looks something like this:

```
# Comma-separated data

cat_acquisition_order,name,weight\n
1,Nick,9\n
2,Margot,10\n
3,Little Guy,13\n
```

Each line represents a row of data, and each field is separated by a comma (`,`).  We can read this kind of data into `R` by using the `read_csv()` function.


```r
read_csv(file = "data/ba_2002.csv")
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

```
## # A tibble: 20,359 × 14
##    reviews     beer_…¹ beer_id brewe…² brewe…³ style   abv user_id appea…⁴ aroma
##    <chr>       <chr>     <dbl> <chr>     <dbl> <chr> <dbl> <chr>     <dbl> <dbl>
##  1 This is a … Caffre…     825 Thomas…     297 Iris…   3.8 jisurf…     5     4  
##  2 Great head… Caffre…     825 Thomas…     297 Iris…   3.8 allbou…     5     3.5
##  3 Wow what a… Caffre…     825 Thomas…     297 Iris…   3.8 frank4…     4     3  
##  4 Tried this… Caffre…     825 Thomas…     297 Iris…   3.8 beergl…     3.5   3.5
##  5 Caffrey's … Caffre…     825 Thomas…     297 Iris…   3.8 proc.1…     4     3  
##  6 The nitro … Caffre…     825 Thomas…     297 Iris…   3.8 zerk.4…     4     3  
##  7 Nitro can.… Caffre…     825 Thomas…     297 Iris…   3.8 adr.263     3.5   3.5
##  8 Excellent … Caffre…     825 Thomas…     297 Iris…   3.8 dogbri…     4     3  
##  9 A very goo… Caffre…     825 Thomas…     297 Iris…   3.8 goindo…     4     4  
## 10 Looks very… Caffre…     825 Thomas…     297 Iris…   3.8 irishr…     4     3  
## # … with 20,349 more rows, 4 more variables: palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>, and abbreviated variable names ¹​beer_name,
## #   ²​brewery_name, ³​brewery_id, ⁴​appearance
## # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
```

Suddenly, we have tabular data (i.e., data in rows and columns), like we'd have in Excel!  Now we're getting somewhere.  However, before we go forward we'll have to store this data somewhere--right now we're just reading it and throwing it away.


```r
beer_data <- read_csv(file = "data/ba_2002.csv")
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

As a note, in many countries the separator (delimiter) will be the semi-colon (`;`), since the comma is used as the decimal marker.  To read files formatted this way, you can use the `read_csv2()` function.  If you encounter tab-separated values files (`.tsv`) you can use the `read_tsv()` function.  If you have more non-standard delimiters, you can use the `read_delim()` function, which will allow you to specify your own delimiter characters.  You can also read many other formats of tabular data using the `rio` package ("read input/output"), which can be installed from CRAN.

## Data in `R`

Let's take a look at the `Environment` tab.  Among some other objects you may have created (like `x`), you should see `beer_data` listed.  This is a type of data called a `data.frame` in `R`, and it is going to be, for the most part, the kind of data you interact with most.  Let's learn about how these types of objects work by doing a quick review of the basics.

We started by creating an object called `x` and storing a number (`100`) into it.  What kind of thing is this?


```r
x <- 100
class(x)
```

```
## [1] "numeric"
```

```r
typeof(x)
```

```
## [1] "double"
```

`R` has a bunch of basic data types, including the above "numeric" data type, which is a "real number" (in computer terms, a floating-point double as opposed to an integer).  It can also store logical values (`TRUE` and `FALSE`), integers, characters/strings (which are what we're really here to deal with) and some more exotic data types you won't encounter very much.  What `R` does that makes it good for data analysis is that it stores these all as **vectors**: 1-dimensional arrays of the same type of data.  So, in fact, `x` is a length-1 vector of numeric data:


```r
length(x)
```

```
## [1] 1
```

The operator to explicitly make a vector in `R` is the `c()` function, which stands for "combine".  So if we want to make a vector of a few values, we use this function as so:


```r
y <- c(1, 2, 3, 10, 50)
y
```

```
## [1]  1  2  3 10 50
```

We can also use `c()` to combine pre-existing objects:


```r
c(x, y)
```

```
## [1] 100   1   2   3  10  50
```

You can have vectors of other types of objects:


```r
animals <- c("fox", "bat", "rat", "cat")
class(animals)
```

```
## [1] "character"
```

If we try to combine vectors of 2 types of data, `R` will "coerce" the data types to match to the less restrictive type, in the following order: `logical > integer > numeric > character`.  So if we combine `y` and `animals`, we'll turn the numbers into their character representations.  I mention this because it can be a source of error and confusion when we are working with large datasets, as we may see.


```r
c(y, animals)
```

```
## [1] "1"   "2"   "3"   "10"  "50"  "fox" "bat" "rat" "cat"
```

For example, we can divide all the numbers in `y` by `2`, but if we try to divide `c(y, animals)` by `2` we will get an error:


```r
c(y, animals) / 2
```

```
## Error in c(y, animals)/2: non-numeric argument to binary operator
```


For vectors (and more complex objects), we can use the `str()` ("structure") function to get some details about their nature and what they contain:


```r
str(y)
```

```
##  num [1:5] 1 2 3 10 50
```

```r
str(animals)
```

```
##  chr [1:4] "fox" "bat" "rat" "cat"
```

This `str()` function is especially useful when we have big, complicated datasets, like `beer_data`:


```r
str(beer_data)
```

```
## spec_tbl_df [20,359 × 14] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ reviews     : chr [1:20359] "This is a very good Irish ale. I'm not sure if it would be considered a cream ale, but it's very creamy in colo"| __truncated__ "Great head creation and retention from the Nitro can. A pinky finger width head stuck with the beer all the way"| __truncated__ "Wow what a different brew in England. I still am not a huge fan but the brew is improved on tap and fresh. It t"| __truncated__ "Tried this one in a steak house. Pours a light reddish colour topped by a thick white head that settles rather "| __truncated__ ...
##  $ beer_name   : chr [1:20359] "Caffrey's Irish Ale" "Caffrey's Irish Ale" "Caffrey's Irish Ale" "Caffrey's Irish Ale" ...
##  $ beer_id     : num [1:20359] 825 825 825 825 825 825 825 825 825 825 ...
##  $ brewery_name: chr [1:20359] "Thomas Caffrey Brewing Co." "Thomas Caffrey Brewing Co." "Thomas Caffrey Brewing Co." "Thomas Caffrey Brewing Co." ...
##  $ brewery_id  : num [1:20359] 297 297 297 297 297 297 297 297 297 297 ...
##  $ style       : chr [1:20359] "Irish Red Ale" "Irish Red Ale" "Irish Red Ale" "Irish Red Ale" ...
##  $ abv         : num [1:20359] 3.8 3.8 3.8 3.8 3.8 3.8 3.8 3.8 3.8 3.8 ...
##  $ user_id     : chr [1:20359] "jisurfer.1152" "allboutbierge.746" "frank4sail.48" "beerglassescollector.1006" ...
##  $ appearance  : num [1:20359] 5 5 4 3.5 4 4 3.5 4 4 4 ...
##  $ aroma       : num [1:20359] 4 3.5 3 3.5 3 3 3.5 3 4 3 ...
##  $ palate      : num [1:20359] 4 4 3 3.5 4 2.5 4 3 4 3.5 ...
##  $ taste       : num [1:20359] 4.5 3.5 3.5 3.5 4.5 3 3.5 3 4 3 ...
##  $ overall     : num [1:20359] 5 4 3 3.5 3.5 3.5 3.5 3 4 3.5 ...
##  $ rating      : num [1:20359] 4.46 3.74 3.26 3.5 3.86 3.11 3.55 3.06 4 3.21 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   reviews = col_character(),
##   ..   beer_name = col_character(),
##   ..   beer_id = col_double(),
##   ..   brewery_name = col_character(),
##   ..   brewery_id = col_double(),
##   ..   style = col_character(),
##   ..   abv = col_double(),
##   ..   user_id = col_character(),
##   ..   appearance = col_double(),
##   ..   aroma = col_double(),
##   ..   palate = col_double(),
##   ..   taste = col_double(),
##   ..   overall = col_double(),
##   ..   rating = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```

### Subsetting data

Vectors, by nature, are ordered arrays of data (in this case, 1-dimensional arrays).  That means they have a first element, a second element, and so on.  Our `y` vector has 5 total elements, and our `animals` vector has 4 elements.  In `R`, the way to **subset** vectors is to use the `[]` (square brackets) operator.  For a 1-dimensional vector, we use this to select one or more elements:


```r
y[1]
```

```
## [1] 1
```

```r
animals[4]
```

```
## [1] "cat"
```

We can also select multiple elements by using a vector of indices


```r
animals[c(1, 2)]
```

```
## [1] "fox" "bat"
```

A shortcut for a sequence of numbers in `R` is the `:` (colon) operator, so this is often used for indexing:


```r
1:3
```

```
## [1] 1 2 3
```

```r
animals[1:3]
```

```
## [1] "fox" "bat" "rat"
```

We often want to use programmatic (or "conditional") logic to subset vectors and more complex datasets.  For example, we might want to only select elements of `y` that are less than `10`.  To do that, we can use one of `R`'s conditional logic operators: `<`, `>`, `<=`, `>=`, `==`, or `!=`.  These, in order, stand for "less than, "greater than,", "less than or equal to," "greater than or equal to," "equal to," and "not equal to."


```r
y < 10
```

```
## [1]  TRUE  TRUE  TRUE FALSE FALSE
```

We can then use this same set of logical values to select only the elements of `y` for which the condition is `TRUE`:


```r
y[y < 10]
```

```
## [1] 1 2 3
```

This is useful if we have a long vector (frequently) and do not want to list or are not able to list all of the actual indices that we want to select.

### Complex vectors/lists: `data.frame` and `tibble`

Now that we have the basics of vectors, we can move on to the complex data object we're really interested in: `beer_data`.  This is a type of object called a `tibble`, which is a cute/fancy version of the more basic `R` object called a `data.frame`.  These are `R`'s version of the `.csv` file or your typical Excel file: a rectangular matrix of data, with (usually) columns representing some variable and rows representing some kind of observation.  Each row will have a value in each column or will be `NA`, which is `R`'s specific value to represent **missing data**.

In a `data.frame`, every column has to have only a single data type: a column might be `logical` or `integer` or `character`, but it cannot be a mix.  However, each column can be a different type.  For example, the first column in our `beer_data`, called `reviews`, is a `character` vector, but the third column, `beer_id`, is a `numeric` column.  

We have now moved from 1-dimensional vectors to 2-dimensional data tables, which means we're going to have some new properties to investigate.  First off, we might want to know how many rows and columns our data table has:


```r
nrow(beer_data)
```

```
## [1] 20359
```

```r
ncol(beer_data)
```

```
## [1] 14
```

```r
length(beer_data) # Note that length() of a data.frame is the same as ncol()
```

```
## [1] 14
```

We already tried running `str(beer_data)`, which gives us the data types of each column and an example.  Some other ways to examine the data include the following:


```r
beer_data # simply printing the object
head(beer_data) # show the first few rows
tail(beer_data) # show the last few rows
glimpse(beer_data) # a more compact version of str()
names(beer_data) # get the variable/column names
```

Note that some of these functions (for example, `glimpse()`) come from the `tidyverse` package, so if you are having trouble running a command, first make sure you have run `library(tidyverse)`.

## Subsetting and wrangling data tables

Since we now have 2 dimensions, our old strategy of using a single number to select a value from a vector won't work!  But the `[]` operator still works on data frames and tibbles.  We just have to specify coordinates, as `[<row>, <column>]`.  


```r
beer_data[5, 1] # get the 5th row, 1st column value
```

```
## # A tibble: 1 × 1
##   reviews                                                                       
##   <chr>                                                                         
## 1 Caffrey's on-tap is less creamy than the nitro can, but seems to be more subs…
```

We can continue to use ranges or vectors of indices to select larger parts of the table


```r
beer_data[1:5, 1] # get the first 5 rows of the 1st column value
```

```
## # A tibble: 5 × 1
##   reviews                                                                       
##   <chr>                                                                         
## 1 This is a very good Irish ale. I'm not sure if it would be considered a cream…
## 2 Great head creation and retention from the Nitro can. A pinky finger width he…
## 3 Wow what a different brew in England. I still am not a huge fan but the brew …
## 4 Tried this one in a steak house. Pours a light reddish colour topped by a thi…
## 5 Caffrey's on-tap is less creamy than the nitro can, but seems to be more subs…
```

If we only want to subset on a specific dimension and get everything from the other dimension, we just leave it blank.


```r
beer_data[, 2] # get all rows of the 2nd column
```

```
## # A tibble: 20,359 × 1
##    beer_name          
##    <chr>              
##  1 Caffrey's Irish Ale
##  2 Caffrey's Irish Ale
##  3 Caffrey's Irish Ale
##  4 Caffrey's Irish Ale
##  5 Caffrey's Irish Ale
##  6 Caffrey's Irish Ale
##  7 Caffrey's Irish Ale
##  8 Caffrey's Irish Ale
##  9 Caffrey's Irish Ale
## 10 Caffrey's Irish Ale
## # … with 20,349 more rows
## # ℹ Use `print(n = ...)` to see more rows
```

We can also use logical subsetting, just like in vectors.  This is very powerful but a bit complicated, so we are going to introduce some `tidyverse` based operators to do this that will make it a lot easier.  I will just give an example:


```r
beer_data[beer_data$rating > 4.5, ] # get all rows for which rating > 3
```

```
## # A tibble: 1,952 × 14
##    reviews     beer_…¹ beer_id brewe…² brewe…³ style   abv user_id appea…⁴ aroma
##    <chr>       <chr>     <dbl> <chr>     <dbl> <chr> <dbl> <chr>     <dbl> <dbl>
##  1 I must agr… Old En…     875 Harvie…     323 Engl…   6   viking…     4     4.5
##  2 I had this… Schieh…    6438 Harvie…     323 Euro…   4.8 thelon…     4.5   4.5
##  3 Haven't fo… Deucha…    2389 The Ca…     188 Engl…   4.4 freed.…     4.5   5  
##  4 Once again… Deucha…    2389 The Ca…     188 Engl…   4.4 mark.65     3     4.5
##  5 Hazy (bott… Edinbu…    6466 The Ca…     188 Scot…   6.4 nerofi…     4     4  
##  6 The first … McEwan…     911 The Ca…     188 Engl…   4.7 jdhilt…     5     5  
##  7 The brew p… McEwan…    1275 The Ca…     188 Scot…   8   murph.…     4     4.5
##  8 Deep dark … McEwan…    1275 The Ca…     188 Scot…   8   zap.184     4     4.5
##  9 Clear deep… Traqua…      36 Traqua…      24 Scot…   7.2 bighug…     4.5   4.5
## 10 Reddish br… Traqua…      36 Traqua…      24 Scot…   7.2 mjohn2…     5     4.5
## # … with 1,942 more rows, 4 more variables: palate <dbl>, taste <dbl>,
## #   overall <dbl>, rating <dbl>, and abbreviated variable names ¹​beer_name,
## #   ²​brewery_name, ³​brewery_id, ⁴​appearance
## # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
```

In this last example I also introduced the final bit of `tibble` and `data.frame` wrangling we will cover here: the `$` operator.  This is the operator to select a single column from a `data.frame` or `tibble`.  It gives you back the vector that makes up that column:


```r
beer_data$style # not printed because it is too long!
```

One of the nice things about RStudio is that it provides tab-completion for `$`.  Go to the console, type "bee" and hit `tab`.  You'll see a list of possible matches, with `beer_data` at the top.  Hit enter, and this will fill out the typing for you!  Now, type "$" and hit `tab` again.  You'll see a list of the columns in `beer_data`!  This can save a huge amount of typing and memorizing the names of variables and objects.

Now that we've gone over the basics of creating and manipulating objects in `R`, we're going to run through the basics of data manipulation and visualization with the `tidyverse`.  Before we move on to that topic, let's address **any questions**.

## PSA: not-knowing is normal!

Above, I mentioned "help files". How do we get help when we (inevitably) run into problems in R? There are a couple steps you will find helpful in the future:

1.  Look up the help file for whatever you're doing. Do this by using the syntax `?<search item>` (for example `?c` gets help on the vector command) as a shortcut on the console.
2.  Search the help files for a term you think is related. Can't remember the command for making a sequence of integers? Go to the "Help" pane in RStudio and search in the search box for "sequence". See if some of the top results get you what you need.
3.  The internet. Seriously. I am not kidding even a little bit. R has one of the most active and (surprisingly) helpful user communities I've ever encountered. Try going to google and searching for "How do I make a sequence of numbers in R?" You will find quite a bit of useful help. I find the following sites particularly helpful
    1.  [Stack Overflow](https://stackoverflow.com/questions/tagged/r)
    2.  [Cross Validated/Stack Exchange](https://stats.stackexchange.com/questions/tagged/r)
    3.  Seriously, [Google will get you most of the way to helpful answers](https://is.gd/80V5zF) for many basic R questions.


We may come back to this, but I want to emphasize that **looking up help is normal**. I do it all the time. Learning to ask questions in helpful ways, how to quickly parse the information you find, and how to slightly alter the answers to suit your particular situation are key skills.


  
