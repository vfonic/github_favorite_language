require 'spec_helper'
require 'helpers/repos_helper'

describe GithubFavoriteLanguage do
  it "has a version number" do
    expect(GithubFavoriteLanguage::VERSION).not_to be nil
  end

  describe ".favorite_language" do
    let (:github_api) { double('github_api') }
    let (:username) { 'vfonic' }
    let (:subject) { GithubFavoriteLanguage.new(username: username) }

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

      subject.favorite_language
    end

    it "should return favorite language" do
      allow(github_api).to receive(:repos) {
        [
          stub_repo("size" => 67, "language" => "C++"),
          stub_repo("size" => 66, "language" => "Go"),
          stub_repo("size" => 66, "language" => "Go")
        ]
      }

      fav_language = subject.favorite_language
      expect(fav_language).to eq 'Go'
    end
  end

  describe ".print_favorite_language" do
    let (:github_api) { double('github_api') }
    let(:username) { 'vfonic' }
    let(:subject) { GithubFavoriteLanguage.new(username: username) }

    before do
      allow(GithubAPI).to receive(:new) { github_api }
    end

    it "should call .favorite_language if no language given" do
      expect(subject).to receive(:favorite_language)
      subject.print_favorite_language
    end

    it "should print correct message if provided language" do
      language = 'C++'
      allow(subject).to receive(:favorite_language).and_return(language)
      expect(STDOUT).to receive(:puts).with("#{username}'s favorite language is: #{language}")
      subject.print_favorite_language
    end

    it "should print a message when language can not be determined" do
      allow(subject).to receive(:favorite_language)
      expect(STDOUT).to receive(:puts).with("Couldn't determine #{username}'s favorite language.")
      expect(STDOUT).to receive(:puts).with("Check if #{username} has public repos with code in them.")
      subject.print_favorite_language
    end

    it "should print username not found when json_api_client raises JsonApiClient::NotFound" do
      allow(github_api).to receive(:repos).and_raise JsonApiClient::NotFound.new(headers:nil, message:nil)
      expect(STDOUT).to receive(:puts).with("User #{username} not found. Check the username is correct.")
      subject.print_favorite_language
    end

    it "should print error message when json_api_client raises RateLimitExceeded" do
      message = 'error message to print'
      allow(github_api).to receive(:repos).and_raise JsonApiClient::RateLimitExceeded.new(headers:nil, message:message)
      expect(STDOUT).to receive(:puts).with(message)
      subject.print_favorite_language
    end

    # TODO consider putting in shared example?
    it "should print error message when json_api_client raises Error" do
      message = 'error message to print'
      allow(github_api).to receive(:repos).and_raise JsonApiClient::Error.new(headers:nil, message:message)
      expect(STDOUT).to receive(:puts).with(message)
      subject.print_favorite_language
    end
  end

  describe ".print_usage" do
    it "should print the usage" do
      expect(STDOUT).to receive(:puts).with(File.read('USAGE'))
      GithubFavoriteLanguage.print_usage
    end
  end
end
