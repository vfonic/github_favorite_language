require 'github_api'
require 'helpers/repos_helper'

describe GithubAPI do
  describe "#repos" do
    let(:subject) { GithubAPI.new }
    let(:user) { 'vfonic' }

    before do
      allow(JsonApiClient).to receive(:fetch_all_pages) {
        double('response').as_null_object
      }
    end

    it "should call json_api_client" do
      expect(JsonApiClient).to receive(:fetch_all_pages).with(
        url: GithubAPI::GITHUB_API_URL + "/users/#{user}/repos")
      subject.repos(user: user)
    end

    it "should return array of repos" do
      repo = stub_repo("size" => 67, "language" => "C++", "owner" => { "login" => user })
      allow(JsonApiClient).to receive(:fetch_all_pages) { [repo] }
      repos = subject.repos(user: user)
      expect(repos).to include repo
    end

    context "exclude forked repos" do
      before do
        @user_repo1 = stub_repo("size" => 67, "language" => "C++", "owner" => { "login" => user })
        @user_repo2 = stub_repo("size" => 66, "language" => "Go", "owner" => { "login" => user })
        @other_user_repo = stub_repo("size" => 66, "language" => "Go", "owner" => { "login" => "other_user" })
      end

      it "should include owned repos" do
        allow(JsonApiClient).to receive(:fetch_all_pages).and_return(
          [ @user_repo1, @user_repo2, @other_user_repo ]
        )
        repos = subject.repos(user: user)
        expect(repos.size).to eq 2
        expect(repos).to include @user_repo1
        expect(repos).to include @user_repo2
      end

      it "should not include forked repos" do
        allow(JsonApiClient).to receive(:fetch_all_pages).and_return(
          [ @user_repo1, @user_repo2, @other_user_repo ]
        )
        repos = subject.repos(user: user)
        expect(repos).to_not include @other_user_repo
      end
    end
  end
end
