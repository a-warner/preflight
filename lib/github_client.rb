class GithubClient < SimpleDelegator
  def initialize(options)
    super(Octokit::Client.new(options))
  end

  def repositories_with_write_access
    with_write_access(repos + orgs.map { |o| org_repos(o.login) }.flatten)
  end

  private

  def with_write_access(repos_to_check)
    repos_to_check.select { |r| r.permissions.push }
  end
end
