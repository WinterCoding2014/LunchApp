class LunchApp.VenueListViewModel
  constructor: ->
    @venueArray = ko.observableArray()
    @newVenue = ko.observable ""
    @newDesptn = ko.observable ""
    @newAddress = ko.observable ""
    @isLoading = ko.observable true
    @isLoaded = ko.observable false
    @isShowingAddVenue = ko.observable false
    @isShowingVenueList = ko.observable true

    @errors = ko.observable {}

    @toggleAddVenue = (data, event) =>
      @isShowingAddVenue(!@isShowingAddVenue())
      $("html, body").animate({ scrollTop: $(event.currentTarget).offset().top }, 1000)


    @toggleVenueList = (data, event) =>
      @isShowingVenueList(!@isShowingVenueList())

    @loadVenues = =>
      @isLoading(true)
      $.ajax({
        type: 'GET',
        url: '/venues.json',
        dataType: "json",
        success: (venueData) =>
          @isLoading(false)
          @isLoaded(true)
          @venueArray(venueData.map((e)-> new LunchApp.VenueViewModel(e)))
      })

    @addVenue = =>
      $.ajax(
        {
          type: 'POST',
          url: '/venues',
          data: { venue: {name: @newVenue(), description: @newDesptn(), address: @newAddress()}},
          dataType: "JSON",
          success: (venueData) =>
            @newVenue("");
            @newDesptn("");
            @newAddress("");
            @errors({});
            @venueArray(venueData.map((e) -> new LunchApp.VenueViewModel(e)))
          ,
          error: (errorBlob, status) =>
            @errors($.parseJSON(errorBlob.responseText).errors);
        })

    @loadVenues()
