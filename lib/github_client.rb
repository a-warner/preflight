class GithubClient < SimpleDelegator
  def self.for_installation(installation_id)
    token = app_client.create_app_installation_access_token(installation_id)[:token]

    new(bearer_token: token)
  end

  def self.app_client
    new(bearer_token: bearer_token)
  end

  def self.bearer_token
    private_key = OpenSSL::PKey::RSA.new(Base64.decode64(ENV.fetch('GITHUB_APP_PRIVATE_KEY')))

    payload = {
      iat: Time.now.to_i,
      exp: Time.now.to_i + (10 * 60) - 10,
      iss: ENV.fetch('GITHUB_APP_ID')
    }

    JWT.encode(payload, private_key, "RS256")
  end

  def initialize(options)
    super(Octokit::Client.new(options))
  end

  def repositories_with_write_access
    repos = []

    find_user_installations.installations.flat_map do |installation|
      page = 1

      begin
        repos += find_installation_repositories_for_user(installation.id, page: page, per_page: 100).repositories
        page += 1
      end while last_response.rels[:next].present?
    end

    with_write_access(repos)
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
