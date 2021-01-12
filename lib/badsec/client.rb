class Badsec::Client
  attr_reader :host, :port, :auth_token, :url

  DEFAULT_URL = 'http://localhost:8888'

  def initialize(auth_token: false, url: DEFAULT_URL)
    @auth_token = auth_token
    @url = URI(url)
  end

  def auth
    response = request_with_retries(:head, '/auth')
    @auth_token = response.fetch('Badsec-Authentication-Token')
  end

  def users
    return @users if @users
    auth unless auth_token
    opts = { headers: { 'X-Request-Checksum': checksum }}
    response = request_with_retries(:get, '/users', opts)
    @users = response.body.split("\n")
  end

  def checksum(path = '/users')
    return false unless auth_token
    Digest::SHA256.hexdigest("#{auth_token}#{path}")
  end

  def request_with_retries(http_method, path, opts = {})
    uri = url.dup
    uri.path = path

    request_class = Net::HTTP.const_get(http_method.to_s.capitalize)
    req = request_class.new(uri)
    opts[:headers].to_a.each { |k, v| req[k] = v }

    with_retries do
      Net::HTTP.start(url.hostname, url.port, { read_timeout: 2 }) do |http|
        http.request(req)
      end
    end
  end

  def with_retries(num = 3, &block)
    loop do
      begin
        res = yield
        break(res) if res.code == '200'
      rescue Net::ReadTimeout => e
        # NO OP
      end
      num = num - 1
      if num == 0
        raise Badsec::Error, "Bad connection to API (retried 3 times)"
      end
    end
  end
end
