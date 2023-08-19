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
##   [1]  0.3127088404  0.7811740067 -0.0215795288  1.0235217924 -0.7251987669
##   [6]  0.3727787092  1.8036557121 -0.0178840161  0.9959159908  0.6009265661
##  [11] -0.8688703459  1.3245708592  1.5943777323 -0.8717920674  0.4635823800
##  [16] -0.4508236879 -0.7577804727  0.6180873500  0.9591681449  0.1085341079
##  [21] -0.5628465428  0.9923773209 -0.8125048557 -1.9232796791 -0.5010334053
##  [26] -0.7742001146 -0.0970364010 -1.2308403095  1.5217743317  2.1809419251
##  [31]  0.0602903677 -0.5075360006  0.3387776652  0.6847487314  0.5489826537
##  [36]  1.1707115058  0.7944680476 -0.4693476850 -0.4319151415  1.6035968920
##  [41]  0.4070418717 -0.5357572540  0.2719328442  0.0008122861  0.7409776357
##  [46] -0.8331587604 -0.1526313947 -0.5167037484 -1.0929257235  0.3170995516
##  [51]  0.8632677583 -0.2506240280  0.0385318543  0.2838225075  0.0499514203
##  [56] -0.0946479888 -0.3059885609 -0.7328641563  0.6611459605  1.0402169375
##  [61]  0.9267740581  1.1449916307 -0.5905126178 -0.8354054905 -0.9222455707
##  [66]  0.0119571348  1.1452873421  0.3166335507  0.0209763772 -1.2252522254
##  [71] -1.7036696849  1.5377006653 -0.5053489443 -1.0450196747  0.0198555816
##  [76]  0.4638127307 -0.0663671849  0.3539525869 -0.5772909553  0.3607914730
##  [81]  1.5871903080 -0.1266737033  0.5548421744 -1.5813153725  0.6244765434
##  [86] -0.4747060467  0.0531680539  0.0663849219 -0.1492569069  0.6111938410
##  [91]  0.4590638118  2.1055792242  0.0835077185 -1.8789901791 -0.7159629742
##  [96]  1.1392029786  0.2485645496  0.4365126039  0.2855317261 -0.9579557834
```

These forms are called a **function** in R.  Functions lie at the heart of `R`'s power: they are pre-written scripts that are included with base `R` or added in packages, like the ones we installed.  In general, an `R` function will have a form like `<name>(<argument>, <argument>, ...)`.  In other words, the function will have a name (that lets `R` know what you're trying to do) followed by an open parenthesis, and inside that a list of arguments, which are variables, objects, values, etc that you "pass" to the function, finally followed by a close parenthesis.  In the case of our `sqrt()` function, there is only a single argument: a variable to which the square-root operation will be applied.  In the case of the `rnorm()` function there are 3 arguments: the number of values we want, `n`, and the `mean` and standard deviation `sd` of the normal distribution we wish to sample from.

Functions are the `R` tools for which you can make the most use of the help operator: `?`.  Try typing `?rnorm` into your console, and when you hit `return` you'll see the help page for the function.

Notice that in the `rnorm()` example we *named* the arguments--we told `R` which was the `n`, `mean`, and `sd`.  This is because if we name arguments, we can give them in any order.  Otherwise, `R` will try to match the provided values to the arguments **in the order in which they are given in the help file**.  This is a major source of errors for newer `R` users!


```r
# This will give us 1 value from the normal distribution with mean = 0 and sd = 100
rnorm(1, 0, 100)
```

```
## [1] 27.46005
```

```r
# But we can also use named arguments to provide them in any order we wish!
rnorm(sd = 1, n = 100, mean = 0)
```

```
##   [1]  0.846774745  1.000191578 -0.145750723  1.566699892  1.753139051
##   [6] -0.115245345  0.321254828  0.000450397  0.740293204  0.181187066
##  [11] -0.887583241 -0.618598590 -0.330435879 -2.417908767 -0.072796750
##  [16]  0.532909880  0.456909453  0.473676409  1.997337995 -2.005915574
##  [21]  0.841572722  1.135965809 -0.131080007 -1.178496947  2.149888857
##  [26] -0.350743758 -1.077018392  0.631203417 -2.862627387 -1.368542826
##  [31] -1.111228779  1.156583220 -1.269423061 -1.158976889 -0.471091408
##  [36]  1.762110724  0.404541511  2.040268190  1.597849153  1.775415738
##  [41] -1.700472927 -0.193710062  0.476411479 -0.841765728 -0.190948680
##  [46]  1.040547336  0.412257056 -0.680708660  0.523015149 -2.103943339
##  [51]  0.779978705 -0.760464170 -0.740882618  0.999925500 -1.380059203
##  [56] -0.473940949  1.826746300  1.553454122 -0.744743699  0.250054291
##  [61] -1.663891798 -1.279729088  0.025808513 -0.078183147  1.359307795
##  [66]  0.899439097 -0.363354954  0.608445014  0.692863220  0.139534597
##  [71]  0.093151850 -0.432444071  0.221886011 -0.673139279  2.066764307
##  [76]  1.245291063 -0.654288364 -0.643006370 -0.282278725 -0.625371213
##  [81] -1.113960818  2.596223612 -1.307314828  0.289711362 -1.828386767
##  [86] -2.098665031 -0.397126873  0.780363125 -0.201391022 -1.447829968
##  [91]  1.016883364  0.704308656 -0.534276737  0.077979801  0.391692282
##  [96] -0.881415459 -0.400030573  0.049131806  1.722677999 -0.320569208
```

Programming languages like `R` are very literal, and we need to be as literal as we can to make them work the way we want them to.

## Reading data into `R`

So far we've only done very basic things with `R`, which probably haven't sold you on its power and utility.  Let's try doing some things that will hopefully get us a little further towards actual, useful applications.  

First off, make sure you have the `tidyverse` package loaded by using the `library()` function.


```r
library(tidyverse)
```

Now, we're going to read in the data we're going to use for this workshop using the function `read_csv()`.  If you want to learn about this function, use the `?read_csv` command to get some details.

In the workshop archive you downloaded, the `data/` directory has a file called `clt-berry-data.csv`.  If you double-click this in your file browser, it will (most likely) open in Excel, and you can take a look at it.  The data describe the attributes and liking scores reported by consumers for a variety of berries across multiple CLTs. A total of 969 participants (`Subject Code`) and 23 berries (`Sample Name`) were involved in these tests, with only one species of berry (blackberry, blueberry, raspberry, or strawberry) presented during each CLT.  In the actual experimental design, subjects got multiple sample sets (so there are *not* 969 unique subjects), but here we will treat them as unique for ease of description.

As for the survey, panelists were asked JAR, CATA, and free response questions, as well as liking on the Unlabeled Line Scale (`us_*`), 9-point scale (`9pt_*`), or labeled magnitude scale (`lms_*`).

To get this data into `R`, we have to tell `R` where it lives on your computer, and what kind of data it is.

### Where the data lives

We touched on **working directories** because this is how `R` "sees" your computer.  It will look first in the working directory, and then you will have to tell it where the file is *relative* to that directory.  If you have been following along and opened up the `.Rproj` file in the downloaded archive, your working directory should be the archive's top level, which will mean that we only need to point `R` towards the `data/` folder and then the `clt-berry-data.csv` file.  We can check the working directory with the `getwd()` function.


```r
getwd()
```

```
## [1] "C:/Users/Leah/Documents/R/pangborn-r-tutorial-2023"
```

Therefore, **relative to the working directory**, the file path to this data is `data/clt-berry-data.csv`.  Please note that this is the UNIX convention for file paths: in Windows, the backslash `\` is used to separate directories.  Happily, RStudio will translate between the two conventions, so you can just follow along with the macOS/UNIX convention in this workshop.

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
read_csv(file = "data/clt-berry-data.csv")
```

