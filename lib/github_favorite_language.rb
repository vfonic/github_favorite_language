class GithubFavoriteLanguage
  def initialize(username:)
    @username = username.strip
  end

  def favorite_language
    if !@username.empty?
      puts @username
    else
      GithubFavoriteLanguage.print_usage
    end
  end

  def self.print_usage
    puts "Usage"
  end
end
