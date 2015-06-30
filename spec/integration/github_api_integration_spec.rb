require 'github_api'

describe "integration github_api" do
  let(:subject) { GithubAPI.new }
  let(:user) { 'vfonic' }

  before do
    allow(UrlJsonFetcher).to receive(:open) {
      double('response',
        meta: '',
        read: File.read('spec/data/users_username_repos.json')
      )}
  end

  it "should create resources from fetched repos" do
    repos = subject.repos(user: user)
    expect(repos[0]).to be_kind_of(Resource)
    expect(repos[0]).to respond_to(:name)
  end
end
