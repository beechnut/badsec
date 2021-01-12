require 'json'
class Badsec::CLI

  def initialize(command, auth_token = false)
    assert(command, within: [:get])
    @client = Badsec::Client.new(auth_token: auth_token)
  end

  def perform
    if @client.users
      $stdout << @client.users.to_json
      return true
    end
  rescue ArgumentError, Badsec::Error => e
    STDERR.puts(e.message)
    return false
  end

  private

  def assert(command, within: [])
    unless within.include?(command.to_sym)
      raise ArgumentError, <<~MSG
        Subcommand must be one of the following: #{within.inspect}, but was given `#{command}`.
      MSG
    end
  end

end
