$(document).ready(function() {
  $('#document_relevant_date').datepicker({
    format: "yyyy-mm-dd",
    autoclose: true
  });
  $('#upload').hide();
});

$(document).on('page:change', function() {
  $('#document_relevant_date').datepicker({
    format: "yyyy-mm-dd",
    autoclose: true
  });
  $('#upload').hide();
});

function upload() {
  $('#upload').show();
}
