require 'github_favorite_language'

describe GithubFavoriteLanguage do
  it "has a version number" do
    expect(GithubFavoriteLanguage::VERSION).not_to be nil
  end

  describe ".favorite_language" do
    it "should print usage with whitespace username" do
      expect(GithubFavoriteLanguage).to receive(:print_usage)
      GithubFavoriteLanguage.new(username: ' ').favorite_language
    end

    it "should call GithubAPI.repos for username" do
      username = 'vfonic'
      github_api = double('github_api')
      expect(GithubAPI).to receive(:new) { github_api }
      expect(github_api).to receive(:repos).with(user: username) {
        [ double('repo', language: 'C++', size: 67).as_null_object ]
      }
      GithubFavoriteLanguage.new(username: username).favorite_language
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
