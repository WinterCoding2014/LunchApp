class LunchApp.VenueViewModel
  constructor: (entry) ->
    self = this
    Object.keys(entry).forEach((k) -> self[k] = ko.observable(entry[k]))

    self.initial = ko.computed(-> self.name()[0])
    self.rating = ko.observable()

    self.availableRatingNumbers = [
      { value: 0, iconUrl: '/assets/star.gif'},
      { value: 1, iconUrl: '/assets/star.gif'},
      { value: 2, iconUrl: '/assets/star.gif'},
      { value: 3, iconUrl: '/assets/star.gif'},
      { value: 4, iconUrl: '/assets/star.gif'}
    ]

    self.setRatingTo = (value) -> self.rating(value)

