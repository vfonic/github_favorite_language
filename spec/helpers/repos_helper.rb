def stub_repo(hash)
  repo = double('repo')
  hash.each do |k,v|
    allow(repo).to receive(:[]).with(k).and_return(v)
  end
end
