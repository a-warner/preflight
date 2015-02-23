class GithubClient < SimpleDelegator
  def initialize(options)
    super(Octokit::Client.new(options))
  end

  def repositories_with_write_access
    with_write_access(repos + orgs.map { |o| org_repos(o.login) }.flatten)
  end

  def create_default_hook(repo)
    create_hook(
      repo.github_full_name, 'web',
      {url: github_webhook_url, content_type: 'json', secret: ENV.fetch('GITHUB_WEBHOOK_SECRET') },
      {:events => ['push', 'pull_request']}
    )
  end

  private

  def with_write_access(repos_to_check)
    repos_to_check.select { |r| r.permissions.push }
  end

  def github_webhook_url
    Rails.application.routes.url_helpers.github_webhook_url(ActionMailer::Base.default_url_options)
  end
end
