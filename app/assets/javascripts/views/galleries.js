
$(document).ready(function ($) {
    // auto submit uploaded images
    $('form.edit_gallery').each(function(i, f) {
        $('#gallery_picture', f).change(function() {
            $('.waitinfo', f).show();
            $(f).submit();
        });
        $('input[type="submit"]', f).css({visibility: 'hidden'});
    });


    // set slideshow options
    var _SlideshowTransitions = [
        //Fade in L
        {$Duration: 1200, x: 0.3, $During: { $Left: [0.3, 0.7] }, $Easing: { $Left: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade out R
        , { $Duration: 1200, x: -0.3, $SlideOut: true, $Easing: { $Left: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade in R
        , { $Duration: 1200, x: -0.3, $During: { $Left: [0.3, 0.7] }, $Easing: { $Left: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade out L
        , { $Duration: 1200, x: 0.3, $SlideOut: true, $Easing: { $Left: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade in T
        , { $Duration: 1200, y: 0.3, $During: { $Top: [0.3, 0.7] }, $Easing: { $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2, $Outside: true }
        //Fade out B
        , { $Duration: 1200, y: -0.3, $SlideOut: true, $Easing: { $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2, $Outside: true }
        //Fade in B
        , { $Duration: 1200, y: -0.3, $During: { $Top: [0.3, 0.7] }, $Easing: { $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade out T
        , { $Duration: 1200, y: 0.3, $SlideOut: true, $Easing: { $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade in LR
        , { $Duration: 1200, x: 0.3, $Cols: 2, $During: { $Left: [0.3, 0.7] }, $ChessMode: { $Column: 3 }, $Easing: { $Left: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2, $Outside: true }
        //Fade out LR
        , { $Duration: 1200, x: 0.3, $Cols: 2, $SlideOut: true, $ChessMode: { $Column: 3 }, $Easing: { $Left: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2, $Outside: true }
        //Fade in TB
        , { $Duration: 1200, y: 0.3, $Rows: 2, $During: { $Top: [0.3, 0.7] }, $ChessMode: { $Row: 12 }, $Easing: { $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade out TB
        , { $Duration: 1200, y: 0.3, $Rows: 2, $SlideOut: true, $ChessMode: { $Row: 12 }, $Easing: { $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade in LR Chess
        , { $Duration: 1200, y: 0.3, $Cols: 2, $During: { $Top: [0.3, 0.7] }, $ChessMode: { $Column: 12 }, $Easing: { $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2, $Outside: true }
        //Fade out LR Chess
        , { $Duration: 1200, y: -0.3, $Cols: 2, $SlideOut: true, $ChessMode: { $Column: 12 }, $Easing: { $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade in TB Chess
        , { $Duration: 1200, x: 0.3, $Rows: 2, $During: { $Left: [0.3, 0.7] }, $ChessMode: { $Row: 3 }, $Easing: { $Left: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2, $Outside: true }
        //Fade out TB Chess
        , { $Duration: 1200, x: -0.3, $Rows: 2, $SlideOut: true, $ChessMode: { $Row: 3 }, $Easing: { $Left: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade in Corners
        , { $Duration: 1200, x: 0.3, y: 0.3, $Cols: 2, $Rows: 2, $During: { $Left: [0.3, 0.7], $Top: [0.3, 0.7] }, $ChessMode: { $Column: 3, $Row: 12 }, $Easing: { $Left: $JssorEasing$.$EaseInCubic, $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2, $Outside: true }
        //Fade out Corners
        , { $Duration: 1200, x: 0.3, y: 0.3, $Cols: 2, $Rows: 2, $During: { $Left: [0.3, 0.7], $Top: [0.3, 0.7] }, $SlideOut: true, $ChessMode: { $Column: 3, $Row: 12 }, $Easing: { $Left: $JssorEasing$.$EaseInCubic, $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2, $Outside: true }
        //Fade Clip in H
        , { $Duration: 1200, $Delay: 20, $Clip: 3, $Assembly: 260, $Easing: { $Clip: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade Clip out H
        , { $Duration: 1200, $Delay: 20, $Clip: 3, $SlideOut: true, $Assembly: 260, $Easing: { $Clip: $JssorEasing$.$EaseOutCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade Clip in V
        , { $Duration: 1200, $Delay: 20, $Clip: 12, $Assembly: 260, $Easing: { $Clip: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
        //Fade Clip out V
        , { $Duration: 1200, $Delay: 20, $Clip: 12, $SlideOut: true, $Assembly: 260, $Easing: { $Clip: $JssorEasing$.$EaseOutCubic, $Opacity: $JssorEasing$.$EaseLinear }, $Opacity: 2 }
    ];
    var options = {
        $AutoPlay: true,                                    //[Optional] Whether to auto play, to enable slideshow, this option must be set to true, default value is false
        $Idle: 10000,                            //[Optional] Interval (in milliseconds) to go for next slide since the previous stopped if the slider is auto playing, default value is 3000
        $PauseOnHover: 1,                                //[Optional] Whether to pause when mouse over if a slider is auto playing, 0 no pause, 1 pause for desktop, 2 pause for touch device, 3 pause for desktop and touch device, 4 freeze for desktop, 8 freeze for touch device, 12 freeze for desktop and touch device, default value is 1
        $DragOrientation: 3,                                //[Optional] Orientation to drag slide, 0 no drag, 1 horizental, 2 vertical, 3 either, default value is 1 (Note that the $DragOrientation should be the same as $PlayOrientation when $DisplayPieces is greater than 1, or parking position is not 0)
        $ArrowKeyNavigation: true,   			            //[Optional] Allows keyboard (arrow key) navigation or not, default value is false
        $SlideDuration: 800,                                //Specifies default duration (swipe) for slide in milliseconds
        $SlideshowOptions: {                                //[Optional] Options to specify and enable slideshow or not
            $Class: $JssorSlideshowRunner$,                 //[Required] Class to create instance of slideshow
            $Transitions: _SlideshowTransitions,            //[Required] An array of slideshow transitions to play slideshow
            $TransitionsOrder: 1,                           //[Optional] The way to choose transition to play slide, 1 Sequence, 0 Random
            $ShowLink: true                                    //[Optional] Whether to bring slide link on top of the slider when slideshow is running, default value is false
        },
        $ArrowNavigatorOptions: {                       //[Optional] Options to specify and enable arrow navigator or not
            $Class: $JssorArrowNavigator$,              //[Requried] Class to create arrow navigator instance
            $ChanceToShow: 1,                               //[Required] 0 Never, 1 Mouse Over, 2 Always
            $Scale: false,
            $AutoCenter: 2
        },
        $ThumbnailNavigatorOptions: {                       //[Optional] Options to specify and enable thumbnail navigator or not
            $Class: $JssorThumbnailNavigator$,              //[Required] Class to create thumbnail navigator instance
            $ChanceToShow: 2,                               //[Required] 0 Never, 1 Mouse Over, 2 Always
            $ActionMode: 1,                                 //[Optional] 0 None, 1 act by click, 2 act by mouse hover, 3 both, default value is 1
            $SpacingX: 6,                                   //[Optional] Horizontal space between each thumbnail in pixel, default value is 0
            $Cols: 7,                             //[Optional] Number of pieces to display, default value is 1
            $ParkingPosition: 247                          //[Optional] The offset position to park thumbnail
        },
        $FillMode: 1
    };
    var container = $('#slider_container');
    if (container.length == 0) return;
    var container_copy = container.clone();
    var pswp = $('.pswp');
    var slider, gallery;


    // build gallery item array
    var galleryItems = [];
    var galleryId = container.data('gallery-id');
    $.getJSON('/api/galleries/' + galleryId, function( data ) {
        $.each(data.gallery_pictures, function(index, item) {
            galleryItems.push({
                src: item.picture.desktop.url,
                raw_src: item.picture.url,
                w: item.desktop_width,
                h: item.desktop_height,
                id: item.id,
                editable: item.editable
            });
        });
    }).fail(function( jqxhr, textStatus, error ) {
        var err = textStatus + ", " + error;
        console.log( "Request Failed: " + err );
    });


    function createSlider() {
        slider = new $JssorSlider$("slider_container", options);

        //responsive code begin
        //you can remove responsive code if you don't want the slider scales while window resizes
        function ScaleSlider() {
            var parentWidth = slider.$Elmt.parentNode.clientWidth;
            if (parentWidth)
                slider.$ScaleWidth(Math.max(Math.min(parentWidth, 1200), 300));
            else
                window.setTimeout(ScaleSlider, 30);
        }

        ScaleSlider();
        $(window).bind("load", ScaleSlider);
        $(window).bind("resize", ScaleSlider);
        $(window).bind("orientationchange", ScaleSlider);
        //responsive code end

        slider.$On($JssorSlider$.$EVT_CLICK, function (slideIndex) {
            createGallery(slideIndex);
        });
    }

    function createGallery(slideIndex) {
        var options = {
            index: slideIndex,
            history: false,
            getThumbBoundsFn: function(index) {
                var pageYScroll = window.pageYOffset || document.documentElement.scrollTop;
                var slider_container = $('.gallery-slides')[0].getBoundingClientRect();
                var preview = {};
                var picture = galleryItems[index];
                if ((picture.w / picture.h) > (slider_container.width / slider_container.height)) {
                    preview.w = slider_container.width;
                    preview.h = preview.w * picture.h / picture.w;
                } else if ((picture.w / picture.h) < (slider_container.width / slider_container.height)) {
                    preview.h = slider_container.height;
                    preview.w = preview.h * picture.w / picture.h;
                } else {
                    preview.w = slider_container.width;
                    preview.h = slider_container.height;
                }
                preview.x = slider_container.left + (slider_container.width - preview.w) / 2;
                preview.y = slider_container.top + (slider_container.height - preview.h) / 2;
                return {x: preview.x, y: preview.y + pageYScroll, w: preview.w};
            },
            getImageURLForShare: function( shareButtonData ) {
                return gallery.currItem.raw_src || gallery.currItem.src || '';
            }
        };

        // Initializes and opens PhotoSwipe
        gallery = new PhotoSwipe(pswp.get(0), PhotoSwipeUI_Default, galleryItems, options);
        gallery.init();
        gallery.listen('close', function() {
            slider.$PlayTo(gallery.getCurrentIndex());
        });

        $('.pswp__button--delete').unbind('click').click(function() {
                deleteCurrentImage();
        });
        $('.pswp__button--rotateright').unbind('click').click(function() {
            rotateCurrentImage(1);
        });
        $('.pswp__button--rotateleft').unbind('click').click(function() {
            rotateCurrentImage(-1);
        });

        function toggleEditButtons() {
            $('.pswp__button--delete, .pswp__button--rotateright, .pswp__button--rotateleft')
                .toggle(gallery.currItem.editable == true);
        }
        gallery.listen('beforeChange', toggleEditButtons);
        toggleEditButtons();

    }

    function rotateCurrentImage(dir) {
        var idx = gallery.getCurrentIndex();
        var item = galleryItems[idx];
        var dirStr = (dir > 0) ? "/rotateRight" : "/rotateLeft";
        $.ajax({
            url: "/api/gallery_pictures/" + item.id + dirStr,
            dataType: "json",
            type: "GET",
            processData: false,
            contentType: "application/json"
        }).done(function(data) {
            //TODO: show flash message
        });

        var tmp = item.w;
        item.w = item.h;
        item.h = tmp;

        container.html(container_copy.children().clone());
        createSlider();
        gallery.close();
        createGallery(idx);
    }

    function deleteCurrentImage() {
        var idx = gallery.getCurrentIndex();
        var item = galleryItems[idx];

        var confirmation = confirm("Möchtest Du dieses Bild wirklich löschen?");
        if (!confirmation) {
            return;
        }

        $.ajax({
            url: "/api/gallery_pictures/" + item.id,
            dataType: "json",
            type: "POST",
            processData: false,
            contentType: "application/json",
            beforeSend: function(xhr)
            {
                xhr.setRequestHeader("X-Http-Method-Override", "DELETE");
            }
        }).done(function(data) {
            //TODO: show flash message
        });

        // remove from gallery
        galleryItems.splice(idx, 1);
        if (galleryItems.length <= 0) {
            pswp.remove();
            container.remove();
            return;
        }
        if (idx >= gallery.items.length - 1)
            gallery.goTo(0);
        gallery.invalidateCurrItems();
        gallery.updateSize(true);

        // remove from slider
        container_copy.find('.gallery-slides').children().eq(idx).remove();
        container.html(container_copy.children().clone());
        createSlider();
    }

    createSlider();

});