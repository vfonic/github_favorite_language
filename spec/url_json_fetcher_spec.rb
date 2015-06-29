require 'url_json_fetcher'

describe UrlJsonFetcher do
  describe "#fetch_all_pages" do
    let(:url_string) { "https://github.com" }
    let(:response) { double('response', meta: '', read: '{ "Python": 556 }') }
    let(:subject) { UrlJsonFetcher.new }

    before do
      allow(subject).to receive(:open).and_return(response)
    end

    it "should call open" do
      expect(subject).to receive(:open).and_return(response)
      subject.fetch_all_pages(url: url_string)
    end

    it "should parse json response" do
      expect(JSON).to receive(:parse).with(response.read)
      subject.fetch_all_pages(url: url_string)
    end

    it "should return parsed json response" do
      json_response = "json response"
      allow(JSON).to receive(:parse).and_return(json_response)
      expect(subject.fetch_all_pages(url: url_string)).to eq json_response
    end
  end
end
