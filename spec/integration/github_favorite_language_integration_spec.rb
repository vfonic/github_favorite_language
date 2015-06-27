require 'github_favorite_language'

describe "integrated github_favorite_language" do
  it "outputs user's favorite language" do
    skip

    gh_fav_lang = GithubFavoriteLanguage.new(username: 'mariokostelac')
    expect(gh_fav_lang.favorite_language).to eq 'C++'
  end
end
