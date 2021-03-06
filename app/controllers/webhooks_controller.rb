class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def github
    wanted_headers = GithubWebhookWorker.get_headers(request.headers)
    Delayed::Job.enqueue(GithubWebhookWorker.new(wanted_headers, request.raw_post))

    head :ok
  end
end
