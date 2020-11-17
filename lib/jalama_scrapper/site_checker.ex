defmodule JalamaScrapper.SiteChecker do
  alias Mechanize.Browser
  alias Mechanize.Form
  alias Mechanize.Page
  alias Mechanize.Page.Element
  require Logger

  def init do
    Logger.info("Starting Application...")
    perform(5)
  end

  defp perform(_retry = 0), do: JalamaScrapper.Email.site_not_reachable()

  defp perform(retry) do
    browser = Browser.new()

    try do
      _response = browser
      |> visit_parks_page
      |> visit_jalama_page
      |> choose_dates
      |> list_available_sites
      |> send_email_report
    catch
      :exit, _ ->
        Logger.info("Retrying job...")
        :timer.sleep(3000)
        perform(retry - 1)
    end
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
    Page.search(page, "div.row.card-col.ui-widget-content")
    |> Enum.map(fn elem ->
      Element.attr(elem, :"data-id")
      |> String.to_integer
      |> get_site_number
    end)
  end

  defp send_email_report(available_sites) do
    Logger.info("Sending Email Report")
    available_beach_sites = available_sites |> Enum.filter(fn s -> s >= 53 and s <= 64 end)
    JalamaScrapper.Email.report(available_beach_sites, available_sites)
  end

  defp format_date(date) do
    {:ok, formatted_date} = Timex.format(date, "%m/%d/%Y", :strftime)
    formatted_date
  end

  defp get_site_number(site_id) when site_id >= 1819 and site_id <= 1841, do: site_id - 1766
  defp get_site_number(site_id) when site_id <= 1841, do: site_id - 1764
  defp get_site_number(site_id) when site_id >= 1861, do: site_id - 1756
  defp get_site_number(_), do: 0
end
