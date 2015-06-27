require 'user_repos_parser'

describe UserReposParser do
  it "extracts repos from the json string" do
    json_string = "json_string"
    expect(JSON).to receive(:parse).with(json_string).and_return(
      [{"name" => "first_repo", "full_name" => "path/first_repo"},
       {"name" => "second_repo", "full_name" => "path/second_repo"}])
    parser = UserReposParser.new(json: json_string)
    expect(parser.repos).to include "first_repo"
    expect(parser.repos).to include "second_repo"
  end
end
