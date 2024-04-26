# Tutorial for Sensometrics 2024: “Publication-quality data visualizations using the R tidyverse”

This repository contains code and markdown files for the tutorial presented at Sensometrics 2024.  If you like, you can download the materials by using the "..." menu at the top right of the repository menu.  You can also see the rendered version of this material by going to the :point_right: [**workshop bookdown page**](https://lhami.github.io/pangborn-r-tutorial-2023/) :point_left:.

# Do _this_ first

We have created [a quick tutorial](https://lhamilton.shinyapps.io/sensometrics2024setup/) to help you install `R`, RStudio, and to confirm that your installation is functioning for the tutorial _prior_ to Sensometrics.

Please go [to the tutorial website](https://lhamilton.shinyapps.io/sensometrics2024setup/) and follow the instructions there.  You will be guided in installing or updating your software so that, on the day of the tutorial, we can dive right into the material!

# Quick Reference

If you want to see code from the workshop, see [the bookdown website](https://lhami.github.io/pangborn-r-tutorial-2023/) for all of the R code broken into individual steps alongside expected output and instructions, or [download and extract](https://lhami.github.io/pangborn-r-tutorial-2023/) the [code/pangborn-2023-code-download.zip file]() for just the lines of R code in a more compact format. Once you've extracted the files, open up RStudio or a basic Notepad program (something that makes `.txt` files) and from the File > Open menu, open the extracted `pangborn-all-code.R` file. If you double-click it from your file viewer, it will run all of the code directly in the console without giving you a chance to read anything.

If you prefer visual or verbal instructions, you can watch [this 10-minute video demo on how to access the workshop files](https://youtu.be/6YOjbBGsAOc).

If you have questions about the `readxl` package and its `read_excel` function, for data that's in a `.xls` or `.xlsx` format, which was an unplanned diversion so it's not in the tutorial outline files, look [at the documention first](https://readxl.tidyverse.org/#cb8), and if you're having trouble try [following along with the examples in this textbook](https://jules32.github.io/r-for-excel-users/readxl.html).

# Setup for this tutorial (Do this before you travel!)

In order to be prepared to participate for this tutorial, you should bring a laptop and **Install the tidyverse package to your travel laptop using RStudio before you arrive**. The tutorial will be held [10 AM--2 PM, 20 August, at the Pangborn Symposium in Nantes, France](https://www.pangbornsymposium.com/Sensometics-tutorials.asp). We recommend doing the following steps **before you travel**:

1.  **Install/update R**:
    1.  Download [R from the CRAN website](https://cran.r-project.org/).
    1.  Run the installer and make sure you can open R.
    2.  (If you already have R, make sure you have version > 4.1.0, to limit compatibility errors.  You can check your version by opening either R or RStudio and typing `sessionInfo()` followed by hitting **return** on your keyboard at the command prompt.)
2. **Install/update RStudio**.
    1.  Download the free version of [RStudio Desktop from the Posit website](https://posit.co/download/rstudio-desktop/#download).
    2.  Run the installer and make sure you can open RStudio.
    3.  (If you already have RStudio, check your version by opening RStudio and navigating to the menu **Help > About RStudio**.  You should be using a version later than the 2022.07.0 release.  If you are not, or if you cannot find this information, please just update your version by following steps 1-2 above.)
    4. If you cannot download RStudio for any reason (such as using a tablet or having an institutional lock on your laptop), you can set up a free account with [Posit](https://posit.cloud/plans/free) to use Rstudio in your browser (Firefox, Edge, Chrome, Safari, Opera, etc) for the sake of the workshop. This method takes some extra work to set up your R Project will be different and you will only be able to run a limited amount of code each month.
3.  **Download the tutorial materials** by [going to the `code/pangborn-2023-code-download.zip` file](https://github.com/lhami/pangborn-r-tutorial-2023/blob/main/code/pangborn-2023-code-download.zip) in this repo, opening the  and clicking `Download`.
    1.  You will have to **unzip** or **extract** all files from the compressed archive to view them. See [here](https://support.microsoft.com/en-us/windows/zip-and-unzip-files-f6dde0a7-0fec-8294-e1d3-703ed85e7ebc) for Windows instructions or [here](https://support.apple.com/guide/mac-help/zip-and-unzip-files-and-folders-on-mac-mchlp2528/mac) for Mac.
    2.  We suggest that you create a new folder on your Desktop to work in.  By downloading the files, you'll get copies of everything you need for the class:
        1.  `.R` Script
        2.  Data
        3.  An `.Rproj` file that will help setup default options in RStudio
    3. We may cut some small sections for time between now and August 20. If you want to make sure you have the exact code file we'll be using, you can check back on August 18.
4.  Test that your install of R/Rstudio is working by installing a "package" (code that extends R's functionality).  We recommend that you install the `tidyverse` package, which will be used in this tutorial.  To do so:
    1.  Open RStudio (if you've already closed it).
    2.  In the **Console** section of RStudio, type (or copy and paste) the following line of code: `install.packages("tidyverse")`.
    3.  Hit "enter/return" on your keyboard to run the command.  You should see a series of informational messages print out in the console.
    4.  Once the process completes, test that your package is installed.  Type (or copy and paste) the following line of code: `library(tidyverse)`.
    5.  Hit "enter/return" on your keyboard to run the command.  You should see a message telling you that a bunch of packages have been loaded, as well as some other information.
    
At this point, you should be all set for the workshop!  Thanks so much for getting set up in advance to make sure we can make the most of our time.

# What this tutorial will cover

> In this tutorial, we will introduce the audience to the R statistical programming environment and the RStudio Interactive Development Environment (IDE) with the aim of developing sufficient basic skills to conduct multivariate analyses (like Correspondence Analysis) on sensory and consumer datasets. We will provide a learning dataset for the analysis—a set of free response comments and overall liking scores from a central location test on berries. We will teach participants how to import, manipulate, and plot data using user-friendly, “tidy” R programming. All resources used in the tutorial are open-source and will remain available to attendees, including an R script covering the full workflow.
> 
> At the end of the tutorial, attendees will be able to prepare raw sensory data for common multivariate analyses or visual representations in R.

# What you should already know

The main prerequisite for this tutorial is that you **need to have RStudio pre-installed**.

We are trying to make this tutorial accessible to a broad audience, so while some familiarity with statistics and data-analysis for sensory science (i.e., sensometrics) will be helpful, it isn't strictly required.

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
