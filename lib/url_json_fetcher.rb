# use OpenURI with caution:
# http://sakurity.com/blog/2015/02/28/openuri.htmlrequire 'open-uri'
require 'json'

class UrlJsonFetcher
  # Fetches all pages for the given url.
  # Information about pagination is provided in the Link header of an API call.
  # Example:
  # Link: <https://api.github.com/search/code?q=addClass+user%3Amozilla&page=2>; rel="next"
  #   <https://api.github.com/search/code?q=addClass+user%3Amozilla&page=34>; rel="last"
  #
  # Returns JSON parsed response body
  def self.fetch_all_pages(url:)
    headers, body = fetch_page(url: url)

    resources = JSON.parse(body)
    while url = next_page(headers: headers) do
      headers, body = fetch_page(url: url)
      resources << JSON.parse(body)
    end

    resources
  end

  private

    # Fetches a single page for the given url.
    #
    # Returns a header, body pair of response
    def self.fetch_page(url:)
      res = open(URI(url))
      [res.meta, res.read]
    end

    # Finds next page from 'Link' response header
    #
    # Returns a url of next page
    def self.next_page(headers:)
      link = (headers["Link"] || "").split(', ').map do |link|
        href, name = link.match(/<(.*?)>; rel="(\w+)"/).captures
        return href if name == 'next'
      end

      nil
    end
end
