
export default
  methods:
    # translate
    t: (label, options = {}) -> I18n.t label, options
    # pluralize
    p: (label, count) -> I18n.p count, label
    # format date
    d: (date) -> I18n.l('date.formats.short_with_weekday', date)