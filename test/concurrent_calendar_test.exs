defmodule ConcurrentCalendarTest do
  use ExUnit.Case
  doctest ConcurrentCalendar

  test "greets the world" do
    assert ConcurrentCalendar.hello() == :world
  end
end
