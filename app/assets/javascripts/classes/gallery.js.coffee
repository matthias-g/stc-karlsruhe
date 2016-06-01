#= require jssor.slider.mini
#= require photoswipe

class @Gallery

  EASING_LEFT = { $Left: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }
  EASING_TOP = { $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }
  EASING_LEFTTOP = { $Left: $JssorEasing$.$EaseInCubic, $Top: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }
  EASING_CLIP = { $Clip: $JssorEasing$.$EaseInCubic, $Opacity: $JssorEasing$.$EaseLinear }
  EASING_CLIP_OUT = { $Clip: $JssorEasing$.$EaseOutCubic, $Opacity: $JssorEasing$.$EaseLinear }
  
  SLIDER_TRANSITIONS = [
    #Fade in L
    { $Duration: 1200, x: 0.3, $During: { $Left: [0.3, 0.7] }, $Easing: EASING_LEFT, $Opacity: 2},
    #Fade out R
    { $Duration: 1200, x: -0.3, $SlideOut: true, $Easing: EASING_LEFT, $Opacity: 2},
    #Fade in R
    { $Duration: 1200, x: -0.3, $During: { $Left: [0.3, 0.7] }, $Easing: EASING_LEFT, $Opacity: 2},
    #Fade out L
    { $Duration: 1200, x: 0.3, $SlideOut: true, $Easing: EASING_LEFT, $Opacity: 2},
    #Fade in T
    { $Duration: 1200, y: 0.3, $During: { $Top: [0.3, 0.7] }, $Easing: EASING_TOP, $Opacity: 2, $Outside: true },
    #Fade out B
    { $Duration: 1200, y: -0.3, $SlideOut: true, $Easing: EASING_TOP, $Opacity: 2, $Outside: true },
    #Fade in B
    { $Duration: 1200, y: -0.3, $During: { $Top: [0.3, 0.7] }, $Easing: EASING_TOP, $Opacity: 2 },
    #Fade out T
    { $Duration: 1200, y: 0.3, $SlideOut: true, $Easing: EASING_TOP, $Opacity: 2 },
    #Fade in LR
    { $Duration: 1200, x: 0.3, $Cols: 2, $During: { $Left: [0.3, 0.7] }, $ChessMode: { $Column: 3 }, $Easing: EASING_LEFT, $Opacity: 2, $Outside: true },
    #Fade out LR
    { $Duration: 1200, x: 0.3, $Cols: 2, $SlideOut: true, $ChessMode: { $Column: 3 }, $Easing: EASING_LEFT, $Opacity: 2, $Outside: true },
    #Fade in TB
    { $Duration: 1200, y: 0.3, $Rows: 2, $During: { $Top: [0.3, 0.7] }, $ChessMode: { $Row: 12 }, $Easing: EASING_TOP, $Opacity: 2 },
    #Fade out TB
    { $Duration: 1200, y: 0.3, $Rows: 2, $SlideOut: true, $ChessMode: { $Row: 12 }, $Easing: EASING_TOP, $Opacity: 2 },
    #Fade in LR Chess
    { $Duration: 1200, y: 0.3, $Cols: 2, $During: { $Top: [0.3, 0.7] }, $ChessMode: { $Column: 12 }, $Easing: EASING_TOP, $Opacity: 2, $Outside: true },
    #Fade out LR Chess
    { $Duration: 1200, y: -0.3, $Cols: 2, $SlideOut: true, $ChessMode: { $Column: 12 }, $Easing: EASING_TOP, $Opacity: 2 },
    #Fade in TB Chess
    { $Duration: 1200, x: 0.3, $Rows: 2, $During: { $Left: [0.3, 0.7] }, $ChessMode: { $Row: 3 }, $Easing: EASING_LEFT, $Opacity: 2, $Outside: true },
    #Fade out TB Chess
    { $Duration: 1200, x: -0.3, $Rows: 2, $SlideOut: true, $ChessMode: { $Row: 3 }, $Easing: EASING_LEFT, $Opacity: 2 },
    #Fade in Corners
    { $Duration: 1200, x: 0.3, y: 0.3, $Cols: 2, $Rows: 2, $During: { $Left: [0.3, 0.7], $Top: [0.3, 0.7] }, $ChessMode: { $Column: 3, $Row: 12 }, $Easing: EASING_LEFTTOP, $Opacity: 2, $Outside: true },
    #Fade out Corners
    { $Duration: 1200, x: 0.3, y: 0.3, $Cols: 2, $Rows: 2, $During: { $Left: [0.3, 0.7], $Top: [0.3, 0.7] }, $SlideOut: true, $ChessMode: { $Column: 3, $Row: 12 }, $Easing: EASING_LEFTTOP, $Opacity: 2, $Outside: true },
    #Fade Clip in H
    { $Duration: 1200, $Delay: 20, $Clip: 3, $Assembly: 260, $Easing: EASING_CLIP, $Opacity: 2 },
    #Fade Clip out H
    { $Duration: 1200, $Delay: 20, $Clip: 3, $SlideOut: true, $Assembly: 260, $Easing: EASING_CLIP_OUT, $Opacity: 2 },
    #Fade Clip in V
    { $Duration: 1200, $Delay: 20, $Clip: 12, $Assembly: 260, $Easing: EASING_CLIP, $Opacity: 2 },
    #Fade Clip out V
    { $Duration: 1200, $Delay: 20, $Clip: 12, $SlideOut: true, $Assembly: 260, $Easing: EASING_CLIP_OUT, $Opacity: 2 }
  ]
  @SLIDER_OPTIONS: {
    $AutoPlay: true,                #[Optional] Whether to auto play, to enable slideshow, this option must be set to true, default value is false
    $Idle: 10000,                   #[Optional] Interval (in milliseconds) to go for next slide since the previous stopped if the slider is auto playing, default value is 3000
    $PauseOnHover: 1,               #[Optional] Whether to pause when mouse over if a slider is auto playing, 0 no pause, 1 pause for desktop, 2 pause for touch device, 3 pause for desktop and touch device, 4 freeze for desktop, 8 freeze for touch device, 12 freeze for desktop and touch device, default value is 1
    $DragOrientation: 3,            #[Optional] Orientation to drag slide, 0 no drag, 1 horizental, 2 vertical, 3 either, default value is 1 (Note that the $DragOrientation should be the same as $PlayOrientation when $DisplayPieces is greater than 1, or parking position is not 0)
    $ArrowKeyNavigation: true,   		#[Optional] Allows keyboard (arrow key) navigation or not, default value is false
    $SlideDuration: 800,            #Specifies default duration (swipe) for slide in milliseconds
    $FillMode: 1,
    $SlideshowOptions: {            #[Optional] Options to specify and enable slideshow or not
      $Class: $JssorSlideshowRunner$,   #[Required] Class to create instance of slideshow
      $Transitions: SLIDER_TRANSITIONS, #[Required] An array of slideshow transitions to play slideshow
      $TransitionsOrder: 1,             #[Optional] The way to choose transition to play slide, 1 Sequence, 0 Random
      $ShowLink: true                   #[Optional] Whether to bring slide link on top of the slider when slideshow is running, default value is false
    },
    $ArrowNavigatorOptions: {         #[Optional] Options to specify and enable arrow navigator or not
      $Class: $JssorArrowNavigator$,  #[Requried] Class to create arrow navigator instance
      $ChanceToShow: 1,               #[Required] 0 Never, 1 Mouse Over, 2 Always
      $Scale: false,
      $AutoCenter: 2
    },
    $ThumbnailNavigatorOptions: {         #[Optional] Options to specify and enable thumbnail navigator or not
      $Class: $JssorThumbnailNavigator$,  #[Required] Class to create thumbnail navigator instance
      $ChanceToShow: 2,                   #[Required] 0 Never, 1 Mouse Over, 2 Always
      $ActionMode: 1,                     #[Optional] 0 None, 1 act by click, 2 act by mouse hover, 3 both, default value is 1
      $SpacingX: 6,                       #[Optional] Horizontal space between each thumbnail in pixel, default value is 0
      $Cols: 7,                           #[Optional] Number of pieces to display, default value is 1
      $ParkingPosition: 247               #[Optional] The offset position to park thumbnail
    }
  }
  
  constructor: (@html) ->
    @slider_html_copy = @html.find('.slider-container').clone()
    @photoswipe_html = @html.find('.pswp').get(0)
    @slider = @photoswipe = undefined
    @items = []
    @loadGalleryItems().done =>
      @initSlider()
    
  # load picture info with AJAX
  loadGalleryItems: =>
    @items = []
    galleryId = @html.data('gallery-id')
    $.getJSON('/api/galleries/' + galleryId, (data) =>
      for pic in data.gallery_pictures
        @items.push(
          src: pic.picture.desktop.url,
          raw_src: pic.picture.url,
          w: pic.desktop_width,
          h: pic.desktop_height,
          id: pic.id,
          editable: pic.editable
        )
    ).fail (jqxhr, textStatus, error) =>
      console.log( "Request Failed: " + textStatus + ", " + error )

      
  # create JSSOR (gallery) view
  initSlider: =>
    @html.find('.slider-container').html(@slider_html_copy.children().clone())
    @slider = new $JssorSlider$("slider_container", Gallery.SLIDER_OPTIONS)
    @makeSliderResponsive
    @slider.$On $JssorSlider$.$EVT_CLICK, (itemIdx) =>
      @openSlideshow(itemIdx)

      
  makeSliderResponsive: =>
    scaleSlider = =>
      # TODO: doesn't work any more if initSlider is called a second time
      parentWidth = @slider.$Elmt.parentNode.clientWidth
      if (parentWidth)
        @slider.$ScaleWidth(Math.max(Math.min(parentWidth, 1200), 300))
      else
        window.setTimeout(scaleSlider, 30)
    $(window).bind("load", scaleSlider)
    $(window).bind("resize", scaleSlider)
    $(window).bind("orientationchange", scaleSlider)
    scaleSlider()
      
    
  # create Photoswipe (fullscreen) view and open the given item
  openSlideshow: (itemIdx) =>   
    options = {
      index: itemIdx
      history: false
      getThumbBoundsFn: (index) =>
        pageYScroll = window.pageYOffset or document.documentElement.scrollTop
        cont = $('.gallery-slides', @html)[0].getBoundingClientRect()
        pic = @items[index]
        if pic.w / pic.h > cont.width / cont.height
          w = cont.width
          h = w * pic.h / pic.w
        else if pic.w / pic.h < cont.width / cont.height
          h = cont.height
          w = h * pic.w / pic.h
        else
          w = cont.width
          h = cont.height
        x = cont.left + (cont.width - (w)) / 2
        y = cont.top + (cont.height - (h)) / 2
        return {x: x, y: y + pageYScroll, w: w}
      getImageURLForShare: (shareButtonData) =>
        @photoswipe.currItem.raw_src or @photoswipe.currItem.src or ''
    }
    
    $('.pswp__button--delete').unbind('click').click =>
      @deleteCurrentImage()
    $('.pswp__button--rotateright').unbind('click').click =>
      @rotateCurrentImage(1)
    $('.pswp__button--rotateleft').unbind('click').click =>
      @rotateCurrentImage(-1)
      
    toggleEditButtons = =>
      $('.pswp__button--delete, .pswp__button--rotateright, .pswp__button--rotateleft').toggle(@photoswipe.currItem.editable == true)

    # Initializes and opens PhotoSwipe (fullscreen picture viewing)
    @photoswipe = new PhotoSwipe(@photoswipe_html, PhotoSwipeUI_Default, @items, options)
    @photoswipe.init()
    @photoswipe.listen 'close', =>
      @slider.$PlayTo(@photoswipe.getCurrentIndex())
    @photoswipe.listen 'beforeChange', toggleEditButtons
    toggleEditButtons()

      
  # closes Photoswipe (fullscreen) view
  closeSlideshow: =>
    @photoswipe.close()
      
    
  # rotates the image currently opened in Photoswipe (dir = -1 or 1)
  rotateCurrentImage: (dir) =>
    idx = @photoswipe.getCurrentIndex()
    item = @items[idx]
    
    # rotate image on server
    dirStr = if dir > 0 then '/rotateRight' else '/rotateLeft'
    $.ajax(
      url: '/api/gallery_pictures/' + item.id + dirStr
      dataType: 'json'
      type: 'GET'
      processData: false
      contentType: 'application/json'
    ).done (data) =>
      #TODO: show flash message

    # update local image attributes
    tmp = item.w
    item.w = item.h
    item.h = tmp
    
    # restart gallery
    @initSlider()
    @closeSlideshow()
    @openSlideshow(idx)

    
  # deletes the image currently opened in Photoswipe
  deleteCurrentImage: =>
    if !confirm('Möchtest Du dieses Bild wirklich löschen?')
      return
      
    idx = @photoswipe.getCurrentIndex()
    item = @items[idx]

    # remove image on server
    $.ajax(
      url: '/api/gallery_pictures/' + item.id
      dataType: 'json'
      type: 'POST'
      processData: false
      contentType: 'application/json'
      beforeSend: (xhr) =>
        xhr.setRequestHeader 'X-Http-Method-Override', 'DELETE'
    ).done (data) =>
      #TODO: show flash message

    # remove image from Photoswipe
    @items.splice idx, 1
    if @items.length == 0
      @photoswipe_html.remove()
      @html.remove()
      return
    if idx >= @photoswipe.items.length - 1
      @photoswipe.goTo(0)
    @photoswipe.invalidateCurrItems()
    @photoswipe.updateSize(true)
    
    # remove image from Slider
    @slider_html_copy.find('.gallery-slides').children().eq(idx).remove()
    @initSlider()
