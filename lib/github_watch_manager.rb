require 'pp'
require 'logger'

require 'highline/import'
require 'octokit'

require_relative 'util'

include Util

# Main class / object
class GithubWatchManager
  DEBUG = Logger::DEBUG
  INFO = Logger::INFO

  attr_accessor :log # TODO this allows users to change the log object and should be refactored

  TOKEN_FILENAME = '.token'
  TOKEN_NAME = 'github-watch-manager'

  SCOPES = %w(user repo)

  def initialize
    @log = Logger.new(STDOUT)

    @log.level = INFO
  end

  def get_token(token_file = TOKEN_FILENAME)
    return nil if token_file.nil?

    @log.debug("reading #{token_file} token file")

    # try loading the github access token file
    begin
      token = File.open(token_file, 'r').read
    rescue Errno::ENOENT
      @log.warn("couldn't load #{token_file}")
    end

    token
  end

  def show_intro
    puts <<-EOM

Hi, this little tool will mass-watch/unwatch a list of github repos (one per line) in an input file (see help for
options).  The repo name format is org/repo (just like they appear on https://github.com/jguice/github-watch-manager).

Before you can run the tool we'll need to create a Personal Access Token.  To create the token, we'll ask for your
github username, password, and possibly a two-factor auth token.

This will only happen the first time you run this script or if the token disappears.  The Personal Access Token will be
dropped into a file called #{TOKEN_FILENAME} in this directory should you need it.

The script will only be given the #{listify(SCOPES)} roles which will allow it to see and manage which repos you're
subscribed to.

Ready?  Here we go. :)

EOM
  end

  def prompt_for_credentials
    username = ask('Github username/email: ')
    password = ask('Password (not echoed): ') { |q| q.echo = '*' }

    [username, password]
  end

  def create_and_save_app_token(client)
    client.create_authorization(scopes: SCOPES, note: TOKEN_NAME)

  rescue Octokit::OneTimePasswordRequired
    two_factor_token = ask('Two-Factor Auth Token: ')

    token = client.create_authorization(
      scopes: SCOPES,
      note: TOKEN_NAME,
      headers: { 'X-GitHub-OTP' => two_factor_token }
    )

    token = token[:token] # get actual token from Sawyer::Resource returned by create_authorization

    # store the token for later runs
    File.open(TOKEN_FILENAME, 'w') { |f| f.write(token) }

    token
  end

  def create_github_client(username, password)
    client = Octokit::Client.new(login: username, password: password)

    # ensure middleware raises errors on auth failure (so we can check if it's a 2FA requirement causing it)
    stack = Faraday::RackBuilder.new do |builder|
      # builder.response :logger # uncomment me to enable direct console logging of requests
      builder.use Octokit::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end

    Octokit.middleware = stack

    client
  end
end
