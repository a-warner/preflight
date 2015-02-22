class ChecklistsController < ApplicationController
  before_filter :authenticate_user!

  expose(:checklists)
  expose(:checklist, attributes: :checklist_params)

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    checklist.created_by = current_user

    if checklist.save
      redirect_to checklist, notice: 'Checklist was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if checklist.update(checklist_params)
      redirect_to checklist, notice: 'Checklist was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    checklist.destroy
    redirect_to checklists_url, notice: 'Checklist was successfully destroyed.'
  end

  private

  def checklist_params
    params.require(:checklist).permit(:name, :github_repository_id)
  end
end
