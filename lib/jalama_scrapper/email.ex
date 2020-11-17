defmodule JalamaScrapper.Email do
  def report(available_beach_sites, available_total_sites) do
    beach_sites_html = case available_beach_sites do
      [] ->
        "<h2>NO BEACH SITES AVAILABLE</h2>"
      _ ->
        "<h2>AVAILABLE BEACH SITES:</h2>
         <ul>
          #{Enum.map(available_beach_sites, fn x -> "<li>#{x}</li>" end)}
         </ul>
        "
    end

    total_sites_html = case available_total_sites do
      [] ->
        "<h2>NO SITES AVAILABLE</h2>"
      _ ->
        "<h2>AVAILABLE SITES:</h2>
         <ul>
          #{Enum.map(available_total_sites, fn x -> "<li>#{x}</li>" end)}
         </ul>
        "
    end

    SendGrid.Email.build()
    |> SendGrid.Email.add_to("paultannenbaum@gmail.com")
    |> SendGrid.Email.put_from("noreply@baumerdesigns.com")
    |> SendGrid.Email.put_subject("Jalama Campground Report")
    |> SendGrid.Email.put_html("#{beach_sites_html}#{total_sites_html}")
    |> SendGrid.Mail.send()
  end

  def site_not_reachable do
    SendGrid.Email.build()
    |> SendGrid.Email.add_to("paultannenbaum@gmail.com")
    |> SendGrid.Email.put_from("noreply@baumerdesigns.com")
    |> SendGrid.Email.put_subject("Jalama Campground Report")
    |> SendGrid.Email.put_html("<p>Bot failure. Site was not reachable or some kind of other failure happened</p>")
    |> SendGrid.Mail.send()
  end
end
