defmodule ConcCalendar.DayCreator do
  use Timex

  def create_day_tuple(day) do
    day_data = {day, "", ""}
    spawn(ConcCalendar.DayCreator, :day_tuple, [day_data])
  end

  def day_tuple(day_data) do
    {day, schedule, note} = day_data

    receive do
      {:schedule_a_meeting, sender} ->
        if schedule == "" do
          send sender, {:ok, "Successfully created a meeting"}
        else
          send sender, {:ok, "There is a meeting scheduled already"}
        end

        day_tuple({day, "*", note})

      {:cancel_a_meeting, sender} ->
        send sender, {:ok, "The meeting was canceled"}
        day_tuple({day, "", note})

      {:make_a_note, new_note, sender} ->
        send sender, {:ok, "Succesfully created a note"}
        day_tuple({day, schedule, new_note})

      {:delete_note, sender} ->
        send sender, {:ok, "The note was deleted"}
        day_tuple({day, schedule, ""})

      {:get_note, sender} ->
        send sender, {:ok, note}
        day_tuple(day_data)

    end
  end
end
