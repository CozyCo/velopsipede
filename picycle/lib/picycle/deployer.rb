require 'octokit'

class Deployer

  def initialize(dryrun, config)
    @dryrun = dryrun
    @config = config

    @old_sha = 'master'
    @new_sha = 'develop'

    unless dryrun
      %w( github_repo github_access_key ).each do |required_config_key|
        fail "#{required_config_key} is not set" unless @config.key?(required_config_key)
      end
      @gh = Octokit::Client.new(access_token: @config['github_access_key'])
    end
  end

  def deploy
    if @dryrun
      return "Would perform merge if this wasn't a dry run."
    else
      return perform_merge
    end
  end

  def github_compare_url
    "https://github.com/#{@config['github_repo']}/compare/#{@old_sha}...#{@new_sha}"
  end

  private

  def perform_merge
    repo = @config['github_repo']
    out = []
    out << "Merging develop to master of #{repo}"
    @old_sha = @gh.ref(repo, 'heads/master')[:object][:sha]
    out << "SHA of master is #{@old_sha}"
    @gh.merge(repo, 'master', 'develop', commit_message: '[velopsipede] Merge develop into master')
    @new_sha = @gh.ref(repo, 'heads/master')[:object][:sha]
    out << "new SHA of master is #{@new_sha}"
    return out.join("\n")
  end

end
