defmodule ConcCalendar.Formatter do
  use Timex, TableRex

  def print_month(days, month, year) do
    header = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    months = %{1 => "January", 2 => "February", 3 => "March", 4 => "April", 5 => "May", 6 => "June", 7 => "July",
    8 => "August", 9 => "September", 10 => "October", 11 => "November", 12 => "December"}
    title = months[month] <> " #{year}"
    TableRex.quick_render!(days, header, title)
    |> IO.puts()
  end

  def year_manager(year, months) do

    receive do
      {:create_months} ->
        months = for month <- 1..12 do spawn(ConcCalendar.Formatter, :month_manager, [month, year, [], []]) end
        for month_id <- months do
          send month_id, {:create_days}
        end
        year_manager(year, months)

      {:print_month, month} ->
        month_pid = Enum.at(months, month - 1)
        send month_pid, {:print}
        year_manager(year,months)


      {:get_day_pid, month, day, sender} ->
        month_pid = Enum.at(months, month - 1)
        send month_pid, {:share_day_pid, day, sender}
        year_manager(year, months)

    end
  end

  def month_manager(month, year, days, printable) do

    receive do

      {:create_days} ->
        days_in_month = 1..:calendar.last_day_of_the_month(year, month)
        days = Enum.map(days_in_month, &ConcCalendar.DayCreator.create_day_tuple/1)
        printable = for x <- days_in_month do x end
        printable = format_printable(printable, year, month)
        month_manager(month, year, days, printable)

      {:share_day_pid, day, sender} ->
        pid = Enum.at(days, day - 1)
        send sender, {:day_id, pid}
        month_manager(month, year, days, printable)

      {:format_printable}
        printable = format_printable(printable, year, month)
        month_manager(month, year, days, printable)

      {:print} ->
        print_month(printable, month, year)
        month_manager(month, year, days, printable)

    end

  end

  defp format_printable(printable, year, month) do
    printable = Enum.sort(printable)
    first = :calendar.day_of_the_week(year, month, 1)
    IO.puts("Pierwszy dzien tygodnia miesiaca #{month} to #{first}")
    offset = first - 1
    offset_list = [""] |> List.duplicate(offset) |> List.flatten()
    printable = offset_list ++ printable
    printable = Enum.chunk_every(printable, 7)
    printable
  end

end
