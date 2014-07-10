class LunchApp.VenueListViewModel
  constructor: ->
    @venueArray = ko.observableArray()

    @newVenue = ko.observable new LunchApp.VenueViewModel {name:'',address:'',description:''}
    @errors = ko.observable {}

    @isLoading = ko.observable true
    @isLoaded = ko.observable false
    @isShowingAddVenue = ko.observable false
    @isShowingVenueList = ko.observable true

    @toggleAddVenue = (data, event) =>
      @isShowingAddVenue(!@isShowingAddVenue())
      $("html, body").animate({ scrollTop: $(event.currentTarget).offset().top }, 1000)

    @toggleVenueList = => @isShowingVenueList(!@isShowingVenueList())

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
      @isLoading(true)
      $.ajax({
          type: 'POST',
          url: '/venues',
          data: { venue: {name: @newVenue().name(), description: @newVenue().description(), address: @newVenue().address()}},
          dataType: "JSON",
          success: (venueData) =>
            @isLoading(false)
            @isLoaded(true)
            @newVenue(new LunchApp.VenueViewModel {name:'',address:'',description:''})
            @errors({});
            @venueArray(venueData.map((e) -> new LunchApp.VenueViewModel(e)))
          ,
          error: (errorBlob, status) =>
            @errors($.parseJSON(errorBlob.responseText).errors);
        })

    @loadVenues()
