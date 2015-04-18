window.Chaskiq = {
  Helpers: {}
}
// Custom scripts
$(document).ready(function () {

    // Close ibox function
    $('.close-link').click( function() {
        var content = $(this).closest('div.ibox');
        content.remove();
    });

    $("[data-toggle=popover]")
        .popover();

    $('.input-group.date').datepicker({
      todayBtn: "linked",
      keyboardNavigation: false,
    });

    $("[data-modal]").on("click", function(){
      console.log($(this).attr("data-modal"))
      html = $($(this).attr("data-modal")).html();
      Chaskiq.Helpers.showModal(html, "Upload CSV");
      return false
    })

    $('.input-field select').select2();

});


var sendFile;

sendFile = function(file, callback) {
  var data;
  data = new FormData();
  data.append("image", file);
  return $.ajax({
    url: $('.summernote').data('upload-path'),
    data: data,
    cache: false,
    contentType: false,
    processData: false,
    type: 'POST',
    success: function(data) {
      return callback(data);
    }
  });
};


window.InitSummernote = function(){
    $('.summernote').summernote({
      toolbar: [
        ['style', ['color', 'bold', 'italic', 'underline', 'fontsize']],
        ['font', ['strikethrough']],
        ['insert', ['picture', 'link']],
        ['fontsize', ['fontsize']],
        ['para', ['ul', 'ol', 'paragraph']],
      ]
    , onImageUpload: function(files, editor, $editable) {
        sendFile(files[0], function(data){
          url = data.image.url
          console.log($editable)
          console.log(url)
          editor.insertImage($editable, url)
        })
        //console.log('image upload:', files, editor, $editable);
      }
    });
}




