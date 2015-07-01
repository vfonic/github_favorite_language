require 'json_api_client'

describe JsonApiClient do
  describe "#fetch_all_pages" do
    let(:url_string) { "https://github.com" }
    let(:response) { double('response', meta: '', read: '{ "Python": 556 }') }

    before do
      allow(subject).to receive(:open).and_return(response)
    end

    it "should call open" do
      expect(subject).to receive(:open)
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

  describe "#fetch_page" do
    let(:url_string) { "https://github.com" }

    context "on OpenURI::HTTPError" do
      it "should raise JsonApiClient::NotFound on 404 Not Found" do
        openuri_error = OpenURI::HTTPError.new('404 Not Found', double('io', meta: ''))
        allow(subject).to receive(:open).and_raise openuri_error
        expect{ subject.fetch_all_pages(url: url_string) }.to raise_error JsonApiClient::NotFound
      end

      it "should raise JsonApiClient::Error on 403 Forbidden" do
        openuri_error = OpenURI::HTTPError.new('403 Forbidden', double('io', meta: ''))
        allow(subject).to receive(:open).and_raise openuri_error
        expect{ subject.fetch_all_pages(url: url_string) }.to raise_error JsonApiClient::Error
      end

      it "should raise JsonApiClient::RateLimitExceeded with correct message on 403 Forbidden with x-ratelimit-remaining" do
        openuri_error = OpenURI::HTTPError.new('403 Forbidden', double('io', meta: {
          "x-ratelimit-remaining" => 0
        }) )
        allow(subject).to receive(:open).and_raise openuri_error
        
        expect{ subject.fetch_all_pages(url: url_string) }.to raise_error{ |error|
          expect(error).to be_a(JsonApiClient::RateLimitExceeded)
          expect(error.message).to eq 'Rate Limit Exceeded'
        }
      end

      it "should raise JsonApiClient::RateLimitExceeded with correct message on 403 Forbidden with x-ratelimit-remaining and x-ratelimit-reset" do
        time = Time.now
        openuri_error = OpenURI::HTTPError.new('403 Forbidden', double('io', meta: {
          "x-rate-limit-remaining" => 0,
          "x-ratelimit-userreset" => time.to_i
        }) )
        allow(subject).to receive(:open).and_raise openuri_error

        expect{ subject.fetch_all_pages(url: url_string) }.to raise_error{ |error|
          expect(error).to be_a(JsonApiClient::RateLimitExceeded)
          expect(error.message).to eq "Try again after #{time}"
        }
      end
    end
  end
end
