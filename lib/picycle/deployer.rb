require 'octokit'

module Picycle
  class Deployer
    def initialize(dryrun, config)
      @dryrun = dryrun
      @config = config

      unless dryrun
        %w( github_repo github_access_key ).each do |required_config_key|
          fail "#{required_config_key} is not set" unless @config.key?(required_config_key)
        end
        @gh = Octokit::Client.new(access_token: @config['github_access_key'])
      end
    end

    def merge
      if @dryrun || branches_are_identical?
        return false
      else
        perform_merge
        return true
      end
    end

    def github_compare_url
      "https://github.com/#{@config['github_repo']}/compare/#{@old_sha}...#{@new_sha}"
    end

    private

    def branches_are_identical?
      @gh.compare(@config['github_repo'], 'master', 'develop', accept: 'application/vnd.github.diff').empty?
    end

    def perform_merge
      @old_sha = @gh.ref(@config['github_repo'], 'heads/master')[:object][:sha]
      @gh.merge(@config['github_repo'], 'master', 'develop', commit_message: '[velopsipede] Merge develop into master')
      @new_sha = @gh.ref(@config['github_repo'], 'heads/master')[:object][:sha]
    end
  end
end
