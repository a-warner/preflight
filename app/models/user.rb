class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

  attribute_method_suffix '_previously_changed?'

  has_many :identities, dependent: :destroy
  has_many :checklists, foreign_key: :created_by_id
  has_many :checklist_items, foreign_key: :created_by_id

  def just_created?
    id_previously_changed?
  end

  def self.find_or_create_from_omniauth!(omniauth)
    if identity = Identity.find_by_omniauth(omniauth)
      identity.update_from_omniauth!(omniauth)
      identity.user
    else
      transaction do
        create! do |u|
          u.email = omniauth.info.email
          u.password = SecureRandom.hex(64)
        end.tap do |u|
          u.identities.link!(omniauth)
        end
      end
    end
  end

  def update_from_omniauth!(omniauth)
    identities.find_by_omniauth!(omniauth.provider).update_from_omniauth!(omniauth)
  end

  def github_client
    github_identity.client
  end

  private

  def github_identity
    identities.find_by_provider!('github')
  end

  def attribute_previously_changed?(attr)
    previous_changes.keys.include?(attr.to_s)
  end
end
