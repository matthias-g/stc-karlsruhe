# A combination of two swiper sliders and a PhotoSwipe slideshow.
# - Expects to find the nested sliders as div.gallery-top and div.gallery-thumbs
# - Expects attribute "data-slideshow-id" which points to the Photoswipe structure anywhere on the page
# - Expects attribute "data-gallery-id" with the record ID of the gallery to be shown

#= require swiper
#= require photoswipe

class @Gallery

  constructor: (@html) ->
    @changeNum = 1

    # get HTML parts for the components
    @slider_html = @html.find('.gallery-top')
    @thumbs_html = @html.find('.gallery-thumbs')
    @slideshow_html = $('#' + @html.data('slideshow-id'))

    # init and connect main and thumbs sliders
    @slider = new Swiper(@slider_html,
      spaceBetween: 10
      navigation:
        nextEl: '.swiper-button-next'
        prevEl: '.swiper-button-prev'
      autoplay:
        delay: 4000
        disableOnInteraction: true
      speed: 800
    )
    @thumbs = new Swiper(@thumbs_html,
      spaceBetween: 10
      centeredSlides: true
      slidesPerView: 'auto'
      touchRatio: 0.2
      slideToClickedSlide: true
    )
    @slider.controller.control = @thumbs
    @thumbs.controller.control = @slider

    # load gallery pictures JSON, then enable slideshow
    request = window.getResource 'galleries', @html.data('gallery-id'), include: 'gallery-pictures'
    request.done (data) =>
      @items = []
      for pic in data['gallery-pictures']
        @items.push(
          src:      pic.picture.desktop.url,
          raw_src:  pic.picture.url,
          sources:  pic.picture
          w:        pic['desktop-width'],
          h:        pic['desktop-height'],
          id:       pic.id,
          editable: pic.editable
        )
      @slider.on 'tap', => @openSlideshow(@slider.clickedIndex)
    request.fail (error) ->
      console.log('Request failed', error)

  # Inits the slideshow component and opens the given gallery item
  openSlideshow: (itemIdx) =>   
    options = {
      index: itemIdx
      history: false
      getThumbBoundsFn: (index) =>
        pageYScroll = window.pageYOffset or document.documentElement.scrollTop
        cont = $('.swiper-wrapper', @slider_html)[0].getBoundingClientRect()
        pw = @items[index].w
        ph = @items[index].h
        if pw / ph > cont.width / cont.height
          w = cont.width
          h = w * ph / pw
        else if pw / ph < cont.width / cont.height
          h = cont.height
          w = h * pw / ph
        else
          w = cont.width
          h = cont.height
        x = cont.left + (cont.width - (w)) / 2
        y = cont.top + (cont.height - (h)) / 2
        return {x: x, y: y + pageYScroll, w: w}
      getImageURLForShare: (shareButtonData) =>
        @slideshow.currItem.raw_src or @slideshow.currItem.src or ''
    }

    # init and open slideshow
    @slideshow = new PhotoSwipe(@slideshow_html.get(0), PhotoSwipeUI_Default, @items, options)
    @slideshow.init()
    @slideshow.listen 'close', =>
      @slider.slideTo @slideshow.getCurrentIndex(), 0
      @thumbs.slideTo @slideshow.getCurrentIndex(), 0

    # assign appropriate actions to slideshow buttons
    $('.pswp__button--delete').unbind('click').click => @deleteCurrentImage()
    $('.pswp__button--rotateright').unbind('click').click => @rotateCurrentImage(1)
    $('.pswp__button--rotateleft').unbind('click').click => @rotateCurrentImage(-1)

    # show edit buttons only if user may edit the picture
    @slideshow.listen 'beforeChange', =>
      $('.pswp__button--delete, .pswp__button--rotateright, .pswp__button--rotateleft').toggle(@slideshow.currItem.editable)
    @slideshow.shout 'beforeChange'

      
  # Closes the slideshow
  closeSlideshow: =>
    @slideshow.close()
      
    
  # Rotates the image currently opened in Photoswipe (direction = -1 or 1)
  rotateCurrentImage: (direction) =>
    idx = @slideshow.getCurrentIndex()
    item = @items[idx]

    # rotate image on server
    method = if direction > 0 then '/rotateRight' else '/rotateLeft'
    window.getJsonApi('/api/gallery-pictures/' + item.id + method).done (data) =>
      # inform user
      createFlashMessage I18n.t 'gallery.message.pictureRotated'

      # update local image attributes
      tmp = item.w
      item.w = item.h
      item.h = tmp
      item.src = item.sources.desktop.url + '?v=' + @changeNum++;

      # restart gallery
      @slider_html.find('.swiper-slide').eq(idx).css('background-image': 'url('+item.sources.preview.url+'?v='+ @changeNum++ +')')
      @thumbs_html.find('.swiper-slide').eq(idx).css('background-image': 'url('+item.sources.thumb.url+'?v='+ @changeNum++ +')')
      @slideshow.invalidateCurrItems()
      @slideshow.updateSize(true)

  # deletes the image currently opened in Photoswipe
  deleteCurrentImage: =>
    if !confirm I18n.t 'gallery.message.confirmDeletePicture'
      return
    idx = @slideshow.getCurrentIndex()
    item = @items[idx]

    # remove image on server
    window.requestToJsonApi('/api/gallery-pictures/' + item.id, 'DELETE').done (data) =>
      # inform user
      createFlashMessage I18n.t 'gallery.message.pictureDeleted'

      # remove image from slideshow
      @items.splice idx, 1
      if @items.length == 0
        @html.remove()
        return
      if idx >= @slideshow.items.length - 1
        @slideshow.goTo(0)
      @slideshow.invalidateCurrItems()
      @slideshow.updateSize(true)

      # remove image from slider
      @slider.removeSlide(idx)
      @thumbs.removeSlide(idx)