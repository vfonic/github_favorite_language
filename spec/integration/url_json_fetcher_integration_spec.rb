require 'url_json_fetcher'

describe "integrated url_json_fetcher" do
  let(:subject) { UrlJsonFetcher }
  let(:url_string) { "https://stub.github.com/" }
  let(:page2_url) { "https://stub2.github.com/?page=2"}
  let(:response) {
    double('response',
      meta: '',
      read: File.read('spec/data/users_username_repos.json')
  )}
  let(:paginated_response) {
    double('response_page2',
      meta: { "Link" => '<' + page2_url + '>; rel="next"' },
      read: [{ "id" => 505, "name" => "new_repo" }].to_json
  )}

  before do
    allow(subject).to receive(:open).and_return(response)
  end

  it "should call given url" do
    expect(subject).to receive(:open).with(URI(url_string))
    subject.fetch_all_pages(url: url_string)
  end

  it "should return parsed json response" do
    repos = subject.fetch_all_pages(url: url_string)
    expect(repos).to be_a_kind_of(Array)
    expect(repos[0]).to have_key("name")
  end

  it "should paginate through all pages" do
    expect(subject).to receive(:open).with(URI(url_string)) { paginated_response }
    expect(subject).to receive(:open).with(URI(page2_url)) { response }
    subject.fetch_all_pages(url: url_string)
  end
end
