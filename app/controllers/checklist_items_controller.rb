class ChecklistItemsController < ApplicationController
  expose(:checklist)
  expose(:checklist_items, ancestor: :checklist)
  expose(:checklist_item, attributes: :checklist_item_params)

  def create
    if checklist_item.save
      render partial: 'checklists/checklist_item', locals: {item: checklist_item, checklist: checklist}
    else
      render text: checklist_item.errors.full_messages.join("\n"), status: :bad_request
    end
  end

  def destroy
    checklist_item.destroy
    render nothing: true
  end

  private

  def checklist_item_params
    params.require(:checklist_item).permit(:name)
  end
end
