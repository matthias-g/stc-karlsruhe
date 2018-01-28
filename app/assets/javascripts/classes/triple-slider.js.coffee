#= require swiper

class @TripleSlider
  constructor: (@html) ->
    new Swiper(@html,
      slidesPerView: 3
      spaceBetween: 30
      navigation:
        nextEl: '.swiper-button-next'
        prevEl: '.swiper-button-prev'
      breakpoints:
        1100: {slidesPerView: 2}
        800: {slidesPerView: 1}
    )