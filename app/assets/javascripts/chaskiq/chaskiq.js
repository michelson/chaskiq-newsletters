window.Chaskiq = {
  Helpers: {}
}
// Custom scripts
$(document).ready(function () {

    // MetsiMenu
    $('#side-menu').metisMenu();

    // Collapse ibox function
    $('.collapse-link').click( function() {
        var ibox = $(this).closest('div.ibox');
        var button = $(this).find('i');
        var content = ibox.find('div.ibox-content');
        content.slideToggle(200);
        button.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down');
        ibox.toggleClass('').toggleClass('border-bottom');
        setTimeout(function () {
            ibox.resize();
            ibox.find('[id^=map-]').resize();
        }, 50);
    });

    // Close ibox function
    $('.close-link').click( function() {
        var content = $(this).closest('div.ibox');
        content.remove();
    });

    // Small todo handler
    $('.check-link').click( function(){
        var button = $(this).find('i');
        var label = $(this).next('span');
        button.toggleClass('fa-check-square').toggleClass('fa-square-o');
        label.toggleClass('todo-completed');
        return false;
    });

    // Append config box / Only for demo purpose
//    $.get("skin-config.html", function (data) {
//        $('body').append(data);
//    });

    // minimalize menu
    $('.navbar-minimalize').click(function () {
        $("body").toggleClass("mini-navbar");
        SmoothlyMenu();
    })

    // tooltips
    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    })

    // Move modal to body
    // Fix Bootstrap backdrop issu with animation.css
    $('.modal').appendTo("body")

    // Full height of sidebar
    function fix_height() {
        var heightWithoutNavbar = $("body > #wrapper").height() - 61;
        $(".sidebard-panel").css("min-height", heightWithoutNavbar + "px");
    }
    fix_height();

    // Fixed Sidebar
    // unComment this only whe you have a fixed-sidebar
    //    $(window).bind("load", function() {
    //        if($("body").hasClass('fixed-sidebar')) {
    //            $('.sidebar-collapse').slimScroll({
    //                height: '100%',
    //                railOpacity: 0.9,
    //            });
    //        }
    //    })

    $(window).bind("load resize click scroll", function() {
        if(!$("body").hasClass('body-small')) {
            fix_height();
        }
    })

    $("[data-toggle=popover]")
        .popover();


    $('.input-group.date').datepicker({
      todayBtn: "linked",
      keyboardNavigation: false,

    });
});


// For demo purpose - animation css script
function animationHover(element, animation){
    element = $(element);
    element.hover(
        function() {
            element.addClass('animated ' + animation);
        },
        function(){
            //wait for animation to finish before removing classes
            window.setTimeout( function(){
                element.removeClass('animated ' + animation);
            }, 2000);
        });
}

// Minimalize menu when screen is less than 768px
$(function() {
    $(window).bind("load resize", function() {
        if ($(this).width() < 769) {
            $('body').addClass('body-small')
        } else {
            $('body').removeClass('body-small')
        }
    })
})

function SmoothlyMenu() {
    if (!$('body').hasClass('mini-navbar') || $('body').hasClass('body-small')) {
        // Hide menu in order to smoothly turn on when maximize menu
        $('#side-menu').hide();
        // For smoothly turn on menu
        setTimeout(
            function () {
                $('#side-menu').fadeIn(400);
            }, 100);
    } else if ($('body').hasClass('fixed-sidebar')){
        $('#side-menu').hide();
        setTimeout(
            function () {
                $('#side-menu').fadeIn(400);
            }, 300);
    } else {
        // Remove all inline style from jquery fadeIn function to reset menu state
        $('#side-menu').removeAttr('style');
    }
}

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




