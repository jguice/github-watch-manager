#!/usr/bin/env ruby

require 'pp'

require 'highline/import'
require 'octokit'

TOKEN_FILENAME = '.token'
TOKEN_NAME = 'github-unwatcher'

SCOPES = ['user','repo']


def main
  app_token = fetch_or_create_token

  github = Octokit::Client.new(:access_token => app_token)

  github.auto_paginate = true

  subscriptions = github.subscriptions

  subscription_names = subscriptions.collect{ |s| s[:full_name] }

  subscription_names.sort!

  subscription_names.each do |sub|
    puts sub
  end

  say_hi(github.user[:name])
end


def fetch_or_create_token
  # try loading the github access token file
  begin
    token = File.open(TOKEN_FILENAME, "r").read
  rescue Errno::ENOENT
    # let errors besides 'no file there' bubble up just in case
  end

  if token.nil?
    puts <<-EOM
Hi, this little tool will mass-unsubscribe you from a list of github repos (one per line) piped into STDIN.

Before you can run the tool we'll need to create a Personal Access Token.  To create the token, we'll ask for your github username, password, and possibly a two-factor auth token.

This will only happen the first time you run this script or if the token disappears.  The Personal Access Token will be dropped into a file called #{TOKEN_FILENAME} in this directory should you need it.

The script will only be given the #{SCOPES} roles which will allow it to see and manage which repos you're subscribed to.

Ready?  Here we go. :)

EOM

    username = ask("Github username: ")
    password = ask("Password (trust me, it's fine): ") { |q| q.echo = "*" }

    github = Octokit::Client.new(:login => username, :password => password)

    stack = Faraday::RackBuilder.new do |builder|
      #builder.response :logger # uncomment me to enable direct console logging of requests
      builder.use Octokit::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end
    Octokit.middleware = stack

    begin
      github.create_authorization(:scopes => SCOPES, :note => TOKEN_NAME)
    rescue Octokit::OneTimePasswordRequired
      two_factor_token = ask("Two-Factor Auth Token: ")

      token = github.create_authorization(
        :scopes => SCOPES,
        :note => TOKEN_NAME,
        :headers => { 'X-GitHub-OTP' => two_factor_token }
      )

      token = token[:token] # get actual token from Sawyer::Resource returned by create_authorization
    end

    if token.nil?
      puts "Sorry, I wasn't able to create an access token :("
      exit 1
    else
      # store the token for later runs
      File.open(TOKEN_FILENAME, 'w') { |f| f.write(token) }
    end

  end

  token
end


def say_hi(user)
  puts "Hi #{user} :) "
end

main
