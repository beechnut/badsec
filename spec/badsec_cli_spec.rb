RSpec.describe Badsec::CLI do

  subject { Badsec::CLI.new(:get) }

  context "on success" do
    it "outputs a JSON-formatted list of user ids to stdout" do
      stub_request(:head, "http://localhost:8888/auth").
        to_return(headers: { 'Badsec-Authentication-Token': 'h3ck' })
      stub_request(:get, "http://localhost:8888/users").
        to_return({ status: 200, body: "9757263792576857988\n7789651288773276582\n1628388650278268240" })
      expect { subject.perform }.to output(
        "[\"9757263792576857988\",\"7789651288773276582\",\"1628388650278268240\"]"
      ).to_stdout
    end

    it "exits with a status code of zero" do
      stub_request(:head, "http://localhost:8888/auth").
        to_return(headers: { 'Badsec-Authentication-Token': 'h3ck' })
      stub_request(:get, "http://localhost:8888/users").
        to_return({ status: 200, body: "9757263792576857988\n7789651288773276582\n1628388650278268240" })
      expect(subject.perform).to be true
    end
  end

  context "on failure (if the call fails 3 times in a row)" do
    it "exits with a non-zero status code" do
      stub_request(:head, "http://localhost:8888/auth").
        to_return(headers: { 'Badsec-Authentication-Token': 'h3ck' })
      stub_request(:get, "http://localhost:8888/users").
        to_return({ status: 500 }).times(3)
      expect(subject.perform).to be false
    end
  end
end
