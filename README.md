# Stop_level_BBS_data

sandbox for accessing stop level BBS data using bbsBayes

A peek into one possible way to extract the stop level data from the BBS using the bbsBayes package. The package was not designed to use the stop-level data, but it does allow for its download.

The package is available on CRAN

```{r}
install.packages(bbsBayes)
```

First download the stop level data. WARNING this overwrites any previous download. If you want the route-level data at some point in teh future, you will need to re-run this fetch_bbs_data with level = "state" (the default) After running this line, you need to type yes to accept the disclaimer

```{r}
fetch_bbs_data(level = "stop")

```

Then load the downloaded data into your session.

```{r}
all <- load_bbs_data(level = "stop")
```

This object is a large list with three items:

1.  bird is the counts at each stop - 1 row for each survey and species observed on the survey

2.  route is the survey-events - 1 row for each bbs survey conducted

3.  species is the BBS database species names

I'm assigning each list element to it's own object for easier access. And then joining the count info `bird` with the species names `species`.

```{r}
bird <- all$bird #counts for each stop - one row for each survey and species observed
# note the above does not include the 0 counts, only rows for species observed during a given survey
route <- all$route # one row for each survey event
species <- all$species #species names from database
#append bird names to count data
bird_sp <- species %>% 
  left_join(.,bird,
            by = c("sp.bbs" = "AOU"))


```

### Selecting all data from a province

Here's an example of how one might select all data from Quebec.

```{r}
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


```

#### Note this does not include all the zeros.

You'll have to think about how to fill in the appropriate zeros, e.g., the zero counts for species observed on a given route in previous years, but not in a particular year.

Best of luck...
