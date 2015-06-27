require 'json'

class UserReposParser
  def initialize(json:)
    @json = json
    @repos = JSON.parse(json).map do |repo|
      repo.fetch("name")
    end
  end

  def repos
    @repos
  end
end
