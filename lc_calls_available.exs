defmodule CallsignFilter do
  @base_url "https://nrrl.no/nettbutikk/kategori/lc-kallesignaler/page/"

  def filter_callsigns(page_numbers) do
    urls = generate_urls(page_numbers)
    filtered_callsigns = Enum.flat_map(urls, fn url ->
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, callsigns} = extract_callsigns(body |> to_string)
          filter_callsigns_with_prefix(callsigns)

        {:ok, %HTTPoison.Response{status_code: _status_code}} ->
          {:error, "Failed to fetch URL: #{url}"}

        {:error, reason} ->
          {:error, "Error: #{reason}"}
      end
    end)
    unique_callsigns = Enum.uniq(filtered_callsigns)
    count = length(unique_callsigns)
    {unique_callsigns, count}
  end

  defp generate_urls(page_numbers) do
    Enum.map(page_numbers, fn page_number ->
      @base_url <> to_string(page_number)
    end)
  end

  defp extract_callsigns(body) do
    regex = ~r/[A-Za-z]{2}\d[A-Za-z]{1,3}/
    {:ok, Regex.scan(regex, body)}
  end

  defp filter_callsigns_with_prefix(callsigns) do
    Enum.filter(callsigns, fn callsign ->
      String.starts_with?(List.to_string(callsign), "LC")
    end)
  end
end

# Example usage
page_numbers = 1..17 |> Enum.to_list
{filtered_callsigns, count} = CallsignFilter.filter_callsigns(page_numbers)
Enum.each(filtered_callsigns, &IO.puts/1)
IO.puts("Total unique callsigns: #{count}")
