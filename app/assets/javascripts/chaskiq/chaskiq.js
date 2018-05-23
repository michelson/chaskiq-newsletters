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



