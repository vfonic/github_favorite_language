require 'resource'
require 'url_json_fetcher'

class GithubAPI
  GITHUB_API_URL = 'https://api.github.com'.freeze

  def repos(user:)
    repos = UrlJsonFetcher.fetch_all_pages(url: GITHUB_API_URL + "/users/#{user}/repos" + PER_PAGE)
    repos.map { |repo| Resource.new(repo) }
  end 

  # dirty hack: reduce the need to do several requests by querying 1000
  # results per_page instead of 100
  PER_PAGE = '?per_page=1000'.freeze
  private_constant :PER_PAGE
end
