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

  def print_favorite_language
    begin
      language = favorite_language if language.nil?

      unless language.nil?
        print_message(message: "#{@username}'s favorite language is: #{language}")
      else
        print_no_public_repos
      end
    rescue JsonApiClient::NotFound
      print_username_not_found
    rescue JsonApiClient::Error, JsonApiClient::RateLimitExceeded => e
      print_message(message: e.message)
    end
  end

  def self.print_usage
    puts %Q(
Description:
  Find out any GitHub user's favorite programming language

Usage:
  github_favorite_language vfonic

  This will fetch vfonic user repos and return the name of the language
  with most bytes of code written.
  For GitHub documentation refer to: https://developer.github.com/v3/
    )
  end

  private

    def print_message(message:)
      puts message
    end

    def print_no_public_repos
      puts "Couldn't determine #{@username}'s favorite language."
      puts "Check if #{@username} has public repos with code in them."
    end

    def print_username_not_found
      puts "User #{@username} not found. Check the username is correct."
    end
end

class UsernameWhitespaceOrEmpty < StandardError; end
