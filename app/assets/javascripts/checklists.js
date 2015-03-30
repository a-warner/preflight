$(document).on('ajax:success', '.destroy-checklist-item', function() {
  $(this).closest('.row').slideUp('slow', function() { $(this).remove() })
})

$(document).on('ajax:error', '.new_checklist_item, .edit_checklist_item', function(e, xhr) {
  alert(xhr.responseText)
})
