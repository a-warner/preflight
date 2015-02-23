class GithubWebhookWorker < Struct.new(:headers, :body)
  HUB_SIGNATURE = 'X-Hub-Signature'
  WANTED_HEADERS = %w(X-GitHub-Event X-GitHub-Delivery) << HUB_SIGNATURE
  InvalidSignature = Class.new(StandardError)

  def self.get_headers(headers)
    WANTED_HEADERS.each_with_object({}) do |header, hash|
      hash[header] = headers[header]
    end
  end

  def perform
    verify_signature!

    return unless parsed_body['action'] == 'opened'
    return unless repo = GithubRepository.find_by_github_id(parsed_body['repository']['id'])

    repo.apply_checklists_for_pull!(parsed_body)
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
end
