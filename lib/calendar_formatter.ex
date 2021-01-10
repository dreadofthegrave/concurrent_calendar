defmodule ConcCalendar.Formatter do
  use Timex, TableRex

  def print_calendar(days) do
    month_name = "Jan"
    TableRex.quick_render!(days)
    |> IO.puts
  end

  def print_month do

  end

  def month_manager(month, year) do
    days_in_month = 1..:calendar.last_day_of_the_month(year, month)
    days = Enum.map(days_in_month, &ConcCalendar.DayCreator.create_day_tuple/1)
    #month_list = Enum.
    #month_list = for x <- 1..days_in_month, do: x
    #rows = Enum.chunk_every(month_list, 7)
    #print_calendar(rows)
  end

  def day_manager(pid) do
    #todo
    #communicating with day creator: getting day no. and its data -> managing and passing this data to month manager
  end
end
