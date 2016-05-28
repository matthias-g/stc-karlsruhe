class Countdown
  SECOND = 1000
  MINUTE = SECOND * 60
  HOUR = MINUTE * 60
  DAY = HOUR * 24
  constructor: (counter) ->
    @counter = counter
    @fields = counter.find('div span')
    @end = new Date(counter.data('date'))
    timer = setInterval @update, 1000
    @update
  update = ->
    d = @end - (new Date)
    if d < 0
      clearInterval timer
      @counter.find('div').hide()
      @counter.find('.running').hide()
      @counter.find('.finished').show()
      return
    @fields.eq(0).text Math.floor(d / _day)
    @fields.eq(1).text ('0' + Math.floor(d % @DAY / @HOUR)).slice(-2)
    @fields.eq(2).text ('0' + Math.floor(d % @HOUR / @MINUTE)).slice(-2)
    @fields.eq(3).text ('0' + Math.floor(d % @MINUTE / @SECOND)).slice(-2)