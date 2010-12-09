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
