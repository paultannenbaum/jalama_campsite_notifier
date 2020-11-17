defmodule JalamaScraper.Helpers do
  def six_months_from_today do
    Timex.now("America/Los_Angeles")
    |> Timex.shift(months: 6)
    |> format_date
  end

  def six_months_from_today_plus_two do
    Timex.now("America/Los_Angeles")
    |> Timex.shift(months: 6, days: 2)
    |> format_date
  end

  defp format_date(date) do
    {:ok, formatted_date} = Timex.format(date, "%m/%d/%Y", :strftime)
    formatted_date
  end
end