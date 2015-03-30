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

$(document).on('ajax:success', '.edit_checklist_item', function(e, data) {
  $(this).closest('.row').replaceWith(data)
})
