
<!-- README.md is generated from README.Rmd. Please edit that file -->

# juncture

<!-- badges: start -->

[![R-CMD-check](https://github.com/johnmackintosh/juncture/workflows/R-CMD-check/badge.svg)](https://github.com/johnmackintosh/juncture/actions)
[![Codecov test
coverage](https://codecov.io/gh/johnmackintosh/juncture/branch/master/graph/badge.svg)](https://app.codecov.io/gh/johnmackintosh/juncture?branch=master)
<!-- badges: end -->

The goal of juncture is to create census tables of people or resources
by period, given a start and end date, without reliance on access to a
database or writing SQL.

Consider the scenario where you need to know how many patients were ‘IN’
hospital. Some typical questions might be:  
- How many patients were in the hospital at 10 AM yesterday?  
- How many were in during each 15 minute spell between 2pm and 6pm?  
- How many were in during the last week, by hour?

This package aims to make answering these questions easier and quicker.

No SQL? No problem!

If you have time in, time out, a unique identifier, and optionally, a
grouping variable to track moves between departments or changes in
status, this package will tell you how many individuals or resources
were ‘IN’ / ‘OPEN’ at any time, at whatever granularity you need.

## Installation

``` r
# install.packages("remotes") # if not already installed
remotes::install_github("johnmackintosh/juncture")
```

## The problem

The built-in dataset, `beds` shows the problem. We need a way to count
the number of patients in the hospital, either by bed, or on an
individual basis, by any time interval.

``` r
library(juncture)
beds
#>    bed patient          start_time            end_time
#> 1    A       1 2020-01-01 09:34:00 2020-01-01 10:34:00
#> 2    A       2 2020-01-01 10:55:00 2020-01-01 11:15:24
#> 3    A       3 2020-01-01 11:34:00 2020-01-02 17:34:00
#> 4    A       4 2020-01-01 18:00:00 2020-01-03 00:00:00
#> 5    B       5 2020-01-01 09:45:00 2020-01-01 14:45:00
#> 6    B       6 2020-01-01 16:13:00 2020-01-01 21:27:24
#> 7    B       7 2020-01-01 21:41:48 2020-01-01 22:56:12
#> 8    B       8 2020-01-01 23:13:00 2020-01-02 00:43:00
#> 9    C       9 2020-01-01 10:05:00 2020-01-01 10:35:00
#> 10   D      10 2020-01-01 10:30:00                <NA>
```

## Summary by hour

To obtain summary data for every hour, for all combined patient stays,
we set `results` to `totals`.

The base date and base hour for each interval are supplied to enable
easier filtering of the results.

Here the output is restricted to `2020-01-01` using the generated
`base_date` column:

``` r
library(juncture)
patient_count_hour <- juncture(beds, 
identifier = 'patient',
time_in = 'start_time', 
time_out = 'end_time', 
group_var = 'bed', 
time_unit = '1 hour', 
results = "total", 
uniques = TRUE)

patient_count_hour[base_date == '2020-01-01']
#>      interval_beginning        interval_end  base_date base_hour N
#>  1: 2020-01-01 09:00:00 2020-01-01 10:00:00 2020-01-01         9 2
#>  2: 2020-01-01 10:00:00 2020-01-01 11:00:00 2020-01-01        10 5
#>  3: 2020-01-01 11:00:00 2020-01-01 12:00:00 2020-01-01        11 4
#>  4: 2020-01-01 12:00:00 2020-01-01 13:00:00 2020-01-01        12 3
#>  5: 2020-01-01 13:00:00 2020-01-01 14:00:00 2020-01-01        13 3
#>  6: 2020-01-01 14:00:00 2020-01-01 15:00:00 2020-01-01        14 3
#>  7: 2020-01-01 15:00:00 2020-01-01 16:00:00 2020-01-01        15 2
#>  8: 2020-01-01 16:00:00 2020-01-01 17:00:00 2020-01-01        16 3
#>  9: 2020-01-01 17:00:00 2020-01-01 18:00:00 2020-01-01        17 3
#> 10: 2020-01-01 18:00:00 2020-01-01 19:00:00 2020-01-01        18 4
#> 11: 2020-01-01 19:00:00 2020-01-01 20:00:00 2020-01-01        19 4
#> 12: 2020-01-01 20:00:00 2020-01-01 21:00:00 2020-01-01        20 4
#> 13: 2020-01-01 21:00:00 2020-01-01 22:00:00 2020-01-01        21 5
#> 14: 2020-01-01 22:00:00 2020-01-01 23:00:00 2020-01-01        22 4
#> 15: 2020-01-01 23:00:00 2020-01-02 00:00:00 2020-01-01        23 4
```

## Grouping by bed and hour

This example shows grouping results by bed and hour.

``` r
library(juncture)
grouped <- juncture(beds, 
identifier = 'patient',
time_in = 'start_time', 
time_out = 'end_time', 
group_var = 'bed', 
time_unit = '1 hour',
results = "group", 
uniques = FALSE)

 # order the output by the  bed and start time: 
grouped[bed %chin% c('B', 'C')][,.(bed, base_date, base_hour, N)][order(bed,base_date, base_hour)][]
#>     bed  base_date base_hour N
#>  1:   B 2020-01-01         9 1
#>  2:   B 2020-01-01        10 1
#>  3:   B 2020-01-01        11 1
#>  4:   B 2020-01-01        12 1
#>  5:   B 2020-01-01        13 1
#>  6:   B 2020-01-01        14 1
#>  7:   B 2020-01-01        16 1
#>  8:   B 2020-01-01        17 1
#>  9:   B 2020-01-01        18 1
#> 10:   B 2020-01-01        19 1
#> 11:   B 2020-01-01        20 1
#> 12:   B 2020-01-01        21 2
#> 13:   B 2020-01-01        22 1
#> 14:   B 2020-01-01        23 1
#> 15:   B 2020-01-02         0 1
#> 16:   C 2020-01-01        10 1
```

## Individual Level results

Use this option to enable further aggregation or analysis within R or
other analytic tools. The output contains 1 row per individual/
resource, per interval, for each interval within the respective date
range.

``` r
library(juncture)
patient_count_hour <- juncture(beds, 
identifier = 'patient',
time_in = 'start_time', 
time_out = 'end_time', 
group_var = 'bed', 
time_unit = '1 hour', 
results = "individual", 
uniques = TRUE)

head(patient_count_hour,10)
#>     bed patient          start_time            end_time  interval_beginning
#>  1:   A       1 2020-01-01 09:34:00 2020-01-01 10:34:00 2020-01-01 09:00:00
#>  2:   B       5 2020-01-01 09:45:00 2020-01-01 14:45:00 2020-01-01 09:00:00
#>  3:   A       1 2020-01-01 09:34:00 2020-01-01 10:34:00 2020-01-01 10:00:00
#>  4:   B       5 2020-01-01 09:45:00 2020-01-01 14:45:00 2020-01-01 10:00:00
#>  5:   C       9 2020-01-01 10:05:00 2020-01-01 10:35:00 2020-01-01 10:00:00
#>  6:   A       2 2020-01-01 10:55:00 2020-01-01 11:15:24 2020-01-01 10:00:00
#>  7:   D      10 2020-01-01 10:30:00 2020-01-03 00:00:00 2020-01-01 10:00:00
#>  8:   B       5 2020-01-01 09:45:00 2020-01-01 14:45:00 2020-01-01 11:00:00
#>  9:   A       2 2020-01-01 10:55:00 2020-01-01 11:15:24 2020-01-01 11:00:00
#> 10:   D      10 2020-01-01 10:30:00 2020-01-03 00:00:00 2020-01-01 11:00:00
#>            interval_end  base_date base_hour
#>  1: 2020-01-01 10:00:00 2020-01-01         9
#>  2: 2020-01-01 10:00:00 2020-01-01         9
#>  3: 2020-01-01 11:00:00 2020-01-01        10
#>  4: 2020-01-01 11:00:00 2020-01-01        10
#>  5: 2020-01-01 11:00:00 2020-01-01        10
#>  6: 2020-01-01 11:00:00 2020-01-01        10
#>  7: 2020-01-01 11:00:00 2020-01-01        10
#>  8: 2020-01-01 12:00:00 2020-01-01        11
#>  9: 2020-01-01 12:00:00 2020-01-01        11
#> 10: 2020-01-01 12:00:00 2020-01-01        11

patient_count_hour[patient == 5,]
#>    bed patient          start_time            end_time  interval_beginning
#> 1:   B       5 2020-01-01 09:45:00 2020-01-01 14:45:00 2020-01-01 09:00:00
#> 2:   B       5 2020-01-01 09:45:00 2020-01-01 14:45:00 2020-01-01 10:00:00
#> 3:   B       5 2020-01-01 09:45:00 2020-01-01 14:45:00 2020-01-01 11:00:00
#> 4:   B       5 2020-01-01 09:45:00 2020-01-01 14:45:00 2020-01-01 12:00:00
#> 5:   B       5 2020-01-01 09:45:00 2020-01-01 14:45:00 2020-01-01 13:00:00
#> 6:   B       5 2020-01-01 09:45:00 2020-01-01 14:45:00 2020-01-01 14:00:00
#>           interval_end  base_date base_hour
#> 1: 2020-01-01 10:00:00 2020-01-01         9
#> 2: 2020-01-01 11:00:00 2020-01-01        10
#> 3: 2020-01-01 12:00:00 2020-01-01        11
#> 4: 2020-01-01 13:00:00 2020-01-01        12
#> 5: 2020-01-01 14:00:00 2020-01-01        13
#> 6: 2020-01-01 15:00:00 2020-01-01        14
```

## General Help

-   You must ‘quote’ your variables, for the time being at least..

## Results

-   Set results to ‘individual’ for 1 row per person / resource by
    interval, for each duration.
-   Set results to ‘group’ to get a count per group per interval.  
    The ‘uniques’ argument will be set to FALSE (and any existing value
    will be over-ridden if necessary) to ensure each move in each group
    is counted.  
-   Set results to ‘total’ for a summary of the data set - interval,
    base\_hour and count.

## Tracking moves within the same interval with ‘uniques’

-   To count individual people / resources ONLY, leave ‘uniques’ at the
    default value of ‘TRUE’.  
-   To count changes between groups during intervals, set uniques to
    ‘FALSE’. For example, hospital patients who occupy beds in different
    wards or departments during an interval are accounted for in each
    location. They will be counted at least twice during the interval -
    both in their initial location and their new location following the
    move.

## Timezones

-   Everything is easier if you use “UTC” by default. You can attempt to
    coerce the final results yourself using lubridate::force\_tz()

To find your system timezone:

``` r
Sys.timezone()
```

## Time Unit

See ? seq.POSIXt for valid values

E.G. ‘1 hour’, ‘15 mins’, ‘30 mins’

## Time Adjust

Want to count those in between 10:01 to 11:00? You can do that using
‘time\_adjust\_period’ - set it to ‘start\_min’ and then set
‘time\_adjust\_interval’ to 1.

10:00 to 10:59?  
Yes, that’s possible as well - set ‘time\_adjust\_period’ to ‘end\_min’
and set ‘time\_adjust\_interval’ as before. You can set these periods to
any value, as long as it makes sense in relation to your chosen
time\_unit.

Here we adjust the start\_time by 5 minutes

``` r
library(juncture)
patient_count_time_adjust <- juncture(beds, 
identifier = 'patient',
time_in = 'start_time', 
time_out = 'end_time', 
group_var = 'bed', 
time_unit = '1 hour', 
time_adjust_period = 'start_min',
time_adjust_value = 5,
results = "total", 
uniques = TRUE)

head(patient_count_time_adjust)
#>     interval_beginning        interval_end  base_date base_hour N
#> 1: 2020-01-01 09:05:00 2020-01-01 10:00:00 2020-01-01         9 2
#> 2: 2020-01-01 10:05:00 2020-01-01 11:00:00 2020-01-01        10 5
#> 3: 2020-01-01 11:05:00 2020-01-01 12:00:00 2020-01-01        11 4
#> 4: 2020-01-01 12:05:00 2020-01-01 13:00:00 2020-01-01        12 3
#> 5: 2020-01-01 13:05:00 2020-01-01 14:00:00 2020-01-01        13 3
#> 6: 2020-01-01 14:05:00 2020-01-01 15:00:00 2020-01-01        14 3
```

Valid values for time\_adjust\_period are ‘start\_min’, ‘start\_sec’,
‘end\_min’ and ‘end\_sec’

## The hotel problem

How many patients are ‘IN’ the hotel each day

``` r
check_in_date <- c('2010-01-01', '2010-01-02' ,'2010-01-01', '2010-01-08', 
                   '2010-01-08', '2010-01-15', '2010-01-15', '2010-01-16', '2010-01-19', '2010-01-22')
check_out_date <- c('2010-01-07', '2010-01-04' ,'2010-01-09', '2010-01-21', 
                    '2010-01-11', '2010-01-22', NA, '2010-01-20', '2010-01-25', '2010-01-29')
Person = c("John", "Smith", "Alex", "Peter", "Will", "Matt", "Tim", "Kevin", "Tom", "Adam")

checkin <- as.POSIXct(as.Date(check_in_date))
checkout <- as.POSIXct(as.Date(check_out_date))
hotel <- data.frame(checkin, checkout, Person)

hotel_occupancy <- juncture(hotel, 
         identifier = "Person",
         time_in = "checkin",
         time_out  = "checkout", 
         time_unit = '1 day',
         results = 'total')

# just show the dates and number 'IN'
hotel_occupancy[,.(base_date, N)]
#>      base_date N
#>  1: 2010-01-01 2
#>  2: 2010-01-02 3
#>  3: 2010-01-03 3
#>  4: 2010-01-04 2
#>  5: 2010-01-05 2
#>  6: 2010-01-06 2
#>  7: 2010-01-07 1
#>  8: 2010-01-08 3
#>  9: 2010-01-09 2
#> 10: 2010-01-10 2
#> 11: 2010-01-11 1
#> 12: 2010-01-12 1
#> 13: 2010-01-13 1
#> 14: 2010-01-14 1
#> 15: 2010-01-15 3
#> 16: 2010-01-16 4
#> 17: 2010-01-17 4
#> 18: 2010-01-18 4
#> 19: 2010-01-19 5
#> 20: 2010-01-20 4
#> 21: 2010-01-21 3
#> 22: 2010-01-22 3
#> 23: 2010-01-23 3
#> 24: 2010-01-24 3
#> 25: 2010-01-25 2
#> 26: 2010-01-26 2
#> 27: 2010-01-27 2
#> 28: 2010-01-28 2
#>      base_date N
```
