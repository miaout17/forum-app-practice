$(function() {
  $("input[id$='preview-button']").click(function() {
    var form = $("form#new_topic");

    var title = form.children("#topic_title").val();
    var content = form.children("#post_content").val(); 

    params = ""
    params += "topic[title]=" + encodeURI(title) + "&"; 
    params += "post[content]=" + encodeURI(content); 

    var url = "preview?" + params;
    window.open(url);
    return false;
  });
}); 

function addAttachment(id, img_url, thumb_url) {
  var ids_input = $("input[id$='attachment_ids']"); 
  var ids = ids_input.val(); 
  if (ids!="")
    ids += ","
  var ids = ids + id; 
  ids_input.val(ids); 

  var img = "<img src='" + thumb_url + "'/>"
  $("#attachment-preview").append(img); 
};

