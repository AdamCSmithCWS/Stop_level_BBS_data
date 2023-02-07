library(bbsBayes)

library(tidyverse)

###WARNING this overwrites any previous download
### if you want the route-level data, you need to re-run
### this fetch_bbs_data with level = "state" (the default)
fetch_bbs_data(level = "stop")

all <- load_bbs_data(level = "stop")

bird <- all$bird #counts for each stop - one row for each survey and species observed
# note the above does not include the 0 counts, only rows for species observed during a given survey
route <- all$route # one row for each survey event
species <- all$species #species names from database



#append bird names to count data
bird_sp <- species %>% 
  left_join(.,bird,
            by = c("sp.bbs" = "AOU"))

#select surveys on routes in Quebec
routes_qc <- route %>% 
  filter(State == "Quebec")

#identify surveys conducted on routes in Quebec
events_in_qc <- routes_qc %>% 
  select(RouteDataID) %>% #RouteDataID is the unique survey identifier
  unlist()

#select obseravtions from surveys in quebec
bird_qc <- bird_sp %>% 
  filter(RouteDataID %in% events_in_qc)

# join all into a flat table, with 
# columns for counts at each stop e.g., "Stop1","Stop2",...
qc_all_counts_no_zeros <-  routes_qc %>% 
  left_join(.,bird_qc,
            by = "RouteDataID")









