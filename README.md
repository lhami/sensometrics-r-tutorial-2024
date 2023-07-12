# Tutorial for Pangborn 2023: "An introduction to R for sensory and consumer scientists"

This repository contains code and markdown files for the tutorial presented at Pangborn 2023.  If you like, you can download the materials by using the "..." menu at the top right of the repository menu.  You can also see the rendered version of this material by going to the [workshop bookdown page](https://jlahne.github.io/eurosense-tutorial-2022/).

# Setup for this tutorial (Do this before you travel!)

In order to be prepared to participate for this tutorial, you should do the following steps prior to the tutorial, which will be held [10 AM--2 PM, 20 August, at the Pangborn Symposium in Nantes, France](https://www.pangbornsymposium.com/Sensometics-tutorials.asp):

1.  Install R/update R:
    1.  Download [R from the CRAN website](https://cran.r-project.org/).
    1.  Run the installer and make sure you can open R.
    2.  (If you already have R, make sure you have version > 4.3.0, otherwise we can't guarantee that problems won't arise from incompatibilities.  You can check your version by opening either R or RStudio and typing `sessionInfo()` followed by hitting **return** on your keyboard at the command prompt.)
2. Install RStudio/update RStudio.
    1.  Download the free version of [RStudio Desktop from their website](https://www.rstudio.com/products/rstudio/download/#download).
    2.  Run the installer and make sure you can open RStudio.
    3.  (If you already have RStudio, check your version by opening RStudio and navigating to the menu **Help > About RStudio**.  You should be using a version later than the 2022-05-xx release.  If you are not, or if you cannot find this information, please just update your version by following steps 1-2 above.)
    4. **If you cannot download RStudio for any reason** (such as using a tablet or having an institutional lock on your laptop), please email Jacob Lahne (jlahne@vt.edu) and/or Leah Hamilton (lmhamilton@ucdavis.edu) as soon as possible. For the sake of this workshop, you can set up a free account with [Posit](https://posit.cloud/plans/free), the RStudio developer, to use Rstudio in your browser (Firefox, Edge, Chrome, Safari, Opera, etc), but the setup for your R Project will be different and you will only be able to run a limited amount of code each month.
3.  Download the tutorial materials by [going to the `code/pangborn-code-download.zip` file](https://github.com/lhami/pangborn-tutorial-2023/blob/main/code/pangborn-code-download.zip) in this repo and clicking `Download`.
    1.  We suggest that you create a new folder on your Desktop to work in.  By downloading the files, you'll get copies of everything you need for the class:
        1.  `.R` Script
        2.  Data
        3.  An `.Rproj` file that will help setup default options in RStudio
        4. (If you want to duplicate the exact files in this tutorial, you can also **clone** the github repo here, but this is more advanced than we will cover in this tutorial.)
4.  Test that your install of R/Rstudio is working by installing a "package" (code that extends R's functionality).  We recommend that you install the `tidyverse` package, which will be used in this tutorial.  To do so:
    1.  Open RStudio (if you've already closed it).
    2.  In the **Console** section of RStudio, type (or copy and paste) the following line of code: `install.packages("tidyverse")`.
    3.  Hit "enter/return" on your keyboard to run the command.  You should see a series of informational messages print out in the console.
    4.  Once the process completes, test that your package is installed.  Type (or copy and paste) the following line of code: `library(tidyverse)`.
    5.  Hit "enter/return" on your keyboard to run the command.  You should see a message telling you that a bunch of packages have been loaded, as well as some other information.
    
At this point, you should be all set for the workshop!  Thanks so much for getting set up in advance to make sure we can make the most of our time.

# What this tutorial will cover

> In this tutorial, we will introduce the audience to the R statistical programming environment and the RStudio Interactive Development Environment (IDE) with the aim of developing sufficient basic skills to conduct a text analysis on sensory-relevant text data. We will provide a learning dataset of text data for the analysis—a set of food-product free-comment reviews that are associated with overall liking scores. This will allow us to demonstrate connections between text analysis methods and basic sensory and consumer science approaches. We will also provide an R script that walks through all steps of importing, manipulating, and analysing the test dataset.
>
> The tutorial will have 2 sections. In the first section of the tutorial, we will introduce R and RStudio, we will cover the basic commands of R, and we will cover key, user-friendly conventions of ”tidy” R programming for importing, manipulating, and plotting data using the “tidyverse” packages. In the second section we will use the “tidytext” package to conduct basic text analysis, including text tokenization, text modeling using TF-IDF, and basic lexicon-based sentiment analysis.

# What you should already know

We are trying to make this tutorial accessible to a broad audience, so while some familiarity with statistics and data-analysis for sensory science (i.e., sensometrics) will be helpful, it isn't strictly required.  You do not need any experience with R or RStudio, but you **do need to have RStudio pre-installed**. In order to cover our planned material, we will be moving relatively quickly through basic R usage and data wrangling within about 90 minutes, so we can spend the rest of the tutorial on data analysis and visualization workflows.  That's a lot to get through, so if you find that idea intimidating you might benefit from taking a look at some of the [sources below](#how-can-you-get-ahead-or-learn-more).  These range from self-paced tutorials to full how-to books.

# What we will *not* be covering:

* Statistical theory (including for Correspondance Analysis)
* How to write these kinds of web-friendly documents and bookdowns
* Production programming for R
* All possible data types
* Basic concepts of computing, for example file storage, version control, data types and storage, etc.

# How can you get ahead or learn more?

Much of the material we have used to develop this workshop came from the fantastic, open-science and open-coding community that has developed around R.  If you find yourself wanting to learn more, I highly recommend starting with the following sources:

*  [Software Carpentry's R for Social Scientists](https://datacarpentry.org/r-socialsci/)
*  [R for Data Science](https://r4ds.had.co.nz/)
*  [Stat 545](https://stat545.com/)
*  [Text Mining with R](https://www.tidytextmining.com/)
*  [Data Visualization: A Practical Introduction](https://socviz.co/)

Beyond that, remember the power of searching forums like Stackoverflow and Stackexchange--looking at a few related threads can usually teach you how to solve your problem, as well as develop your critical-thinking and problem-solving skills for the future.
