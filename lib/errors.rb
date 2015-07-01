module JsonApiClient
  class Error < StandardError
    attr_reader :headers
    
    def initialize(headers:, message:)
      super(message)
      @headers = headers
    end
  end

  # Raised when API returns a 404 Not Found
  class NotFound < Error; end

  # Raised when API returns a 403 Forbidden with ratelimit remaining zero
  class RateLimitExceeded < Error; end
end
