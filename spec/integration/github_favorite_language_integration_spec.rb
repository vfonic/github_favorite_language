require 'github_favorite_language'

describe "integrated github_favorite_language" do
  before do
    allow(JsonApiClient).to receive(:open) {
      double('response',
        meta: '',
        read: File.read('spec/data/users_username_repos.json')
      )}
  end

  it "outputs user's favorite language" do
    gh_fav_lang = GithubFavoriteLanguage.new(username: 'mariokostelac')
    fav_language = gh_fav_lang.favorite_language
    expect(fav_language).to eq 'Go'
  end
end
