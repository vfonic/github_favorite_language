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
      languages[repo["language"]] += repo["size"] unless repo["language"].nil? || repo["language"].empty?
    end
    
    languages.max_by { |lang, size| size }.first unless languages.empty?
  end

  def print_favorite_language(language:nil)
    language = favorite_language if language.nil?

    unless language.nil?
      puts "#{@username}'s favorite language is: #{language}"
    else
      puts "Couldn't determine #{@username}'s favorite language."
      puts "Check if #{@username} has public repos with code in them."
    end
  end

  def self.print_usage
    puts File.read('USAGE')
  end
end

class UsernameWhitespaceOrEmpty < StandardError; end
