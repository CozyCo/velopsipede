require 'octokit'

class Deployer

  def initialize(dryrun, repo)
    @dryrun = dryrun

    unless dryrun
      %w( GITHUB_REPO GITHUB_ACCESS_KEY ).each do |required_env_var|
        fail "#{required_env_var} is not set" if ENV[required_env_var].nil?
      end
      @gh = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_KEY'])
    end
  end

  def deploy
    if @dryrun
      return "Would perform merge if this wasn't a dry run."
    else
      return perform_merge
    end
  end

  private

  def perform_merge
    repo = ENV['GITHUB_REPO']
    out = []
    out << "Merging develop to master of #{repo}"
    out << "SHA of master is #{@gh.ref(repo, 'heads/master')[:object][:sha]}"
    @gh.merge(repo, 'master', 'develop', commit_message: '[velopsipede] Merge develop into master')
    out << "new SHA of master is #{@gh.ref(repo, 'heads/master')[:object][:sha]}"
    return out.join("\n")
  end

end
