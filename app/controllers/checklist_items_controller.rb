class ChecklistItemsController < ApplicationController
  before_filter :authenticate_user!

  expose(:checklists) { current_user.accessible_checklists }
  expose(:checklist, scope: -> { checklists })
  expose(:checklist_items, from: :checklist)
  expose(:checklist_item, scope: -> { checklist_items })

  def create
    checklist_item.created_by = current_user
    save_and_render_checklist
  end

  def update
    checklist_item.attributes = checklist_item_params
    save_and_render_checklist
  end

  def destroy
    checklist_item.destroy
    render nothing: true
  end

  private

  def save_and_render_checklist
    if checklist_item.save
      render partial: 'checklists/checklist_item', locals: {item: checklist_item, checklist: checklist}
    else
      render text: checklist_item.errors.full_messages.join("\n"), status: :bad_request
    end
  end

  def checklist_item_params
    params.require(:checklist_item).permit(:name)
  end
end
