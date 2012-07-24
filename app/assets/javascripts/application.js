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

glossary_word_edit = function(url) {
  $('#modal_content').html('');
  $('#edit_word_modal').modal();
  $('#modal_content').load(url, '', function(){
    $('input#word_name').focus();
    $('#modal_content form').ajaxComplete(function(state, ajax, status) {
      if (status.type == "POST") {
        response = $.parseJSON(ajax.responseText);
        if (response != null) {
          if (response.status == 'success') {
            location.reload();
          } else {
            console.log(response);
            $('form #errors').html( build_errors(response.error) );
          }
        }
      }
    });
  });
}

glossary_delete = function(url, glossary) {
  if (confirm("用語集「" + glossary + "」を削除してもいいですか？\n操作は取り消せません。")) {
    $("#glossary_delete").attr("action", url);
    $("#glossary_delete").submit();
  }
}

glossary_word_delete = function(url, word) {
  if (confirm("単語「" + word + "」を削除してもいいですか？\n操作は取り消せません。")) {
    $.ajax({
      type: "post",
      url: url,
      dataType: "json",
      success: function(msg){
        if (msg.status == 'success') {
          location.reload();            
        } else {
          alert('エラーが発生しました。もう一度やり直してください。');
        }
      },
      error: function(msg) {
        alert('エラーが発生しました。もう一度やり直してください。');
      }
    });
  }
}

build_errors = function(errors) {
  var html = "";
  html = html.concat('<div id="error_explanation">');
  html = html.concat('  <div class="alert alert-error">');
  html = html.concat('    [!] 登録エラー : ' + errors.length + '項目');
  html = html.concat('  </div>');
  html = html.concat('  <ul>');
  for (var i = 0 ; i < errors.length ; i++) {
    html = html.concat('    <li>* ' + errors[i] + '</li>');
  }
  html = html.concat('  </ul>');
  html = html.concat('</div>');
  
  return html;
}