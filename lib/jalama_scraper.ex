defmodule JalamaScraper do
  alias Mechanize.Browser
  alias Mechanize.Form
  alias Mechanize.Form.TextInput
  alias Mechanize.Page
  alias Mechanize.Page.Element
  
  @moduledoc """
  Documentation for `JalamaScraper`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> JalamaScraper.hello()
      :world

  """
  def init do
    browser = Browser.new()
    
    browser
    |> visit_parks_page
    |> visit_jalama_page
    |> choose_dates
  end

  defp visit_parks_page(browser) do
    Browser.get!(browser, "https://reservations.sbparks.org/reservation/camping/index.asp")
  end

  defp visit_jalama_page(page) do
    Page.form_with(page, name: "reserve_form")
    |> Form.select(name: "parent_idno", option: [value: "2"])
    |> Form.submit!
  end

  defp choose_dates(page) do
    form = Page.form_with(page, name: "reserve_form")
    
    TextInput.text_inputs_with(form, name: "arrive_date")
    |> IO.inspect
  end
end
