class GithubWebhookWorker < Struct.new(:headers, :body)
  WANTED_HEADERS = %w(X-GitHub-Event X-GitHub-Delivery X-Hub-Signature)

  def self.get_headers(headers)
    WANTED_HEADERS.each_with_object({}) do |header, hash|
      hash[header] = headers[header]
    end
  end

  def perform
  end
end
