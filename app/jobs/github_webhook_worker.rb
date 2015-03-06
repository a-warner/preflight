class GithubWebhookWorker < Struct.new(:headers, :body)
  HUB_SIGNATURE = 'X-Hub-Signature'
  WANTED_HEADERS = %w(X-GitHub-Event X-GitHub-Delivery) << HUB_SIGNATURE
  InvalidSignature = Class.new(StandardError)

  HANDLED_ACTIONS = %w(opened synchronize)

  def self.get_headers(headers)
    WANTED_HEADERS.each_with_object({}) do |header, hash|
      hash[header] = headers[header]
    end
  end

  def perform
    verify_signature!

    return unless HANDLED_ACTIONS.include?(action)
    return unless repo = GithubRepository.find_by_github_id(repository_id)

    repo.apply_checklists_for_pull!(pull_id, number)
  end

  def verify_signature!
    hub_signature = headers[HUB_SIGNATURE].to_s.split('=', 2).last
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV.fetch('GITHUB_WEBHOOK_SECRET'), body)

    raise InvalidSignature unless hub_signature == signature
  end

  private

  def parsed_body
    @parsed_body ||= JSON.parse(body)
  end

  def pull_id
    parsed_body.fetch('pull_request').fetch('id')
  end

  def number
    parsed_body.fetch('number')
  end

  def repository_id
    parsed_body.fetch('repository').fetch('id')
  end

  def action
    parsed_body['action']
  end
end