```
## Rows: 7507 Columns: 92
## -- Column specification --------------------------------------------------------
## Delimiter: ","
## chr  (7): Start Time (UTC), End Time (UTC), Sample Name, verbal_likes, verba...
## dbl (83): Subject Code, Participant Name, Serving Position, Sample Identifie...
## lgl  (2): Gender, Age
## 
## i Use `spec()` to retrieve the full column specification for this data.
## i Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```
## # A tibble: 7,507 x 92
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
## # i 7,497 more rows
## # i 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, ...
```

Suddenly, we have tabular data (i.e., data in rows and columns), like we'd have in Excel!  Now we're getting somewhere.  However, before we go forward we'll have to store this data somewhere--right now we're just reading it and throwing it away.


```r
berry_data <- read_csv(file = "data/clt-berry-data.csv")
```

```
## Rows: 7507 Columns: 92
## -- Column specification --------------------------------------------------------
## Delimiter: ","
## chr  (7): Start Time (UTC), End Time (UTC), Sample Name, verbal_likes, verba...
## dbl (83): Subject Code, Participant Name, Serving Position, Sample Identifie...
## lgl  (2): Gender, Age
## 
## i Use `spec()` to retrieve the full column specification for this data.
## i Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

As a note, in many countries the separator (delimiter) will be the semi-colon (`;`), since the comma is used as the decimal marker.  To read files formatted this way, you can use the `read_csv2()` function.  If you encounter tab-separated values files (`.tsv`) you can use the `read_tsv()` function.  If you have more non-standard delimiters, you can use the `read_delim()` function, which will allow you to specify your own delimiter characters.  You can also read many other formats of tabular data using the `rio` package ("read input/output"), which can be installed from CRAN (using, as you have learned, `install.packages("rio")`).

