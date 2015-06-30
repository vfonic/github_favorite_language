require 'github_api'

class GithubFavoriteLanguage
  def initialize(username:)
    @username = username.strip
    raise UsernameWhitespaceOrEmpty if @username.empty?
    @github_api = GithubAPI.new
  end

  def favorite_language
    repos = @github_api.repos(user: @username)

    languages = Hash.new(0)
    repos.map do |repo|
      languages[repo.language] += repo.size if repo.language?
    end
    languages.max_by { |lang, size| size }.first
  end

  def print_favorite_language(language:nil)
    language = favorite_language if language.nil? || language.empty?
    puts "#{@username}'s favorite language is: #{language}"
  end

  def self.print_usage
    puts File.read('USAGE')
  end
end

class UsernameWhitespaceOrEmpty < StandardError; end
