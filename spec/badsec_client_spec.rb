RSpec.describe Badsec::Client do

  subject do
    Badsec::Client.new(auth_token: 'v4l1d')
  end

  it "has a version number" do
    expect(Badsec::VERSION).not_to be nil
  end

  context "endpoint failure" do
    context "once" do
      # stub_request(:any, "localhost:8888/users").
      #   to_return({ status: 500 }).then.
      #   to_return({ status: 200 })
    end

    context "twice" do
      # stub_request(:any, "localhost:8888/auth").
      #   to_return({ status: 500 }).times(2).then.
      #   to_return({ status: 200 })
    end

    context "thrice" do
      # stub_request(:any, "localhost:8888/users").
      #   to_return({ status: 500 }).times(3)
    end
  end

  it "exits with a non-zero status code to indicate failure if the call fails 3 times in a row"

  describe "#auth" do

    let(:client) { Badsec::Client.new }

    it "requests the Badsec-Authentication-Token in the header" do
      stub_request(:any, "localhost:8888/auth").
        to_return({ headers: { 'Badsec-Authentication-Token': 'h4ck1n9' }})
      client.auth # Make the request
      expect(client.auth_token).to eq('h4ck1n9')
    end
  end

  describe "#checksum" do
    let(:client) { Badsec::Client.new(auth_token: '12345') }

    it "generates the correct checksum when given an auth token & path" do
      expect(client.checksum('/users')).to eq('c20acb14a3d3339b9e92daebb173e41379f9f2fad4aa6a6326a696bd90c67419')
    end
  end

  describe "#users" do
    let(:client) { Badsec::Client.new(auth_token: '12345') }

    context "with an auth token" do
      it "does not request an auth token" do
        stub_request(:get, "localhost:8888/users")
        client.users
        expect(WebMock).not_to have_requested(:head, "localhost:8888/auth")
      end
    end

    context "without an auth token" do
      let(:client) { Badsec::Client.new() }

      it "requests an auth token first" do
        stub_request(:get, "localhost:8888/users")
        stub_request(:head, "localhost:8888/auth").
          to_return(headers: { 'Badsec-Authentication-Token': 'f4k3' })
        client.users
        expect(WebMock).to have_requested(:head, "localhost:8888/auth")
      end
    end

    it "sends X-Request-Checksum header to the /users endpoint" do
      stub_request(:get, "localhost:8888/users")
      client.users
      expect(WebMock).to have_requested(:get, "localhost:8888/users").
        with(headers: {
          'X-Request-Checksum': 'c20acb14a3d3339b9e92daebb173e41379f9f2fad4aa6a6326a696bd90c67419'
        })
    end
  end
end
