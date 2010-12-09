$(function() {
  $("input[id$='preview-button']").click(function() {
    var form = $("form#new_topic");
    var params = form.serialize()
    var url = "preview?" + params
    window.open(url);
    return false;
  });
}); 
