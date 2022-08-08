defmodule JalamaScraper.Email do
  @email_recipients [
    "paultannenbaum@gmail.com",
    # "mike@channelislandso.com",
    # "jason@schabitatrestoration.org",
    # "tommy.riparetti@gmail.com",
    # "jayswain@gmail.com"
  ]

  def report(sites) do
    SendGrid.Email.build()
    |> add_recipients()
    |> add_email_details()
    |> SendGrid.Email.put_html(report_html(sites))
    |> SendGrid.Mail.send()
  end

  def site_not_reachable do
    SendGrid.Email.build()
    |> add_recipients()
    |> add_email_details()
    |> SendGrid.Email.put_html("<p>Site was not reachable or some kind of other failure happened</p>")
    |> SendGrid.Mail.send()
  end

  defp add_recipients(email) do
    Enum.each(@email_recipients, fn recipient -> SendGrid.Email.add_to(email, recipient) end)
  end

  defp add_email_details(email) do
    SendGrid.Email.put_from(email, "noreply@baumerdesigns.com")
    |> SendGrid.Email.put_subject("Jalama Campground Report")
  end

  defp date_html do
    arrive_date = JalamaScraper.Helpers.six_months_from_today()

    "<p>This report is automatically checking the <a href='https://reservations.sbparks.org/reservation/camping/index.asp'/>Jalama website</a> six months from today for an arrival date of #{arrive_date}</p>"
  end

  defp beach_sites_html(sites) do
    beach_sites = sites
    |> Enum.filter(fn s ->
      try do
        site_no = String.to_integer(s)
        site_no >= 53 and site_no <= 64
      catch
        _, _ ->
         s === "abalone"
      end
    end)

    _beach_sites_html = case beach_sites do
      [] ->
        "<h2>NO BEACH SITES AVAILABLE</h2>"
      _ ->
        "<h2>AVAILABLE BEACH SITES:</h2>
         <ul>
          #{Enum.map(beach_sites, fn x -> "<li>#{x}</li>" end)}
         </ul>
        "
    end
  end

  defp all_sites_html(sites) do
    _total_sites_html = case sites do
      [] ->
        "<h2>NO SITES AVAILABLE</h2>"
      _ ->
        "<h2>AVAILABLE SITES:</h2>
         <ul>
          #{Enum.map(sites, fn x -> "<li>#{x}</li>" end)}
         </ul>
        "
    end
  end

  defp report_html(sites) do
    "#{date_html()}#{beach_sites_html(sites)}#{all_sites_html(sites)}"
  end
end
