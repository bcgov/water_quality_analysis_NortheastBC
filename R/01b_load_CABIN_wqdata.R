# Copyright 2017 Province of British Columbia 
  
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
  
# http://www.apache.org/licenses/LICENSE-2.0 
  
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and limitations under the License. 

############################################################################### 
# Module 1b. LOAD CABIN WATER QUALITY DATA FROM EMS
############################################################################### 

library(devtools)
library(rems)
library(wqbc)
library(ggplot2)
library(tidyr)
library(scales)
library(dplyr)

## LOAD TWO YEAR EMS WATER QUALITY DATASET from BC Data Catalogue using bcgov/rems package

twoyear <- get_ems_data(which = "2yr", ask = TRUE)

filtered_twoyear_env_cabin <- filter_ems_data(twoyear, 
                                    emsid = c("E298950","E306409","E306408","E306400","E306399","E306398",
                                              "E306397"), 
                                    to_date = "2017/09/08") 

                  
tidy_data_env_cabin <- tidy_ems_data(filtered_twoyear_env_cabin, mdl_action = "mdl")

all_data_env_cabin <- filter(tidy_data_env_cabin, ResultLetter != ">" | is.na(ResultLetter))

all_data_clean_env_cabin <- clean_wqdata(all_data_env_cabin, by = "EMS_ID", delete_outliers = TRUE)

cabin_env_sites <- distinct(all_data_clean_env_cabin, EMS_ID)

cabin_summary <- group_by(all_data_clean_env_cabin, Variable, Units) %>% 
  summarise(Min=min(Value), Max=max(Value))
