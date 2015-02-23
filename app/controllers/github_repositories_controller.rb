class GithubRepositoriesController < ApplicationController
  before_filter :authenticate_user!
  expose(:github_repositories) { current_user.accessible_github_repositories }
  expose(:github_repository)

  def show
  end
end
