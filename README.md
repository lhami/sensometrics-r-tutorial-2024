# Tutorial for Sensometrics 2024: “Publication-quality data visualizations using the R tidyverse”

This repository contains code and markdown files for the tutorial presented at Sensometrics 2024.  If you like, you can download the materials by using the "..." menu at the top right of the repository menu.  You can also see the rendered version of this material by going to the :point_right: [**workshop bookdown page**](https://lhami.github.io/sensometrics-r-tutorial-2024/) :point_left:.

# DO THIS FIRST

We have created [a quick tutorial](https://lhamilton.shinyapps.io/sensometrics2024setup/) to help you install `R`, RStudio, and to confirm that your installation is functioning for the tutorial _prior_ to Sensometrics.

Please go [to the tutorial website](https://lhamilton.shinyapps.io/sensometrics2024setup/) and follow the instructions there.  You will be guided in installing or updating your software so that, on the day of the tutorial, we can dive right into the material!

# Quick Reference

If you have followed the instructions from the tutorial above, you should have all the material you need for the workshop, and your version of `R` and RStudio should be set up properly. 

If you want to see code from the workshop, see [the bookdown website](https://lhami.github.io/sensometrics-r-tutorial-2024/) for all of the R code broken into individual steps alongside expected output and instructions, or [download and extract (link goes our notes on how to do this)](https://lhami.github.io/sensometrics-r-tutorial-2024/index.html#recommended-approach-for-livecoding) the [code/sensometrics-2024-code-download.zip file](https://github.com/lhami/sensometrics-r-tutorial-2024/tree/main/code) for just the lines of R code in a more compact format. Once you've extracted the files, open up RStudio or a basic Notepad program (something that makes `.txt` files) and from the File > Open menu, open the extracted `pangborn-all-code.R` file. If you double-click it from your file viewer, it will run all of the code directly in the console without giving you a chance to read anything.

If you want detailed, written instructions, you can consult the instructions for our [tutorial last year at Pangborn 2023](https://github.com/lhami/pangborn-r-tutorial-2023), which gave detailed set up instructions for `R`, RStudio, and a very similar set of tutorials.

# What this tutorial will cover

>In this tutorial, we will introduce the audience to ggplot2 and the rest of the tidyverse R packages with the aim of developing sufficient basic skills to visualize multivariate sensory and consumer data. We will provide a learning dataset for the analysis—a set of free response comments and overall liking scores from a central location test on berries. We will teach participants how to import, manipulate, and plot data using user-friendly, “tidy” R programming. All resources used in the tutorial are open-source and will remain available to attendees, including an R script covering the full workflow.
>
>At the end of the tutorial, attendees will be able to prepare raw sensory data for common multivariate visual representations in R.


# What you should already know

The main prerequisite for this tutorial is that you [**have followed the tutorial setup instructions**](https://lhamilton.shinyapps.io/sensometrics2024setup/).

We expect participants to have basic familiarity with data types, variables, functions, and installing/using packages in R/RStudio. Basic understanding of statistics is helpful but not required. In general, participants who have some experience with `R` or coding for research will have a better time. 

In order to cover our planned material, we will be moving relatively quickly through basic R usage and data wrangling within about 90 minutes, so we can spend the rest of the tutorial on data analysis and visualization workflows.  That's a lot to get through, so if you find that idea intimidating you might benefit from taking a look at some of the [sources below](#how-can-you-get-ahead-or-learn-more).  These range from self-paced tutorials to full how-to books.

# What we will *not* be covering:

* Statistical theory (including for Correspondence Analysis)
* How to write these kinds of web-friendly documents and bookdowns
* Production programming for R
* All possible data types
* Basic concepts of computing, for example file storage, version control, data types and storage, etc.

# How can you get ahead or learn more?

Much of the material we have used to develop this workshop came from the fantastic, open-science and open-coding community that has developed around R.  If you find yourself wanting to learn more, I highly recommend starting with the following sources:

*  [Software Carpentry's R for Social Scientists](https://datacarpentry.org/r-socialsci/)
*  [R for Data Science](https://r4ds.had.co.nz/)
*  [Stat 545](https://stat545.com/)
*  [Correspondence Analysis in Practice](https://doi.org/10.1201/9781315369983/)
*  [Text Mining with R](https://www.tidytextmining.com/)
*  [Data Visualization: A Practical Introduction](https://socviz.co/)

Beyond that, remember the power of searching forums like Stackoverflow and Stackexchange--looking at a few related threads can usually teach you how to solve your problem, as well as develop your critical-thinking and problem-solving skills for the future.
