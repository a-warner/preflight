class GithubRepositoriesController < ApplicationController
  before_action :authenticate_user!
  expose(:github_repositories) { current_user.accessible_github_repositories }
  expose(:github_repository, scope: -> { github_repositories })

  def show
  end
end
