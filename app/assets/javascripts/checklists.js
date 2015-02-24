$(document).on('ajax:success', '.destroy-checklist-item', function() {
  $(this).closest('tr').remove()
})

$(document).on('ajax:success', '.new-checklist', function(e, data) {
  var $form = $(this)
  $form[0].reset()
  $(data).insertBefore($form.find('.new'))
}).on('ajax:error', '.new-checklist', function(e, xhr) {
  alert(xhr.responseText)
})
