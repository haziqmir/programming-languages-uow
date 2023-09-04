fun is_older (date_a: int*int*int, date_b: int*int*int) =
    if (#1 date_a) < (#1 date_b) then true
    else if (#2 date_a) < (#2 date_b) then true
    else if (#3 date_a) < (#3 date_b) then true
    else false

fun number_in_month (dates: (int*int*int) list, month: int) =
    if null dates then 0
    else if ((#2 (hd dates)) = month) then 1 + number_in_month(tl dates, month)
    else number_in_month(tl dates, month)

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
        val filtered_months xs =
            if null xs
                then []
            else
                
    in
        number_in_months(dates, filtered_months)
    end
