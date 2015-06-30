require 'github_favorite_language'

describe GithubFavoriteLanguage do
  it "has a version number" do
    expect(GithubFavoriteLanguage::VERSION).not_to be nil
  end

  describe ".favorite_language" do
    let (:github_api) { double('github_api') }
    let (:username) { 'vfonic' }

    before do
      allow(GithubAPI).to receive(:new) { github_api }
    end

    it "should raise UsernameWhitespaceOrEmpty with whitespace or empty username" do
      expect{ GithubFavoriteLanguage.new(username: ' ').favorite_language }
        .to raise_error UsernameWhitespaceOrEmpty
    end

    it "should call GithubAPI.repos for username" do
      expect(GithubAPI).to receive(:new) { github_api }
      expect(github_api).to receive(:repos).with(user: username) { double.as_null_object }

      GithubFavoriteLanguage.new(username: username).favorite_language
    end

    it "should return favorite language" do
      allow(github_api).to receive(:repos) {
        [
          stub_repo("size" => 67, "language" => "C++"),
          stub_repo("size" => 66, "language" => "Go"),
          stub_repo("size" => 66, "language" => "Go")
        ]
      }

      fav_language = GithubFavoriteLanguage.new(username: username).favorite_language
      expect(fav_language).to eq 'Go'
    end
  end

  describe ".print_favorite_language" do
    let(:username) { 'vfonic' }
    let(:subject) { GithubFavoriteLanguage.new(username: username) }

    it "should call .favorite_language if no language given" do
      expect(subject).to receive(:favorite_language)
      subject.print_favorite_language
    end

    it "should print correct message if provided language" do
      language = 'C++'
      expect(STDOUT).to receive(:puts).with("#{username}'s favorite language is: #{language}")
      subject.print_favorite_language(language: language)
    end

    it "should print a message when language can not be determined" do
      allow(subject).to receive(:favorite_language)
      expect(STDOUT).to receive(:puts).with("Couldn't determine #{username}'s favorite language.")
      expect(STDOUT).to receive(:puts).with("Chack if #{username} has public repos with code.")
      expect(STDOUT).to receive(:puts).with("Check the username is correct.")
      subject.print_favorite_language
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

def stub_repo(hash)
  repo = double('repo')
  hash.each do |k,v|
    allow(repo).to receive(:[]).with(k).and_return(v)
  end
end
