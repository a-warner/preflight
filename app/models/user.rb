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
    end.tap do |u|
      u.sync_accessible_repositories
    end
  end

  def update_from_omniauth!(omniauth)
    identities.find_by_omniauth!(omniauth).update_from_omniauth!(omniauth)
  end

  def github_client
    github_identity.client
  end

  def sync_accessible_repositories
    repos = github_client.repositories_with_write_access
    GithubRepository.find_or_create_all(repos)
    update!(accessible_github_repository_ids: repos.map(&:id))
  end

  def accessible_github_repositories
    GithubRepository.where(github_id: accessible_github_repository_ids)
  end

  def accessible_checklists
    Checklist.for_repositories(accessible_github_repositories)
  end

  def can_access_repository?(github_repository)
    accessible_github_repository_ids.include?(github_repository.github_id)
  end

  def avatar_url
    github_identity.image_url
  end

  def github_profile_url
    github_identity.profile_url
  end

  private

  def github_identity
    identities.find_by_provider!('github')
  end

  def attribute_previously_changed?(attr)
    previous_changes.keys.include?(attr.to_s)
  end
end
