require 'json_api_client'

class GithubAPI
  GITHUB_API_URL = 'https://api.github.com'.freeze

  def repos(user:)
    UrlJsonFetcher.fetch_all_pages(url: GITHUB_API_URL + "/users/#{user}/repos")
  end 
end
