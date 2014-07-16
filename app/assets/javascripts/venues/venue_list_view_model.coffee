class LunchApp.VenueListViewModel
  constructor: ->
    @venueArray = ko.observableArray()

    @newVenue = ko.observable new LunchApp.VenueViewModel { name: '', address: '', description: '' }
    @errors = ko.observable {}

    @winner = ko.observable()
    @winnerIsShowing = ko.observable false
    @isLoading = ko.observable true
    @isLoaded = ko.observable false
    @isShowingAddVenue = ko.observable true
    @isShowingVenueList = ko.observable true

    @toggleAddVenue = (data, event) =>
      @isShowingAddVenue(!@isShowingAddVenue())
      $("html, body").animate({ scrollTop: $(event.currentTarget).offset().top }, 1000)


    getWinnerSuccess = (venue) =>
      if venue != null
        @winner(venue.name)
        @winnerIsShowing(true)

    @showingWinner = () =>
      @today = new Date()
      @dayOfWeek = @today.getDay()
      if @dayOfWeek == 3
        @currentHour = @today.getHours()
        if @currentHour >= 9
          LunchApp.Ajax.get '/venues/winner/get_winner', getWinnerSuccess

    @toggleVenueList = => @isShowingVenueList(!@isShowingVenueList())

    loadSuccess = (venueData) =>
      @newVenue(new LunchApp.VenueViewModel { name: '', address: '', description: '' })
      @isLoading(false)
      @isLoaded(true)
      @errors({});
      @venueArray(venueData.map((e) -> new LunchApp.VenueViewModel(e)))

    @loadVenues = =>
      @isLoading(true)
      this.showingWinner()
      LunchApp.Ajax.get '/venues.json', loadSuccess

    @addVenue = =>
      @isLoading(true)

      error = (errorBlob, status) => @errors($.parseJSON(errorBlob.responseText).errors)
      data = { venue: { name: @newVenue().name(), description: @newVenue().description(), address: @newVenue().address() } }

      LunchApp.Ajax.post '/venues', data, loadSuccess, error

    @loadVenues()
