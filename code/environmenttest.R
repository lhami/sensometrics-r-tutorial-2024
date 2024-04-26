library(tidyverse)
library(ca)
library(FactoMineR)
library(ggrepel)
library(ggforce)
library(cowplot)
library(patchwork)
library(tidytext)
library(wesanderson)
#To debug your R version number:
#sessionInfo()$R.version$version.string
#To debug your working directory:
#getwd()

berry_data <- read_csv("data/clt-berry-data.csv")
berry_data %>%
  select(-where(~ any(is.na(.x)))) %>%
  group_by(`Sample Name`) %>%
  summarize(across(.cols = starts_with("cata_"), .fns = sum)) %>%
  column_to_rownames("Sample Name") %>%
  ca() -> berry_ca

berry_ca$sv[1]
