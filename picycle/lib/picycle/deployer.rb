require 'octokit'

class Deployer

  def initialize(dryrun, config)
    @dryrun = dryrun
    @config = config

    unless dryrun
      %w( github_repo github_access_key ).each do |required_config_key|
        fail "#{required_config_key} is not set" unless @config.key?(required_config_key)
      end
      @gh = Octokit::Client.new(access_token: @config(github_access_key))
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
    repo = @config(github_repo)
    out = []
    out << "Merging develop to master of #{repo}"
    out << "SHA of master is #{@gh.ref(repo, 'heads/master')[:object][:sha]}"
    @gh.merge(repo, 'master', 'develop', commit_message: '[velopsipede] Merge develop into master')
    out << "new SHA of master is #{@gh.ref(repo, 'heads/master')[:object][:sha]}"
    return out.join("\n")
  end

end
