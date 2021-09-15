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


# missing df argument causes error",
expect_error(juncture(df = NULL,
                              identifier = 'pat_id',
                              time_in = "admit_date",
                              time_out = "discharge_date",
                              group_var = "location",
                              time_unit = "1 hour",
                              results = "individual",
                              uniques = TRUE))


# df not specified
expect_error(juncture(identifier = 'pat_id',
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
                             time_in = "admit_date",
                              time_out = "discharge_date",
                              group_var = "location",
                              time_unit = "1 hour",
                              results = "patient",
                              uniques = TRUE))


#
#
#
# # missing time_in
#
# test_that(" missing time_in argument throws error", {
#
#   # missingtime_in
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                               time_out = "end_time",
#                               group_var = "bed",
#                               time_unit = "1 hour",
#                               results =  "total",
#                               uniques = TRUE),
#               throws_error())
#
#
# })
#
#
# test_that(" missing time_out argument throws error", {
#
#   # missing time_out
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               group_var = "bed",
#                               time_unit = "1 hour",
#                               results =  "total",
#                               uniques = TRUE),
#               throws_error())
#
#
# })
#
#
#
# test_that("grouped results with no group_var throws error", {
#
#   # missing group_var when grouped results required
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               time_out = 'end_time',
#                               group_var = NULL,
#                               time_unit = "1 hour",
#                               results =  "group",
#                               uniques = FALSE),
#               throws_error())
#
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               time_out = 'end_time',
#                               time_unit = "1 hour",
#                               results =  "group",
#                               uniques = FALSE),
#               throws_error())
#
#
#
# })
#
#
#
#
# test_that("grouped results with uniques = TRUE throws error", {
#
#   # uniques  = TRUE when grouped results requested
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               time_out = 'end_time',
#                               group_var = 'bed',
#                               time_unit = "1 hour",
#                               results =  "group",
#                               uniques = TRUE),
#               throws_error())
#
#
# })
#
#
#
#
# test_that("grouped result defined incorrectly throws error", {
#
#   # wrong value passed to  results argument
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               time_out = 'end_time',
#                               group_var = 'bed',
#                               time_unit = "1 hour",
#                               results =  "grp",
#                               uniques = FALSE),
#               throws_error())
#
#
# })
#
#
# test_that("time_adjust_period with no time_adjust throws error", {
#
#   # time adjust value is null
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               time_out = 'end_time',
#                               group_var = 'bed',
#                               time_unit = "1 hour",
#                               time_adjust_period = 'start_sec',
#                               time_adjust_value = NULL,
#                               results =  "total",
#                               uniques = TRUE),
#               throws_error())
#
#
#   # time adjust is missing
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               time_out = 'end_time',
#                               group_var = 'bed',
#                               time_unit = "1 hour",
#                               time_adjust_period = 'start_sec',
#                               results =  "total",
#                               uniques = TRUE),
#               throws_error())
#
#
#
# })
#
#
#
#
#
# test_that("non numeric time_adjust throws error", {
#
#   # uniques  = TRUE when grouped results requested
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               time_out = 'end_time',
#                               group_var = 'bed',
#                               time_unit = "1 hour",
#                               time_adjust_period = 'start_sec',
#                               time_adjust_value = '1',
#                               results =  "total",
#                               uniques = TRUE),
#               throws_error())
#
#
# })
#
#
#
# test_that("multiple time_adjust periods throw error", {
#
#   # multiple time adjust periods
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               time_out = 'end_time',
#                               group_var = 'bed',
#                               time_unit = "1 hour",
#                               time_adjust_period = c('start_sec','start_min'),
#                               time_adjust_value = 1,
#                               results =  "total",
#                               uniques = TRUE),
#               throws_error())
#
#
# })
#
#
# test_that("incorrect time_adjust periods throw error", {
#
#
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               time_out = 'end_time',
#                               group_var = 'bed',
#                               time_unit = "1 hour",
#                               time_adjust_period = 'ron waffle',
#                               time_adjust_value = 1,
#                               results =  "total",
#                               uniques = TRUE),
#               throws_error())
#
#
# })
#
#
#
#
#
# test_that("non datetimetime_in column throws error", {
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "bed",
#                               time_out = 'end_time',
#                               group_var = 'bed',
#                               time_unit = "1 hour",
#                               results =  "total",
#                               uniques = TRUE),
#               throws_error())
#
#
# })
#
#
#
# test_that("non datetime time_out column throws error", {
#
#
#   expect_that(juncture(beds,
#                               identifier = "patient",
#                              time_in = "start_time",
#                               time_out = 'bed',
#                               group_var = 'bed',
#                               time_unit = "1 hour",
#                               results =  "total",
#                               uniques = TRUE),
#               throws_error())
#
#
# })
#
#
#
# test_that("same start and end time causes message", {
#   checkDT <- data.table(bed = c("A","B"),
#                         patient = c(3,4),
#                         start_time = c("2020-01-01 11:34:00",
#                                        "2020-01-01 11:34:00"),
#                         end_time = c("2020-01-01 11:34:00",
#                                      "2020-01-02 17:34:00"))
#
#   checkDT$start_time <- lubridate::as_datetime(checkDT$start_time)
#   checkDT$end_time <- lubridate::as_datetime(checkDT$end_time)
#
#
#   expect_message(juncture(checkDT,
#                                  identifier = "patient",
#                                 time_in = "start_time",
#                                  time_out = 'end_time',
#                                  group_var = 'bed',
#                                  time_unit = "1 hour",
#                                  results =  "total",
#                                  uniques = TRUE))
#
#
#
#
# })
