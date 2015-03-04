$(document).on('ajax:success', '.destroy-checklist-item', function() {
  $(this).closest('.row').slideUp('slow', function() { $(this).remove() })
})

$(document).on('ajax:success', '.new_checklist_item', function(e, data) {
  var $form = $(this)
  $form[0].reset()
  $(data).insertBefore($form.closest('.row'))
}).on('ajax:error', '.new_checklist_item, .edit_checklist_item', function(e, xhr) {
  alert(xhr.responseText)
})

$(document).on('click', '.edit_checklist_item[data-edit-mode] .checklist-item-name', function() {
  $(this).closest('.edit_checklist_item').removeAttr('data-edit-mode')
}).on('click', '.edit_checklist_item:not([data-edit-mode]) .checklist-item-name', function() {
  var $form = $(this).closest('.edit_checklist_item')
  $form.attr('data-edit-mode', true).
    find('input[type="text"]').focus().end().
    closest('.checklist-items').find('.edit_checklist_item').not($form).removeAttr('data-edit-mode')
  return false
}).on('click', '.edit_checklist_item input[type="text"]', function() {
  return false
}).on('click', function() {
  $('.edit_checklist_item').removeAttr('data-edit-mode')
})

$(document).on('ajax:success', '.edit_checklist_item', function(e, data) {
  $(this).closest('.row').replaceWith(data)
})
