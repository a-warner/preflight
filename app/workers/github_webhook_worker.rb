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
  end

  def verify_signature!
    hub_signature = headers[HUB_SIGNATURE].to_s.split('=', 2).last
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV.fetch('GITHUB_WEBHOOK_SECRET'), body)

    raise InvalidSignature unless hub_signature == signature
  end
end