## Data in `R`

Let's take a look at the `Environment` tab.  Among some other objects you may have created (like `x`), you should see `berry_data` listed.  This is a type of data called a `data.frame` in `R`, and it is going to be, for the most part, the kind of data you interact with most.  Let's learn about how these types of objects work by doing a quick review of the basics.

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

This `str()` function is especially useful when we have big, complicated datasets, like `berry_data`:


```r
str(berry_data)
```

```
## spc_tbl_ [7,507 x 92] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Subject Code               : num [1:7507] 1001 1001 1001 1001 1001 ...
##  $ Participant Name           : num [1:7507] 1001 1001 1001 1001 1001 ...
##  $ Gender                     : logi [1:7507] NA NA NA NA NA NA ...
##  $ Age                        : logi [1:7507] NA NA NA NA NA NA ...
##  $ Start Time (UTC)           : chr [1:7507] "6/13/2019 21:05" "6/13/2019 20:55" "6/13/2019 20:49" "6/13/2019 20:45" ...
##  $ End Time (UTC)             : chr [1:7507] "6/13/2019 21:09" "6/13/2019 20:59" "6/13/2019 20:53" "6/13/2019 20:48" ...
##  $ Serving Position           : num [1:7507] 5 3 2 1 4 6 3 1 4 2 ...
##  $ Sample Identifier          : num [1:7507] 1426 3167 4624 5068 7195 ...
##  $ Sample Name                : chr [1:7507] "raspberry 6" "raspberry 5" "raspberry 2" "raspberry 3" ...
##  $ 9pt_appearance             : num [1:7507] 4 8 4 7 7 7 6 8 8 7 ...
##  $ pre_expectation            : num [1:7507] 2 4 2 4 3 4 2 3 5 3 ...
##  $ jar_color                  : num [1:7507] 2 3 2 2 4 4 2 3 3 2 ...
##  $ jar_gloss                  : num [1:7507] 4 3 2 3 3 3 4 3 4 4 ...
##  $ jar_size                   : num [1:7507] 2 3 3 4 3 3 4 3 5 3 ...
##  $ cata_appearance_unevencolor: num [1:7507] 0 0 0 0 1 0 0 1 1 1 ...
##  $ cata_appearance_misshapen  : num [1:7507] 1 0 0 0 1 0 0 0 0 0 ...
##  $ cata_appearance_creased    : num [1:7507] 0 0 0 0 0 0 0 0 1 1 ...
##  $ cata_appearance_seedy      : num [1:7507] 0 0 0 0 0 0 0 0 0 0 ...
##  $ cata_appearance_bruised    : num [1:7507] 0 0 0 0 0 0 0 0 1 1 ...
##  $ cata_appearance_notfresh   : num [1:7507] 1 0 1 0 0 0 0 0 0 0 ...
##  $ cata_appearance_fresh      : num [1:7507] 0 1 0 1 0 1 1 1 1 1 ...
##  $ cata_appearance_goodshape  : num [1:7507] 0 1 0 1 0 1 1 1 0 0 ...
##  $ cata_appearance_goodquality: num [1:7507] 0 1 0 1 0 1 1 1 1 0 ...
##  $ cata_appearance_none       : num [1:7507] 0 0 0 0 0 0 0 0 0 0 ...
##  $ 9pt_overall                : num [1:7507] 4 9 3 7 4 4 4 7 7 9 ...
##  $ verbal_likes               : chr [1:7507] "Out of the two, there was one that had a good sweetness to it" "It was firm to the touch but was very delicate when you bit on it. There was an even amount of tart and sweetne"| __truncated__ "It was firm to the touch" "It had a naturally sweet flavor both from the start and the finish" ...
##  $ verbal_dislikes            : chr [1:7507] "There were different flavors coming from each and different sizes. The first was a smaller than normal one and "| __truncated__ "They seemed bigger in size than normal raspberries" "It did not have the fresh flavor of a normal raspberry. Instead, it felt like there were other ingredients adde"| __truncated__ "It felt too delicate from the touch" ...
##  $ 9pt_taste                  : num [1:7507] 4 9 3 6 3 3 4 4 6 9 ...
##  $ grid_sweetness             : num [1:7507] 3 6 3 6 2 3 3 2 2 6 ...
##  $ grid_tartness              : num [1:7507] 6 5 5 3 5 6 5 5 5 2 ...
##  $ grid_raspberryflavor       : num [1:7507] 4 7 2 6 2 3 2 6 2 7 ...
##  $ jar_sweetness              : num [1:7507] 2 3 2 3 2 1 1 1 1 3 ...
##  $ jar_tartness               : num [1:7507] 4 3 3 3 4 5 4 4 4 3 ...
##  $ cata_taste_floral          : num [1:7507] 0 0 0 1 0 0 0 1 1 1 ...
##  $ cata_taste_berry           : num [1:7507] 1 1 0 1 0 0 0 1 0 1 ...
##  $ cata_taste_green           : num [1:7507] 0 0 0 1 1 1 0 0 1 0 ...
##  $ cata_taste_grassy          : num [1:7507] 0 0 0 0 1 1 1 0 1 0 ...
##  $ cata_taste_fermented       : num [1:7507] 0 0 1 0 0 0 0 0 0 0 ...
##  $ cata_taste_tropical        : num [1:7507] 1 1 0 0 0 0 0 0 0 1 ...
##  $ cata_taste_fruity          : num [1:7507] 1 1 0 1 0 0 0 0 0 1 ...
##  $ cata_taste_citrus          : num [1:7507] 1 0 0 0 0 1 1 0 0 0 ...
##  $ cata_taste_earthy          : num [1:7507] 0 0 0 0 1 0 0 1 0 0 ...
##  $ cata_taste_candy           : num [1:7507] 0 0 1 0 0 0 0 0 0 0 ...
##  $ cata_taste_none            : num [1:7507] 0 0 0 0 0 0 0 0 0 0 ...
##  $ 9pt_texture                : num [1:7507] 6 8 2 8 5 6 6 9 8 7 ...
##  $ grid_seediness             : num [1:7507] 3 5 6 3 5 5 6 4 6 5 ...
##  $ grid_firmness              : num [1:7507] 5 5 5 2 6 5 5 6 5 3 ...
##  $ grid_juiciness             : num [1:7507] 2 5 2 2 2 4 2 4 2 3 ...
##  $ jar_firmness               : num [1:7507] 3 3 4 2 4 3 3 3 3 2 ...
##  $ jar_juciness               : num [1:7507] 2 3 1 2 2 2 1 2 1 3 ...
##  $ post_expectation           : num [1:7507] 1 5 2 4 2 2 2 2 2 5 ...
##  $ price                      : num [1:7507] 1.99 4.99 2.99 4.99 2.99 3.99 3.99 3.99 2.99 4.99 ...
##  $ product_tier               : num [1:7507] 1 3 2 3 1 2 2 2 1 3 ...
##  $ purchase_intent            : num [1:7507] 1 5 2 4 2 2 3 4 2 5 ...
##  $ subject                    : num [1:7507] 1031946 1031946 1031946 1031946 1031946 ...
##  $ test_day                   : chr [1:7507] "Raspberry Day 1" "Raspberry Day 1" "Raspberry Day 1" "Raspberry Day 1" ...
##  $ us_appearance              : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ us_overall                 : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ us_taste                   : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ us_texture                 : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ lms_appearance             : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ lms_overall                : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ lms_taste                  : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ lms_texture                : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_appearane_bruised     : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_appearance_goodshapre : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_appearance_goodcolor  : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ grid_blackberryflavor      : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_cinnamon        : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_lemon           : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_clove           : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_minty           : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_grape           : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ grid_crispness             : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ jar_crispness              : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ jar_juiciness              : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_appearane_creased     : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ grid_blueberryflavor       : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_piney           : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_peachy          : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ 9pt_aroma                  : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ grid_strawberryflavor      : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_caramel         : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_grapey          : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_melon           : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ cata_taste_cherry          : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ grid_crunchiness           : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ jar_crunch                 : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ us_aroma                   : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ lms_aroma                  : num [1:7507] NA NA NA NA NA NA NA NA NA NA ...
##  $ berry                      : chr [1:7507] "raspberry" "raspberry" "raspberry" "raspberry" ...
##  $ sample                     : num [1:7507] 6 5 2 3 4 1 6 5 2 3 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   `Subject Code` = col_double(),
##   ..   `Participant Name` = col_double(),
##   ..   Gender = col_logical(),
##   ..   Age = col_logical(),
##   ..   `Start Time (UTC)` = col_character(),
##   ..   `End Time (UTC)` = col_character(),
##   ..   `Serving Position` = col_double(),
##   ..   `Sample Identifier` = col_double(),
##   ..   `Sample Name` = col_character(),
##   ..   `9pt_appearance` = col_double(),
##   ..   pre_expectation = col_double(),
##   ..   jar_color = col_double(),
##   ..   jar_gloss = col_double(),
##   ..   jar_size = col_double(),
##   ..   cata_appearance_unevencolor = col_double(),
##   ..   cata_appearance_misshapen = col_double(),
##   ..   cata_appearance_creased = col_double(),
##   ..   cata_appearance_seedy = col_double(),
##   ..   cata_appearance_bruised = col_double(),
##   ..   cata_appearance_notfresh = col_double(),
##   ..   cata_appearance_fresh = col_double(),
##   ..   cata_appearance_goodshape = col_double(),
##   ..   cata_appearance_goodquality = col_double(),
##   ..   cata_appearance_none = col_double(),
##   ..   `9pt_overall` = col_double(),
##   ..   verbal_likes = col_character(),
##   ..   verbal_dislikes = col_character(),
##   ..   `9pt_taste` = col_double(),
##   ..   grid_sweetness = col_double(),
##   ..   grid_tartness = col_double(),
##   ..   grid_raspberryflavor = col_double(),
##   ..   jar_sweetness = col_double(),
##   ..   jar_tartness = col_double(),
##   ..   cata_taste_floral = col_double(),
##   ..   cata_taste_berry = col_double(),
##   ..   cata_taste_green = col_double(),
##   ..   cata_taste_grassy = col_double(),
##   ..   cata_taste_fermented = col_double(),
##   ..   cata_taste_tropical = col_double(),
##   ..   cata_taste_fruity = col_double(),
##   ..   cata_taste_citrus = col_double(),
##   ..   cata_taste_earthy = col_double(),
##   ..   cata_taste_candy = col_double(),
##   ..   cata_taste_none = col_double(),
##   ..   `9pt_texture` = col_double(),
##   ..   grid_seediness = col_double(),
##   ..   grid_firmness = col_double(),
##   ..   grid_juiciness = col_double(),
##   ..   jar_firmness = col_double(),
##   ..   jar_juciness = col_double(),
##   ..   post_expectation = col_double(),
##   ..   price = col_double(),
##   ..   product_tier = col_double(),
##   ..   purchase_intent = col_double(),
##   ..   subject = col_double(),
##   ..   test_day = col_character(),
##   ..   us_appearance = col_double(),
##   ..   us_overall = col_double(),
##   ..   us_taste = col_double(),
##   ..   us_texture = col_double(),
##   ..   lms_appearance = col_double(),
##   ..   lms_overall = col_double(),
##   ..   lms_taste = col_double(),
##   ..   lms_texture = col_double(),
##   ..   cata_appearane_bruised = col_double(),
##   ..   cata_appearance_goodshapre = col_double(),
##   ..   cata_appearance_goodcolor = col_double(),
##   ..   grid_blackberryflavor = col_double(),
##   ..   cata_taste_cinnamon = col_double(),
##   ..   cata_taste_lemon = col_double(),
##   ..   cata_taste_clove = col_double(),
##   ..   cata_taste_minty = col_double(),
##   ..   cata_taste_grape = col_double(),
##   ..   grid_crispness = col_double(),
##   ..   jar_crispness = col_double(),
##   ..   jar_juiciness = col_double(),
##   ..   cata_appearane_creased = col_double(),
##   ..   grid_blueberryflavor = col_double(),
##   ..   cata_taste_piney = col_double(),
##   ..   cata_taste_peachy = col_double(),
##   ..   `9pt_aroma` = col_double(),
##   ..   grid_strawberryflavor = col_double(),
##   ..   cata_taste_caramel = col_double(),
##   ..   cata_taste_grapey = col_double(),
##   ..   cata_taste_melon = col_double(),
##   ..   cata_taste_cherry = col_double(),
##   ..   grid_crunchiness = col_double(),
##   ..   jar_crunch = col_double(),
##   ..   us_aroma = col_double(),
##   ..   lms_aroma = col_double(),
##   ..   berry = col_character(),
##   ..   sample = col_double()
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

Now that we have the basics of vectors, we can move on to the complex data object we're really interested in: `berry_data`.  This is a type of object called a `tibble`, which is a cute/fancy version of the more basic `R` object called a `data.frame`.  These are `R`'s version of the `.csv` file or your typical Excel file: a rectangular matrix of data, with (usually) columns representing some variable and rows representing some kind of observation.  Each row will have a value in each column or will be `NA`, which is `R`'s specific value to represent **missing data**.

In a `data.frame`, every column has to have only a single data type: a column might be `logical` or `integer` or `character`, but it cannot be a mix.  However, each column can be a different type.  For example, the first column in our `beer_data`, called `reviews`, is a `character` vector, but the third column, `beer_id`, is a `numeric` column.  

We have now moved from 1-dimensional vectors to 2-dimensional data tables, which means we're going to have some new properties to investigate.  First off, we might want to know how many rows and columns our data table has:


```r
nrow(berry_data)
```

```
## [1] 7507
```

```r
ncol(berry_data)
```

```
## [1] 92
```

```r
length(berry_data) # Note that length() of a data.frame is the same as ncol()
```

```
## [1] 92
```

We already tried running `str(berry_data)`, which gives us the data types of each column and an example.  Some other ways to examine the data include the following:


```r
berry_data # simply printing the object
head(berry_data) # show the first few rows
tail(berry_data) # show the last few rows
glimpse(berry_data) # a more compact version of str()
names(berry_data) # get the variable/column names
```

Some of these functions (for example, `glimpse()`) come from the `tidyverse` package, so if you are having trouble running a command, first make sure you have run `library(tidyverse)`.

## Subsetting and wrangling data tables

Since we now have 2 dimensions, our old strategy of using a single number to select a value from a vector won't work!  But the `[]` operator still works on data frames and tibbles.  We just have to specify coordinates, as `[<row>, <column>]`.  


```r
berry_data[3, 9] # get the 3rd row, 9th column value
```

```
## # A tibble: 1 x 1
##   `Sample Name`
##   <chr>        
## 1 raspberry 2
```

We can continue to use ranges or vectors of indices to select larger parts of the table


```r
berry_data[1:6, 9] # get the first 5 rows of the 9th column value
```

```
## # A tibble: 6 x 1
##   `Sample Name`
##   <chr>        
## 1 raspberry 6  
## 2 raspberry 5  
## 3 raspberry 2  
## 4 raspberry 3  
## 5 raspberry 4  
## 6 raspberry 1
```

If we only want to subset on a specific dimension and get everything from the other dimension, we just leave it blank.


```r
berry_data[, 1] # get all rows of the 1st column
```

```
## # A tibble: 7,507 x 1
##    `Subject Code`
##             <dbl>
##  1           1001
##  2           1001
##  3           1001
##  4           1001
##  5           1001
##  6           1001
##  7           1002
##  8           1002
##  9           1002
## 10           1002
## # i 7,497 more rows
```

We can also use logical subsetting, just like in vectors.  This is very powerful but a bit complicated, so we are going to introduce some `tidyverse` based operators to do this that will make it a lot easier.  I will just give an example:


```r
berry_data[berry_data$berry == "raspberry", ] # get all raspberry data
```

```
## # A tibble: 2,148 x 92
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
## # i 2,138 more rows
## # i 87 more variables: `End Time (UTC)` <chr>, `Serving Position` <dbl>,
## #   `Sample Identifier` <dbl>, `Sample Name` <chr>, `9pt_appearance` <dbl>,
## #   pre_expectation <dbl>, jar_color <dbl>, jar_gloss <dbl>, jar_size <dbl>,
## #   cata_appearance_unevencolor <dbl>, cata_appearance_misshapen <dbl>,
## #   cata_appearance_creased <dbl>, cata_appearance_seedy <dbl>,
## #   cata_appearance_bruised <dbl>, cata_appearance_notfresh <dbl>, ...
```

In this last example I also introduced the final bit of `tibble` and `data.frame` wrangling we will cover here: the `$` operator.  This is the operator to select a single column from a `data.frame` or `tibble`.  It gives you back the vector that makes up that column:


```r
berry_data$lms_overall # not printed because it is too long!
berry_data$`9pt_overall` # column names starting with numbers or containing special characters like spaces need to be surrounded by backticks (`)
```

One of the nice things about RStudio is that it provides tab-completion for `$`.  Go to the console, type "ber" and hit `tab` (or just wait a second or two, if you use the default RStudio settings).  You'll see a list of possible matches, with `berry_data` at the top.  Hit enter, and this will fill out the typing for you!  Now, type "$" and hit `tab` again.  You'll see a list of the columns in `berry_data`!  This can save a huge amount of typing and memorizing the names of variables and objects.

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


  
