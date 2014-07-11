class LunchApp.VenueListViewModel
  constructor: ->
    @venueArray = ko.observableArray()

    @newVenue = ko.observable new LunchApp.VenueViewModel { name: '', address: '', description: '' }
    @errors = ko.observable {}

    @isLoading = ko.observable true
    @isLoaded = ko.observable false
    @isShowingAddVenue = ko.observable true
    @isShowingVenueList = ko.observable true

    @toggleAddVenue = (data, event) =>
      @isShowingAddVenue(!@isShowingAddVenue())
      $("html, body").animate({ scrollTop: $(event.currentTarget).offset().top }, 1000)

    @toggleVenueList = => @isShowingVenueList(!@isShowingVenueList())

    loadSuccess = (venueData) =>
      @newVenue(new LunchApp.VenueViewModel { name: '', address: '', description: '' })
      @isLoading(false)
      @isLoaded(true)
      @errors({});
      @venueArray(venueData.map((e) -> new LunchApp.VenueViewModel(e)))

    @loadVenues = =>
      @isLoading(true)
      LunchApp.Ajax.get '/venues.json', loadSuccess

    @addVenue = =>
      @isLoading(true)

      error = (errorBlob, status) => @errors($.parseJSON(errorBlob.responseText).errors)
      data = { venue: { name: @newVenue().name(), description: @newVenue().description(), address: @newVenue().address() } }

      LunchApp.Ajax.post '/venues', data, loadSuccess, error

    @loadVenues()
