require 'github_api'

class GithubFavoriteLanguage
  def initialize(username:)
    @username = username.strip
    @github_api = GithubAPI.new
  end
require 'pry'
  def favorite_language
    if @username.empty?
      GithubFavoriteLanguage.print_usage
    else
      repos = @github_api.repos(user: @username)

      languages = Hash.new(0)
      repos.map do |repo|
        languages[repo.language] += repo.size if repo.language?
      end
      languages.max_by { |lang, size| size }.first
    end
  end

  def print_favorite_language(language:)
    puts "#{@username}'s favorite language is: #{language}"
  end

  def self.print_usage
    puts File.read('USAGE')
  end
end
