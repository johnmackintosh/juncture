library("tinytest")
library("checkmate")
using("checkmate")



# more than one argument for `results`


expect_error(juncture(df = beds,
                      identifier = "pat_id",
                      time_in = "admit_date",
                      time_out = "discharge_date",
                      group_var = "location",
                      time_unit = "1 hour",
                      results = c('total','individual'),
                      uniques = FALSE))

# grp throws error

expect_error(juncture(df = beds,
                      identifier = "pat_id",
                      time_in = "admit_date",
                      time_out = "discharge_date",
                      group_var = "location",
                      time_unit = "1 hour",
                      results = 'grp',
                      uniques = FALSE))




# missing df argument causes error",
expect_error(juncture(df = NULL,
                      identifier = 'pat_id',
                      time_in = "admit_date",
                      time_out = "discharge_date",
                      group_var = "location",
                      time_unit = "1 hour",
                      results = "individual",
                      uniques = TRUE))


# df not specified results in error
expect_error(juncture(df = NULL,
                      identifier = 'pat_id',
                      time_in = "admit_date",
                      time_out = "discharge_date",
                      group_var = "location",
                      time_unit = "1 hour",
                      results = "patient",
                      uniques = TRUE))


# identifier is null
expect_error(juncture(df = beds,
                      identifier = NULL,
                      time_in = "admit_date",
                      time_out = "discharge_date",
                      group_var = "location",
                      time_unit = "1 hour",
                      results = "patient",
                      uniques = TRUE))

  # missing identifier
expect_error(juncture(df = beds,
                      identifier = NULL,
                      time_in = "admit_date",
                      time_out = "discharge_date",
                      group_var = "location",
                      time_unit = "1 hour",
                      results = "patient",
                      uniques = TRUE))





# missing time_in

  expect_error(juncture(beds,
                        identifier = "patient",
                        time_out = "end_time",
                        group_var = "bed",
                        time_unit = "1 hour",
                        results =  "total",
                        uniques = TRUE))



  # missing time_out


  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        group_var = "bed",
                        time_unit = "1 hour",
                        results =  "total",
                        uniques = TRUE))


# missing group_var when grouped results required


  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'end_time',
                        group_var = NULL,
                        time_unit = "1 hour",
                        results =  "group",
                        uniques = FALSE))



  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'end_time',
                        time_unit = "1 hour",
                        results =  "group",
                        uniques = FALSE))

  # using grp instead of group_var for 'results' argument

  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'end_time',
                        group_var = 'bed',
                        time_unit = "1 hour",
                        results =  "grp",
                        uniques = FALSE))


# uniques  = TRUE when grouped results requested


  expect_message(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'end_time',
                        group_var = 'bed',
                        time_unit = "1 hour",
                        results =  "group",
                        uniques = TRUE))


#   # wrong value passed to  results argument

  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'end_time',
                        group_var = 'bed',
                        time_unit = "1 hour",
                        results =  "grp",
                        uniques = FALSE))

# time_adjust_period with no time_adjust throws error
#
#   # time adjust value is null
#
#
  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'end_time',
                        group_var = 'bed',
                        time_unit = "1 hour",
                        time_adjust_period = 'start_sec',
                        time_adjust_value = NULL,
                        results =  "total",
                        uniques = TRUE))
#
#
#   time adjust is missing
#
  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'end_time',
                        group_var = 'bed',
                        time_unit = "1 hour",
                        time_adjust_period = 'start_sec',
                        results =  "total",
                        uniques = TRUE))

# non numeric time_adjust throws error"
#
# uniques  = TRUE when grouped results requested
#

  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'end_time',
                        group_var = 'bed',
                        time_unit = "1 hour",
                        time_adjust_period = 'start_sec',
                        time_adjust_value = '1',
                        results =  "total",
                        uniques = TRUE))



# "multiple time_adjust periods throw error"

# multiple time adjust periods


  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'end_time',
                        group_var = 'bed',
                        time_unit = "1 hour",
                        time_adjust_period = c('start_sec','start_min'),
                        time_adjust_value = 1,
                        results =  "total",
                        uniques = TRUE))

# "incorrect time_adjust periods throw error"

  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'end_time',
                        group_var = 'bed',
                        time_unit = "1 hour",
                        time_adjust_period = 'ron waffle',
                        time_adjust_value = 1,
                        results =  "total",
                        uniques = TRUE))


# non datetimetime_in column throws error


  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "bed",
                        time_out = 'end_time',
                        group_var = 'bed',
                        time_unit = "1 hour",
                        results =  "total",
                        uniques = TRUE))



# non datetime time_out column throws error"


  expect_error(juncture(beds,
                        identifier = "patient",
                        time_in = "start_time",
                        time_out = 'bed',
                        group_var = 'bed',
                        time_unit = "1 hour",
                        results =  "total",
                        uniques = TRUE))

