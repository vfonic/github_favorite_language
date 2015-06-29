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
        url: GithubAPI::GITHUB_API_URL + "/users/#{user}/repos?per_page=1000")
      subject.repos(user: user)
    end

    it "should return array of resources" do
      dub1 = double; dub2 = double
      allow(UrlJsonFetcher).to receive(:fetch_all_pages) { [ dub1, dub2 ] }
      expect(Resource).to receive(:new).with(dub1)
      expect(Resource).to receive(:new).with(dub2)
      subject.repos(user: user)
    end    
  end
end
