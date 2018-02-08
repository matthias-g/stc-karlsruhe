# A timer that counts down to the given date
# - Expects argument "data-date"
class @Countdown

  @SECOND:  1000
  @MINUTE:  @SECOND * 60
  @HOUR:    @MINUTE * 60
  @DAY:     @HOUR * 24

  constructor: (@html) ->
    @fields = @html.find('div span')
    @endDate = new Date(@html.data('date'))
    @timer = setInterval(@update, 1000)
    @update()
    
  update: =>
    d = @endDate - (new Date)
    # check whether  the action week is finished
    if d < 0
      clearInterval @timer
      @html.find('div').hide()
      @html.find('.running').hide()
      @html.find('.finished').show()
      return
    # set time fields (days, hours, minutes, seconds)
    @fields.eq(0).text Math.floor(d / Countdown.DAY)
    @fields.eq(1).text Math.floor(d % Countdown.DAY / Countdown.HOUR)
    @fields.eq(2).text Math.floor(d % Countdown.HOUR / Countdown.MINUTE)
    @fields.eq(3).text Math.floor(d % Countdown.MINUTE / Countdown.SECOND)