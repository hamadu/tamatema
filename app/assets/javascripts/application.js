// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

glossary_word_edit = function(id) {
  var selector = '#edit_word_model';
  if (id && id != 'new') {
    $('#word_id').val(id);
    $('#word_name').val($('#word_name_' + id).html());
    $('#word_description').html($('#word_description_' + id).html());
  } else {
    $('#word_id').val('new');
    $('#word_name').val('');
    $('#word_description').html('');
  }
  $('#edit_word_modal').modal('show');
}