#' Count the number of resources by interval
#'
#' Counts the number of resources in each location, by the specified interval, for the duration of the resources admission.
#' Results can be returned as grand totals, grouped totals, or at individual resource level per interval.
#'
#' @param df dataframe, tibble or data.table.
#' @param identifier Unique row / resource/ person identifier.
#' @param time_in Datetime of time_in as POSIXct.
#' @param time_out Datetime of time_out as POSIXct.
#' @param group_var Optional unique character vector to identify specific resources
#' location or responsible clinician at each interval, or at time of a change in
#' location / responsible clinician during the interval.
#'
#' @param time_unit Character string to denote time intervals to count by e.g.
#' "1 hour", "15 mins".
#' @param time_adjust_period Optional argument which allows
#' the user to obtain a snapshot at a specific time of day by making slight
#' adjustments  to the specified interval.
#' Possible values are "start_sec","start_min","end_sec", or "end_min".
#' For example, you may specify hourly intervals, but adjust these
#' to 1 minute past the hour with "start_min", or several seconds before the
#' end with "end_sec".
#'
#' @param time_adjust_value Optional. An integer to adjust the start or  end of
#' each period in minutes or seconds, depending on the  chosen
#' time_adjust_period (if specified).
#'
#' @param results A character string specifying the granularity of the results.
#'
#' 'individual' returns one row per resource or person, group_var and interval. The results
#' can be input to external tools for further analysis or visualisation.
#'
#' 'group' provides an overall grouped count of resources by the specified time
#' interval.
#'
#' 'total' returns the grand total of resources  by each unique time interval.
#'
#' @param uniques Logical. Specifies how to deal with resources which move during
#' an interval, and subsequently have two or more records per interval.
#' Set "uniques" to TRUE to get a distinct count of resources per interval.
#' To be clear, TRUE will count resources only once per interval.
#'
#' Setting "uniques" to  FALSE will count each resource entry per interval.
#' If a resource moves during an interval then at least two rows will be returned
#' for that resource for that particular interval.
#' This is useful if you want to count occupied beds, or track moves  or
#' transfers between departments.
#'
#' In general, if you use a grouping variable, set "uniques" to FALSE.
#'
#' @return data.table showing the resource identifier, the specified group
#' variable , and  the count by  the relevant unit of time.
#' Also included are the start and end of the interval, plus the date and
#' base hour for convenient interactive filtering of the results.
#'
#' @import data.table
#' @importFrom lubridate floor_date ceiling_date seconds minutes date force_tz
#' @importFrom lubridate ymd_hms
#' @importFrom utils head tail
#' @importFrom checkmate check_data_frame assert_choice check_character
#' check_vector check_posixct
#' @export
#'
#' @examples
#' \donttest{
#'juncture(beds, identifier ="patient", time_in = "start_time",
#'time_out = "end_time", time_unit = "1 hour", results = "total")
#'
#'juncture(beds, identifier ="patient", time_in = "start_time",
#'time_out = "end_time", time_unit = "1 hour", results = "individual")
#'
#'juncture(beds, identifier ="patient", time_in = "start_time",
#'time_out = "end_time", group_var = "bed",
#'time_unit = "1 hour", results = "group", uniques = FALSE)
#'
#' }
#'
#'
juncture <- function(df,
                     identifier,
                     time_in,
                     time_out,
                     group_var = NULL,
                     time_unit = "1 hour",
                     time_adjust_period = NULL,
                     time_adjust_value = NULL,
                     results = c("individual", "group", "total"),
                     uniques = TRUE) {


  # global variables
  interval_beginning <- interval_end <- NULL
  join_end <- join_start <- NULL
  base_date <- base_hour <- NULL
  curr_time <- NULL
  i.join_start <- i.join_end <- NULL


  check_data_frame(df, null.ok = FALSE)
  check_vector(identifier, null.ok =  FALSE)
  check_posixct(time_in, null.ok =  FALSE)
  check_posixct(time_out, null.ok =  FALSE)
  check_character(group_var, null.ok = TRUE)
  assert_choice(results, choices = c("individual", "group","total"))

  if (results == "group" & missing(group_var)) {
    stop("Please provide a value for the group_var column")
  }

  if (results == "grp" ) {
    stop('"Please check the value provided to the "results" argument.
         Do you mean "group"?"', call. = FALSE)
  }

  if (results == "group" & uniques) {
    uniques <- FALSE
    message("Results requested at group level, so changing uniques to FALSE for accurate counts")
  }


  if (!is.null(time_adjust_period) & length(time_adjust_period) > 1)  {
    stop('"Too many values passed to "time_adjust_period" argument.
         Please set time_adjust_period to one of "start_sec","start_min","end_sec" or "end_min"',
         call. = FALSE)
  }

  if (!is.null(time_adjust_period) & is.null(time_adjust_value))  {
    stop('"Please provide a value for the time_adjust argument"', call. = FALSE)
  }

  if (!is.null(time_adjust_period) & !is.numeric(time_adjust_value)) {
    stop("time_adjust_value should be numeric, not a string")
  }

  pat_DT <- copy(df)
  setDT(pat_DT)

  .confounding <- pat_DT[get(time_in) == get(time_out),.N]
  if (.confounding > 0) {
    message(paste0('There were ',.confounding,' ',
                   'records with identical time_in and time_out date times.
                   \n These records have been ignored in the analysis'))
  }


  curr_time <- lubridate::ceiling_date(Sys.time(),time_unit)
  if (lubridate::hour(curr_time) == 0) {
    curr_time <- curr_time + lubridate::hours(1)
  }
  curr_time <- lubridate::ymd_hms(curr_time)




  if (all(is.na(pat_DT[[time_out]]))) {
    #stop("Please ensure at least one row has a time_out datetime")
    setnafill(pat_DT, type = "const", fill = curr_time, cols = time_out)
  } else {

    # assign current max date to any admissions with no time_out date
    maxdate <- max(pat_DT[[time_out]], na.rm = TRUE)
    setnafill(pat_DT, type = "const", fill = maxdate, cols = time_out)
  }


  pat_DT[["join_start"]] <- lubridate::floor_date(pat_DT[[time_in]],unit = time_unit)
  pat_DT[["join_end"]] <- lubridate::ceiling_date(pat_DT[[time_out]],unit = time_unit)


  mindate <- min(pat_DT[["join_start"]],na.rm = TRUE)
  max_adm_date <- max(pat_DT[["join_start"]],na.rm = TRUE)

  max_dis_date <- max(pat_DT[["join_end"]],na.rm = TRUE)

  maxdate <- if (max_adm_date > max_dis_date) {

    maxdate <- curr_time
  } else {
    maxdate <- max_dis_date
  }

  if (max(pat_DT[["join_start"]],na.rm = TRUE) > max(pat_DT[["join_end"]],na.rm = TRUE)) {
    pat_DT[join_start > join_end, join_end := maxdate]
  }

  ts <- seq(mindate,maxdate, by = time_unit)

  ref <- data.table(join_start = head(ts, -1L), join_end = tail(ts, -1L),
                    key = c("join_start", "join_end"))

  # check for final adjustments


  if (!is.null(time_adjust_period)) {

    if (!time_adjust_period %in% c('start_sec','start_min','end_sec','end_min')) {
      stop("Incorrect value passed to time_adjust_period_argument")
    }

    if (time_adjust_period == 'start_sec') {

      pat_DT[,join_start := join_start + lubridate::seconds(time_adjust_value)]
      ref[,join_start := join_start + lubridate::seconds(time_adjust_value)]


    } else if (time_adjust_period == 'start_min') {

      pat_DT[,join_start := join_start + lubridate::minutes(time_adjust_value)][]

      ref[,join_start := join_start + lubridate::minutes(time_adjust_value)][]

    } else if (time_adjust_period == 'end_sec') {

      pat_DT[,join_end := join_end - lubridate::seconds(time_adjust_value)][]
      ref[,join_end := join_end - lubridate::seconds(time_adjust_value)][]

    } else if (time_adjust_period == "end_min") {

      pat_DT[,join_end := join_end - lubridate::minutes(time_adjust_value)][]
      ref[,join_end := join_end - lubridate::minutes(time_adjust_value)][]
    }

  }

  # out_of_zone <- ref[join_start > join_end,.N][]
  #
  # if (out_of_zone >= 1) {
  #   message(paste0(out_of_zone,' ', "date(s) span(s) timezone changes and has / have been identified"))
  # }


  pat_DT <- pat_DT[join_start < join_end,][]
  ref <- ref[join_start < join_end,][]


  setkey(pat_DT,join_start,join_end)
  setkey(ref, join_start, join_end)


  pat_res <- foverlaps(ref, pat_DT, nomatch = 0L, type = "within", mult = "all")

  .oldnames <-  c("i.join_start","i.join_end")
  .newnames <-  c("interval_beginning","interval_end")
  setnames(pat_res,
           old = .oldnames,
           new = .newnames,
           skip_absent = TRUE)

  pat_res[, `:=`(base_date = data.table::as.IDate(interval_beginning),
                 base_hour = data.table::hour(interval_beginning))][]



  pat_res[, `:=`(base_date = data.table::as.IDate(interval_beginning),
                 base_hour = data.table::hour(interval_beginning))][]

  pat_res[, c('join_start','join_end') := NULL]


  pat_res <- if (uniques) {
    unique(pat_res, by = c(identifier, "interval_beginning"))
  } else {
    pat_res
  }

  pat_res <-  if (results == "individual") {
    existing <- names(df)
    newnames <- c(existing, "interval_beginning", "interval_end",
                  "base_date", "base_hour")
    pat_res[, .SD, .SDcols = newnames][]
    return(pat_res)

  } else if (results == "group") {

    pat_res <- pat_res[, .N, .(groupvar = get(group_var),
                               interval_beginning, interval_end, base_date, base_hour)][]
    setnames(pat_res, old = "groupvar", new = group_var, skip_absent = TRUE)
    return(pat_res)

  } else {

    pat_res <-  pat_res[, .N, .(interval_beginning,interval_end, base_date, base_hour)][]
    return(pat_res)
  }
}