# same start and end time causes message"
  checkDT <- data.table::data.table(bed = c("A","B"),
                        patient = c(3,4),
                        start_time = c("2020-01-01 11:34:00",
                                       "2020-01-01 11:34:00"),
                        end_time = c("2020-01-01 11:34:00",
                                     "2020-01-02 17:34:00"))

  checkDT$start_time <- lubridate::as_datetime(checkDT$start_time)
  checkDT$end_time <- lubridate::as_datetime(checkDT$end_time)


  expect_message(juncture(checkDT,
                          identifier = "patient",
                          time_in = "start_time",
                          time_out = 'end_time',
                          group_var = 'bed',
                          time_unit = "1 hour",
                          results =  "total",
                          uniques = TRUE))



  checkDT <- data.table::data.table(bed = c("A","A"),
                        patient = c(3,3),
                        start_time = c("2020-01-01 11:34:00",
                                       "2020-01-01 11:34:00"),
                        end_time = c("2020-01-02 17:34:00",
                                     "2020-01-02 17:34:00"),
                        interval_beginning = c("2020-01-01","2020-01-02"),
                        interval_end = c("2020-01-02","2020-01-03"),
                        base_date = c('2020-01-01','2020-01-02'),
                        base_hour = c(0,0))

  checkDT$start_time <- lubridate::as_datetime(checkDT$start_time)
  checkDT$end_time <- lubridate::as_datetime(checkDT$end_time)
  checkDT$interval_beginning <- lubridate::as_datetime(checkDT$interval_beginning)
  checkDT$interval_end <- lubridate::as_datetime(checkDT$interval_end)
  checkDT$base_date <- data.table::as.IDate(checkDT$base_date)


  data.table::setkey(checkDT, interval_beginning, interval_end)

  test_res <- juncture(beds[beds$patient == 3,],
                       identifier = 'patient',
                       time_in = 'start_time',
                       time_out  = 'end_time',
                       time_unit = '1 day',
                       results = 'individual')


  expect_equivalent(test_res, checkDT)

 # "`juncture function` returns expected grouped data.frame"

  checkDT2 <- data.table::data.table(bed = c("A","A"),
                         interval_beginning = c("2020-01-01","2020-01-02"),
                         interval_end = c("2020-01-02","2020-01-03"),
                         base_date = c('2020-01-01','2020-01-02'),
                         base_hour = c(0,0),
                         N = c(1,1))

  checkDT2$interval_beginning <- lubridate::as_datetime(checkDT2$interval_beginning)
  checkDT2$interval_end <- lubridate::as_datetime(checkDT2$interval_end)
  checkDT2$base_date <- data.table::as.IDate(checkDT2$base_date)


  data.table::setkey(checkDT2, interval_beginning, interval_end)

  test_res2 <- juncture(beds[beds$patient == 3,],
                               identifier = 'patient',
                               time_in = 'start_time',
                               time_out  = 'end_time',
                               time_unit = '1 day',
                               group_var = 'bed',
                               results = 'group',
                               uniques = FALSE)


  expect_equivalent(test_res2, checkDT2)



# "`juncture function` returns expected totals data.frame"


checkDT3 <- data.table::data.table(interval_beginning = c("2020-01-01","2020-01-02"),
                           interval_end = c("2020-01-02","2020-01-03"),
                           base_date = c('2020-01-01','2020-01-02'),
                           base_hour = c(0,0),
                           N = c(1,1))

checkDT3$interval_beginning <- lubridate::as_datetime(checkDT3$interval_beginning)
checkDT3$interval_end <- lubridate::as_datetime(checkDT3$interval_end)
checkDT3$base_date <- data.table::as.IDate(checkDT3$base_date)


data.table::setkey(checkDT3, interval_beginning, interval_end)

test_res3 <- juncture(beds[beds$patient == 3,],
                                 identifier = 'patient',
                                 time_in = 'start_time',
                                 time_out  = 'end_time',
                                 time_unit = '1 day',
                                 results = 'total')


expect_equivalent(test_res3, checkDT3)



