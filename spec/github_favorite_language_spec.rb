require 'spec_helper'

describe GithubFavoriteLanguage do
  it 'has a version number' do
    expect(GithubFavoriteLanguage::VERSION).not_to be nil
  end

  describe ".get_favorite_language" do
    it 'should print usage with whitespace username' do
      expect(GithubFavoriteLanguage).to receive(:print_usage)
      GithubFavoriteLanguage.get_favorite_language(username:'  ')
    end
  end
end
