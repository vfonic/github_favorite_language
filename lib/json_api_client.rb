# use OpenURI with caution:
# http://sakurity.com/blog/2015/02/28/openuri.htmlrequire 'open-uri'
require 'open-uri'
require 'json'
require 'errors'

# TODO: conform to JSON API spec v1.0
# http://jsonapi.org
module JsonApiClient
  # Fetches all pages for the given url.
  # Information about pagination is provided in the Link header of an API call.
  # http://tools.ietf.org/html/rfc5988
  # Example:
  # Link: <https://api.github.com/search/code?q=addClass+user%3Amozilla&page=2>; rel="next"
  #   <https://api.github.com/search/code?q=addClass+user%3Amozilla&page=34>; rel="last"
  #
  # Returns JSON parsed response body
  def JsonApiClient.fetch_all_pages(url:)
    headers, body = fetch_page(url: url)

    return nil if headers.nil? || body.nil?

    resources = JSON.parse(body)
    while url = next_page(headers: headers) do
      headers, body = fetch_page(url: url)
      resources << JSON.parse(body)
    end

    resources
  end

  # Fetches a single page for the given url.
  #
  # Returns a header, body pair of response
  def JsonApiClient.fetch_page(url:)
    begin
      res = open(URI(url))
      [res.meta, res.read]
    rescue OpenURI::HTTPError => e
      process_error e
    end
  end

  # Abstract OpenURI::HTTPErrors so we can:
  # - provide more information
  # - replace it later if needed
  #
  # Raises new error containing any additional valuable information.
  def JsonApiClient.process_error(error)
    headers = error.io.meta
    if error.message == '404 Not Found'
      raise JsonApiClient::NotFound.new(headers: headers, message: 'Not Found')
    elsif error.message == '403 Forbidden'
      # Rate Limit Remaining examples: http://stackoverflow.com/a/16022625
      ratelimit_remaining = headers["x-ratelimit-userremaining"] ||
                            headers["x-ratelimit-remaining"] ||
                            headers["x-rate-limit-remaining"]
      
      if ratelimit_remaining == 0
        ratelimit_reset = headers["x-ratelimit-reset"] ||
                          headers["x-rate-limit-reset"] ||
                          headers["x-ratelimit-userreset"]
        if ratelimit_reset
          ratelimit_reset_time = Time.at(ratelimit_reset.to_i)
          message = "Try again after #{ratelimit_reset_time}"
        else
          message = 'Rate Limit Exceeded'
        end
        api_error = JsonApiClient::RateLimitExceeded.new(headers: headers,
                                                         message: message)
        raise api_error
      end
    end
    
    raise JsonApiClient::Error.new(headers: headers, message: error.message)
  end

  # Finds next page from 'Link' response header
  #
  # Returns a url of next page
  def JsonApiClient.next_page(headers:)
    link = (headers["Link"] || "").split(', ').map do |link|
      href, name = link.match(/<(.*?)>; rel="(\w+)"/).captures
      return href if name == 'next'
    end

    nil
  end
end
