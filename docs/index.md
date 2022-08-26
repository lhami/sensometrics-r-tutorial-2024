---
title: "An introduction to text analysis with R for sensory and consumer scientists"
author: "Jacob Lahne"
site: "bookdown::bookdown_site"
documentclass: book
output:
  bookdown::gitbook: default
  #bookdown::pdf_book: default
output_dir: "docs"
github-repo: jlahne/eurosense-tutorial-2022
---

# Introduction and welcome {-}




Welcome to the Eurosense Sensometrics Workshop "**An introduction to text analysis with R for sensory and consumer scientists**"!

This workshop is going to be conducted not using slides, but through **livecoding**.  That means I am going to run code lines in the console or highlight and run code in scripts and other files.  It is also an opportunity and encouragement for you to follow along.  Along with introducing myself and my helpers for today's workshop, we're going to discuss a bit about how that will work here.

## Introductions {-}

### Jacob Lahne, PhD {-}

Jacob Lahne is an Assistant Professor of Food Science & Technology at Virginia Tech, in the United States.  He runs the Virginia Tech Sensory Evaluation Laboratory, as well as teaching courses in data analytics and coding for food-science research.  His main research focuses are sensory data-analysis methodologies and investigating the sensory properties of fermented and distilled foods and beverages.

### Leah Hamilton, PhD {-}

Leah Hamilton is a postdoctoral researcher at the UC Davis Department of Food Science & Technology, in the US. Her primary research interest is flavor language, including the ways that people talk about flavors using their own words in different contexts.

### Martha Calvert, MS {-}

Martha Calvert is a PhD candidate in the Department of Food Science and Technology at Virginia Tech, in the United States.

## Today's agenda {-}

Today's workshop is going to take ~3 hours, with a break for lunch, and we'll be covering the following material:  

1.  Crash course in using R  
2.  Creating, importing, and manipulating data in R
3.  Principles of tidy data analysis using `tidyverse`
4.  Basics of data visualization in `R`/`ggplot2`
5.  Basic text analysis with `tidytext` 
    1.  Dealing with character data
    2.  Units of analysis: tokenization
    3.  TF-IDF models
    4.  Sentiment Analysis
  
## How we're going to run {-}

This workshop is going to be run with **livecoding**, as noted above.  This means I won't be using slides or a prepared video, but running through code step by step to show how these tools are used in practice.  I encourage **you** to also follow along with livecoding, because the best way to learn coding is to actually do it.

### Recommended approach for livecoding {-}

We recommend that you download the pre-made archive of code and data from the [workshop github repo](https://github.com/jlahne/eurosense-tutorial-2022).  This archive, when unzipped, will have a folder structure and a `.Rproj` file.  We recommend that you close out RStudio, unzip the archive, and double click the `.Rproj` file *in that folder*, which will open a new session of RStudio with proper setting (like the home directory) for the files for this workshop.

In that folder, you will find a `data/` folder with the necessary data for the workshop, and a script named `eurosense-workshop-all-code.R`.  This latter file contains all of the code demonstrated in this workshop for your future reference.  You can also follow along with the code at the [workshop's page hosted on github.io](https://jlahne.github.io/eurosense-tutorial-2022/) (which you're reading right now), and which will remain available after this workshop.

Once you're in RStudio, go to the `File > New File > R Script` menu to open a new script.  We'll talk about how these work in a minute, but this is basically a workbook for you to store sequential lines of code to be run in the `Console`.  It is where you can livecode along!  Even though we are giving you all of the code you need right now, you will learn a lot more if you actively follow along, rather than just run that code.

### Dealing with errors {-}

Coding means **making mistakes**.  This is fine--as you will surely see today, I will make a ton of trivial errors and have to fix things on the fly.  If you run into trouble, try looking carefully at what you've done and see if you can see what went wrong.  If that fails, we are here to help!  Because we have 3 instructors for this workshop, two of us are available to help at any time.  

When you run into trouble, please use the **red sticky note** by putting it on the back of your laptop.  We'll be keeping an eye out, and someone will come to help you.  When you've resolved your problem, take the sticky note back off.  This way you don't have to raise your hand and interrupt the workshop, etc.  However, if your issue is a common one or something we think is worth noting, don't worry--we'll make time to discuss it!
