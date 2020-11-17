defmodule JalamaScrapper.Job do
  require Logger

  def perform(_retry = 0), do: JalamaScrapper.Email.site_not_reachable()

  def perform(retry) do
    Logger.info("Job starting...")
    try do
      JalamaScrapper.SiteChecker.init()
    catch
      :exit, _ ->
        Logger.info("Retrying job...")
        :timer.sleep(3000)
        perform(retry - 1)
    end
  end
end