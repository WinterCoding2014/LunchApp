class LunchApp.VenueViewModel
  constructor: (entry) ->
    Object.keys(entry).forEach (k) => this[k] = ko.observable entry[k]

    @initial = ko.computed => @name()[0]

    @availableRatingNumbers = [
      { value: 1, iconUrl: '/assets/face_1.png'},
      { value: 3, iconUrl: '/assets/face_2.png'},
      { value: 4, iconUrl: '/assets/face_3.png'},
      { value: 5, iconUrl: '/assets/face_4.png'},
      { value: 7, iconUrl: '/assets/face_5.png'}
    ]

    @setRatingTo = (value) =>
      @rating(value)
      $.ajax(
        {
          type: 'PUT',
          url: '/venues/' + @id() + '/ratings',
          data: {rating: @rating()},
          dataType: "json",
          success: () =>
            #alert 'sucess rating callback',
          error: (errorBlob, status) =>
            alert 'There was a problem saving your rating.'
        })