# check time adjust values


  # start_min

  checkDT <- data.table::data.table(bed = c("A","A"),
                        patient = c(3,3),
                        start_time = c("2020-01-01 11:34:00",
                                       "2020-01-01 11:34:00"),
                        end_time = c("2020-01-02 17:34:00",
                                     "2020-01-02 17:34:00"),
                        interval_beginning = c("2020-01-01 00:01:00","2020-01-02 00:01:00"),
                        interval_end = c("2020-01-02","2020-01-03"),
                        base_date = c('2020-01-01','2020-01-02'),
                        base_hour = c(0,0))

  checkDT$start_time <- lubridate::as_datetime(checkDT$start_time)
  checkDT$end_time <- lubridate::as_datetime(checkDT$end_time)
  checkDT$interval_beginning <- lubridate::as_datetime(checkDT$interval_beginning)
  checkDT$interval_end <- lubridate::as_datetime(checkDT$interval_end)
  checkDT$base_date <- data.table::as.IDate(checkDT$base_date)

  data.table::setkey(checkDT, interval_beginning, interval_end)

  test_res <- juncture(beds[beds$patient == 3,],
                              identifier = 'patient',
                              time_in = 'start_time',
                              time_out  = 'end_time',
                              time_unit = '1 day',
                              time_adjust_period = 'start_min',
                              time_adjust_value = 1,
                              results = 'individual')


  expect_equivalent(test_res,checkDT)



  # end_min

  checkDT <- data.table::data.table(bed = c("A","A"),
                        patient = c(3,3),
                        start_time = c("2020-01-01 11:34:00",
                                       "2020-01-01 11:34:00"),
                        end_time = c("2020-01-02 17:34:00",
                                     "2020-01-02 17:34:00"),
                        interval_beginning = c("2020-01-01","2020-01-02"),
                        interval_end = c("2020-01-01 23:59:00","2020-01-02 23:59:00"),
                        base_date = c('2020-01-01','2020-01-02'),
                        base_hour = c(0,0))

  checkDT$start_time <- lubridate::as_datetime(checkDT$start_time)
  checkDT$end_time <- lubridate::as_datetime(checkDT$end_time)
  checkDT$interval_beginning <- lubridate::as_datetime(checkDT$interval_beginning)
  checkDT$interval_end <- lubridate::as_datetime(checkDT$interval_end)
  checkDT$base_date <- data.table::as.IDate(checkDT$base_date)

  data.table::setkey(checkDT, interval_beginning, interval_end)

  test_res <- juncture(beds[beds$patient == 3,],
                              identifier = 'patient',
                              time_in = 'start_time',
                              time_out  = 'end_time',
                              time_unit = '1 day',
                              time_adjust_period = 'end_min',
                              time_adjust_value = 1,
                              results = 'individual')


  expect_equivalent(test_res,checkDT)




  # end_sec

  checkDT <- data.table::data.table(bed = c("A","A"),
                        patient = c(3,3),
                        start_time = c("2020-01-01 11:34:00",
                                       "2020-01-01 11:34:00"),
                        end_time = c("2020-01-02 17:34:00",
                                     "2020-01-02 17:34:00"),
                        interval_beginning = c("2020-01-01","2020-01-02"),
                        interval_end = c("2020-01-01 23:59:58","2020-01-02 23:59:58"),
                        base_date = c('2020-01-01','2020-01-02'),
                        base_hour = c(0,0))

  checkDT$start_time <- lubridate::as_datetime(checkDT$start_time)
  checkDT$end_time <- lubridate::as_datetime(checkDT$end_time)
  checkDT$interval_beginning <- lubridate::as_datetime(checkDT$interval_beginning)
  checkDT$interval_end <- lubridate::as_datetime(checkDT$interval_end)
  checkDT$base_date <- data.table::as.IDate(checkDT$base_date)

  data.table::setkey(checkDT, interval_beginning, interval_end)

  test_res <- juncture(beds[beds$patient == 3,],
                              identifier = 'patient',
                              time_in = 'start_time',
                              time_out  = 'end_time',
                              time_unit = '1 day',
                              time_adjust_period = 'end_sec',
                              time_adjust_value = 2,
                              results = 'individual')


  expect_equivalent(test_res,checkDT)



  # start_sec

  checkDT <- data.table::data.table(bed = c("A","A"),
                        patient = c(3,3),
                        start_time = c("2020-01-01 11:34:00",
                                       "2020-01-01 11:34:00"),
                        end_time = c("2020-01-02 17:34:00",
                                     "2020-01-02 17:34:00"),
                        interval_beginning = c("2020-01-01 00:00:05","2020-01-02 00:00:05"),
                        interval_end = c("2020-01-02","2020-01-03"),
                        base_date = c('2020-01-01','2020-01-02'),
                        base_hour = c(0,0))

  checkDT$start_time <- lubridate::as_datetime(checkDT$start_time)
  checkDT$end_time <- lubridate::as_datetime(checkDT$end_time)
  checkDT$interval_beginning <- lubridate::as_datetime(checkDT$interval_beginning)
  checkDT$interval_end <- lubridate::as_datetime(checkDT$interval_end)
  checkDT$base_date <- data.table::as.IDate(checkDT$base_date)

  data.table::setkey(checkDT, interval_beginning, interval_end)

  test_res <- juncture(beds[beds$patient == 3,],
                              identifier = 'patient',
                              time_in = 'start_time',
                              time_out  = 'end_time',
                              time_unit = '1 day',
                              time_adjust_period = 'start_sec',
                              time_adjust_value = 5,
                              results = 'individual')


  expect_equivalent(test_res,checkDT)


  test_na <- juncture(beds[beds$patient == 10,],
                             identifier = 'patient',
                             time_in = 'start_time',
                             time_out  = 'end_time',
                             time_unit = '1 day',
                             results = 'individual')


  expect_false(anyNA(test_na$end_time))



curr_time <- lubridate::ceiling_date(Sys.time(), '1 hour')
if (lubridate::hour(curr_time) == 0) {
    curr_time <- curr_time + lubridate::hours(1)
    }
curr_time <- lubridate::ymd_hms(curr_time)

max_adm_date <- as.POSIXct('2021-11-02 15:34:00')
max_dis_date <-  as.POSIXct('2021-11-01 15:34:00')

maxdate <- if (max_adm_date > max_dis_date) {
  maxdate <- curr_time
  } else {
    maxdate <- max_dis_date
    }

expect_equivalent(maxdate,curr_time)
