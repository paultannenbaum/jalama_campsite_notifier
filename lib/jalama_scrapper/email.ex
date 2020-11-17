defmodule JalamaScrapper.Email do
  def report(sites) do

    SendGrid.Email.build()
    |> SendGrid.Email.add_to("paultannenbaum@gmail.com")
    |> SendGrid.Email.put_from("noreply@baumerdesigns.com")
    |> SendGrid.Email.put_subject("Jalama Campground Report")
    |> SendGrid.Email.put_html("#{beach_sites_html(sites)}#{all_sites_html(sites)}")
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

    case beach_sites do
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
    total_sites_html = case sites do
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
end
