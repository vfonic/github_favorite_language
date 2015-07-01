require 'github_api'

describe "integration github_api" do
  let(:subject) { GithubAPI.new }
  let(:user) { 'vfonic' }

  before do
    allow(JsonApiClient).to receive(:open) {
      double('response',
        meta: '',
        read: File.read('spec/data/users_username_repos.json')
      )}
  end

  it "should return fetched repos" do
    repos = subject.repos(user: user)
    expect(repos).to be_kind_of(Array)
    expect(repos[0]).to be_kind_of(Hash)
  end
end
