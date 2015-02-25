$(document).on('ajax:success', '.destroy-checklist-item', function() {
  $(this).closest('.row').remove()
})

$(document).on('ajax:success', '.new_checklist_item', function(e, data) {
  var $form = $(this)
  $form[0].reset()
  $(data).insertBefore($form.closest('.row'))
}).on('ajax:error', '.new_checklist_item, .edit_checklist_item', function(e, xhr) {
  alert(xhr.responseText)
})

$(document).on('click', '.checklist-item-name[data-edit-mode]', function() {
  var $this = $(this)
  $this.removeAttr('data-edit-mode')
}).on('click', '.checklist-item-name:not([data-edit-mode])', function() {
  var $this = $(this)
  $this.attr('data-edit-mode', true).
    find('input[type="text"]').focus().end().
    closest('.checklist-items').find('.checklist-item-name').not($this).removeAttr('data-edit-mode')
  return false
}).on('click', '.edit_checklist_item input[type="text"]', function() {
  return false
}).on('click', function() {
  $('.checklist-item-name').removeAttr('data-edit-mode')
})

$(document).on('ajax:success', '.edit_checklist_item', function(e, data) {
  $(this).closest('.row').replaceWith(data)
})
