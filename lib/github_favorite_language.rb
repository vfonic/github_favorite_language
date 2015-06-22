require 'github_favorite_language/version'

class GithubFavoriteLanguage
  def self.get_favorite_language(username:)
    username.strip!
    if !username.empty?
      puts username
    else
      self.print_usage
    end
  end

  def self.print_usage
    puts "Usage"
  end
end
