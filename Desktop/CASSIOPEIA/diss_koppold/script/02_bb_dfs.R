# skript to generate a dtaframe with balance board data 
# and matching with behavioral data
# 04.07.2022
# Alina Koppold

###

# LIBRARIES

rm(list = ls())

library(dplyr)
library(data.table)
library(readr)
library(purrr)
library(ggplot2)

# LOADING BB DATA

tbl_bb <- 
  list.files("./data/raw/", 
             pattern="bbdata*",
             full.names = T, 
             recursive = TRUE) %>% 
  map_df(~fread(.) %>% mutate(ppName = as.character(ppName)))

# rename singe ppn typos 
tbl_bb$ppName[tbl_bb$ppName == "040backspace"] <- "40"
colnames(tbl_bb)[2] <- "ID"
save(tbl_bb, file = "./data/merged/tbl_bb.RData")



# LOADING BEHAVIORAL DATA

tbl_behave <- 
  list.files("./data/raw/", 
             pattern="behav*",
             full.names = T, 
             recursive = TRUE) %>% 
  map_df(~fread(.)%>% mutate(ID = as.character(ID)))
save(tbl_behave, file = "./data/merged/tbl_behave.RData")


# LOADING RATING DATA

tbl_rating <- 
  list.files("./data/raw/", 
             pattern="rating*",
             full.names = T, 
             recursive = TRUE) %>% 
  map_df(~fread(.)%>% mutate(ID = as.factor(ID)))


#####
## MERGING BB DATA WITH BEHAVE 

behave_bb = merge(tbl_behave, tbl_bb, by= c("ID", "coreTrialStart"))
table(behave_bb$trialnr)
behave_bb = behave_bb %>% filter(trialnr != "ex")

save(behave_bb, file = "./data/merged/behave_bb.RData")
