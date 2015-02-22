class Identity < ActiveRecord::Base
  belongs_to :user, inverse_of: :identities
  validates :provider, presence: true, :inclusion => { in: %w(github) }
  validates :omniauth_data, presence: true
  validates :uid, uniqueness: {scope: [:provider]}
  validates :provider, uniqueness: {scope: [:user_id]}

  serialize :omniauth_data, Hash

  def self.link!(omniauth)
    create! do |a|
      a.provider = omniauth.provider
      a.uid = omniauth.uid
      a.omniauth_data = omniauth
    end
  end

  def self.find_by_omniauth(omniauth)
    find_by_uid_and_provider(omniauth.uid, omniauth.provider)
  end

  def self.find_by_omniauth!(omniauth)
    find_by_omniauth(omniauth) or raise ActiveRecord::RecordNotFound
  end

  def update_from_omniauth!(omniauth)
    self.omniauth_data = omniauth_data
    save!
  end

  delegate :credentials, to: :omniauth_data

  def client
    Octokit::Client.new(:access_token => credentials.token)
  end
end
