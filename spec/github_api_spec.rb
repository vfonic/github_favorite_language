require 'github_api'

describe GithubAPI do
  describe "#repos" do
    let(:subject) { GithubAPI.new }
    let(:user) { 'vfonic' }

    before do
      allow(UrlJsonFetcher).to receive(:fetch_all_pages) {
        double('response').as_null_object
      }
    end

    it "should call url_json_fetcher" do
      expect(UrlJsonFetcher).to receive(:fetch_all_pages).with(
        url: GithubAPI::GITHUB_API_URL + "/users/#{user}/repos")
      subject.repos(user: user)
    end

    it "should return array of repos" do
      dub1 = double; dub2 = double
      allow(UrlJsonFetcher).to receive(:fetch_all_pages) { [ dub1, dub2 ] }
      repos = subject.repos(user: user)
      expect(repos).to include dub1
      expect(repos).to include dub2
    end    
  end
end
