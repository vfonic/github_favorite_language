require 'json_api_client'

class GithubAPI
  GITHUB_API_URL = 'https://api.github.com'.freeze

  def repos(user:)
    repos = JsonApiClient.fetch_all_pages(url: GITHUB_API_URL + "/users/#{user}/repos")
    repos.select{ |repo| repo["owner"]["login"] == user } unless repos.nil?
  end 
end
