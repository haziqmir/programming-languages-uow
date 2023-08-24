fun is_older (x: int*int*int, y: int*int*int) =
    if (#1 x) < (#1 y) then true
    else if (#2 x) < (#2 y) then true
    else if (#3 x) < (#3 y) then true
    else false

fun number_in_month (dates: (int*int*int) list, month: int) =
    if null dates
    then 0
    else
      number_in_month(tl dates, month) + (if (#2 (hd dates)) = month then 1 else 0)

fun number_in_months (dates: (int*int*int) list, months: int list) =
    if null months then 0
    else number_in_month(dates, hd months) + number_in_months(dates, (tl months))

fun dates_in_month (dates: (int*int*int) list, month: int) =
    if null dates
    then []
    else if month = (#2 (hd dates))
    then (hd dates) :: dates_in_month(tl dates, month)
    else dates_in_month(tl dates, month)

fun dates_in_months (dates: (int*int*int) list, months: int list) =
    if null months
        then []
    else
        dates_in_month(dates, hd months) @ dates_in_months(dates, tl months)

fun get_nth (strs: string list, idx: int) =
    if idx = 1
        then hd strs
    else
        get_nth(tl strs, idx-1)

fun date_to_string (date: int*int*int) =
    let
        val month_names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    in
        get_nth(month_names, #2 date) ^ " " ^ (Int.toString (#3 date)) ^ ", " ^ (Int.toString (#1 date))
    end

fun number_before_reaching_sum (sum: int, lst: int list) =
    let
        fun is_sum_zero_or_less(nums, sum, idx) =
            if (sum - (hd nums)) <= 0 then idx
            else is_sum_zero_or_less(tl nums, (sum - (hd nums)), idx + 1)
    in
        is_sum_zero_or_less(lst, sum, 0)
    end

fun what_month (date: int) =
    let
        val month_lengths = [31,28,31,30,31,30,31,31,30,31,30,31]
    in 
        number_before_reaching_sum(date, month_lengths) + 1
    end

fun month_range (day1: int, day2: int) =
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1+1, day2)

fun oldest(dates: (int*int*int) list) =
    if null dates
    then NONE
    else
    let
        fun helper(dates: (int*int*int) list) =
            if null (tl dates)
            then hd dates
            else
            let 
                val current_oldest = helper(tl dates)
            in
                if is_older(hd dates, current_oldest)
                then hd dates
                else current_oldest
            end
    in
        SOME (helper dates)
    end

  fun number_in_months_challenge (dates, months) =
      let
        fun filtered_months xs =
              if null xs
                then []
              else
                let
                  fun remove (a, bs) =
                    if a = hd bs then remove(a, tl bs)
                    else hd bs :: remove(a, tl bs)
                in
                  (hd xs) :: filtered_months(remove(hd xs, tl xs))
                end
      in
          number_in_months(dates, filtered_months months)
      end
    
fun reasonable_date (date: int*int*int) =
  let 
    fun validate_year (year: int) = year > 0
    fun validate_month (month: int) = month > 0 andalso month <= 12
    fun validate_day(day: int, month: int, year: int) =
      let  
        val is_leap = year mod 4 = 0 orelse (year mod 4 = 0 andalso year mod 100 <> 0)
        val feb_length = if is_leap then 29 else 28
        val month_lengths = [31,feb_length,31,30,31,30,31,31,30,31,30,31]
        fun days_in_month(month: int, month_list: int list, idx: int) = 
          if idx = month
            then hd month_list
          else
            days_in_month(month, tl month_list, idx+1)
      in
         day > 0 andalso day <= days_in_month(month, month_lengths, 1)
      end
  in
    validate_year(#1 date) andalso validate_month(#2 date) andalso
    validate_day(#3 date, #2 date, #1 date)
  end
