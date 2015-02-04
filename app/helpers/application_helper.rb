module ApplicationHelper
  def rails_to_bootstrap_flash_key(key)
    {notice: :success, alert: :warning, error: :danger}.with_indifferent_access.fetch(key)
  end
end
