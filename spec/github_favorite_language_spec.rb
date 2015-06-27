require 'github_favorite_language'
require 'user_repos_parser'

describe GithubFavoriteLanguage do
  it "has a version number" do
    expect(GithubFavoriteLanguage::VERSION).not_to be nil
  end

  describe ".get_favorite_language" do
    it "should print usage with whitespace username" do
      expect(GithubFavoriteLanguage).to receive(:print_usage)
      GithubFavoriteLanguage.new(username: ' ').favorite_language
    end

    it "should initialize UserReposParser" do
      skip
      
      expect(UserReposParser).to receive(:new)
      GithubFavoriteLanguage.new(username: 'vfonic').favorite_language
    end
  end

  describe ".print_usage" do
    it "should print the usage from USAGE file" do
      usage_string = "usage text"
      expect(File).to receive(:read).and_return(usage_string)
      expect(STDOUT).to receive(:puts).with(usage_string)
      GithubFavoriteLanguage.print_usage
    end
  end
end
