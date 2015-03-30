$(document).on('ajax:success', '.destroy-checklist-item', function() {
  $(this).closest('.row').slideUp('slow', function() { $(this).remove() })
})
