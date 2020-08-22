class ApplicationController < ActionController::Base
  if ENV['REQUIRE_HTTPS']
    before_filter :require_https
  end

  protect_from_forgery with: :exception

  def default_url_options
    ActionMailer::Base.default_url_options
  end

  def after_sign_in_path_for(user)
    checklists_path
  end

  private

  def require_https
    unless request.scheme == 'https'
      redirect_to %{https://#{request.host_with_port}#{request.path}#{request.query_string}}
    end
  end
end
