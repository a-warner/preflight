class ChecklistItemsController < ApplicationController
  before_filter :authenticate_user!

  expose(:checklists) { current_user.accessible_checklists }
  expose(:checklist)
  expose(:checklist_items, ancestor: :checklist)
  expose(:checklist_item, attributes: :checklist_item_params)

  def create
    checklist_item.created_by = current_user
    save_and_render_checklist
  end

  def update
    save_and_render_checklist
  end

  def destroy
    checklist_item.destroy
    render nothing: true
  end

  private

  def save_and_render_checklist
    if checklist_item.save
      render json: checklist_item
    else
      render text: checklist_item.errors.full_messages.join("\n"), status: :bad_request
    end
  end

  def checklist_item_params
    params.require(:checklist_item).permit(:name)
  end
end
