#!/usr/bin/env ruby

require 'highline/import'
require 'octokit'

TOKEN_FILENAME = '.github-unwatcher-token'

# try loading the github access token file
begin
  token = File.open(TOKEN_FILENAME, "r").read
rescue Errno::ENOENT
  # try home dir too
  begin
    token = File.open(File.join(Dir.home,TOKEN_FILENAME), "r").read
  rescue Errno::ENOENT
  end
end

if token.nil?
puts <<-EOM
Hi, this little tool will mass-unsubscribe you from a list of github repos (one per line) piped into STDIN.

Before you can run the tool you'll need to create a Personal Access Token.  To create the token, follow these steps:

1) visit your Settings page at github.com (currently accessed by clicking the gear icon in the upper-right corner).
2) click Applications on the left, then under "Personal access tokens" click the "Generate new token" button.
3) enter a name for the token (maybe github-unwatcher?), uncheck all scopes *except* user (least necessary access is good), and click "Generate token"
4) copy the token and put it in a file named #{TOKEN_FILENAME} in the same dir as this script (or in your home dir if you prefer)

All done?  Try running the script again.  :)

EOM
exit
end

puts token

username = ask("Github username: ")
password = ask("Password (trust me, it's fine): ") { |q| q.echo = "*" }

github = Octokit::Client.new(:login => username, :password => password)

begin
  say_hi(github.user)
rescue Octokit::OneTimePasswordRequired
  two_factor_token = ask("Two-Factor Auth Token: ")

  oauth_token = github.create_authorization(
    :scopes => ['user'],
    :note => 'github-unwatcher',
    :headers => { 'X-GitHub-OTP' => two_factor_token }
  )

  github = Octokit::Client.new(:access_token => oauth_token)

  say_hi(github.user)
end

def say_hi(user)
  puts "Hi #{user} :)"
end
