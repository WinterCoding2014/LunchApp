class LunchApp.VenueViewModel
  constructor: (entry) ->
    Object.keys(entry).forEach (k) => this[k] = ko.observable entry[k]

    @initial = ko.computed => @name()[0]

    @availableRatingNumbers = [
      { value: 0, iconUrl: '/assets/star.gif'},
      { value: 1, iconUrl: '/assets/star.gif'},
      { value: 2, iconUrl: '/assets/star.gif'},
      { value: 3, iconUrl: '/assets/star.gif'},
      { value: 4, iconUrl: '/assets/star.gif'}
    ]

    @setRatingTo = (value) => @rating(value)
