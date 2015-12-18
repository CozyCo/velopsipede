require 'octokit'

class Merger

  def initialize
    token = ENV['GITHUB_ACCESS_KEY']
    fail "GITHUB_ACCESS_KEY not set" if token.nil?
    @gh = Octokit::Client.new(access_token: token)
  end

  def merge(repo)
    puts "Merging develop to master of #{repo}"
    puts "SHA of master is #{@gh.ref(repo, 'heads/master')[:object][:sha]}"
    @gh.merge(repo, 'master', 'develop', commit_message: '[velopsipede] Merge develop into master')
    puts "new SHA of master is #{@gh.ref(repo, 'heads/master')[:object][:sha]}"
  end
end