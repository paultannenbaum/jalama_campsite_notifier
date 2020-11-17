defmodule JalamaScrapper.SiteChecker do
  alias Mechanize.Browser
  alias Mechanize.Form
  alias Mechanize.Page
  alias Mechanize.Page.Element
  require Logger

  def init do
    Logger.info("Starting Application...")
    browser = Browser.new()

    _response = browser
      |> visit_parks_page
      |> visit_jalama_page
      |> choose_dates
      |> list_available_sites
      |> send_email_report
  end

  defp visit_parks_page(browser) do
    Logger.info("Visiting SB Parks")
    Browser.get!(browser, "https://reservations.sbparks.org/reservation/camping/index.asp")
  end

  defp visit_jalama_page(page) do
    Logger.info("Choosing Jalama Beach Park")
    Page.form_with(page, name: "reserve_form")
    |> Form.select(name: "parent_idno", option: [value: "2"])
    |> Form.submit!
  end

  defp choose_dates(page) do
    arrive_date =
      Timex.now("America/Los_Angeles")
      |> Timex.shift(months: 6)
      |> format_date
    depart_date =
      Timex.now("America/Los_Angeles")
      |> Timex.shift(months: 6, days: 2)
      |> format_date

    Logger.info("Choosing dates of #{arrive_date} - #{depart_date}")
    Page.form_with(page, name: "reserve_form")
    |> Form.fill_text(name: "arrive_date", with: arrive_date)
    |> Form.fill_text(name: "depart_date", with: depart_date)
    |> Form.submit!
  end

  defp list_available_sites(page) do
    Logger.info("Listing Available Sites")
    Page.search(page, "span.ghost_title.panto-coordinates")
    |> Enum.map(&Element.text/1)
    |> Enum.map(&String.replace(&1, "Site:", ""))
    |> Enum.map(&String.replace(&1, "Jalama Beach", ""))
    |> Enum.map(&String.trim/1)
    |> IO.inspect
  end

  defp send_email_report(available_sites) do
    Logger.info("Sending Email Report")
    JalamaScrapper.Email.report(available_sites)
  end

  defp format_date(date) do
    {:ok, formatted_date} = Timex.format(date, "%m/%d/%Y", :strftime)
    formatted_date
  end
end
