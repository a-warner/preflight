class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  def default_url_options
    ActionMailer::Base.default_url_options
  end
end
