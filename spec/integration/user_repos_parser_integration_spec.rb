require 'user_repos_parser'

describe UserReposParser do
  it "returns an array of user's repos from json string" do
    parser = UserReposParser.new(
      json: File.read('spec/data/users_username_repos.json'))
    expect(parser.repos).to eq ["prvi", "drugi"]
  end
end
