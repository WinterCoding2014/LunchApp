class LunchApp.VenueListViewModel
  constructor: ->
    @venueArray = ko.observableArray()
    @orderArray = ko.observableArray()

    @newVenue = ko.observable new LunchApp.VenueViewModel { name: '', address: '', description: '', menu_link: '' }
    @newOrder = ko.observable()
    @errors = ko.observable {}

    @winner = ko.observable()
    @savedOrder = ko.observable()
    @orderListIsShowing = ko.observable false;
    @submitFormIsShowing = ko.observable true;
    @editFormIsShowing = ko.observable false;
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
      if @dayOfWeek == 5
        @currentHour = @today.getHours()
        if @currentHour >= 11
          LunchApp.Ajax.get '/venues/winner/get_winner', getWinnerSuccess
          LunchApp.Ajax.get '/venues/order/order', loadOrderSuccess


    @toggleVenueList = => @isShowingVenueList(!@isShowingVenueList())

    loadSuccess = (venueData) =>
      @newVenue(new LunchApp.VenueViewModel { name: '', address: '', description: '' , menu_link: ''})
      @isLoading(false)
      @isLoaded(true)
      @errors({});
      @venueArray(venueData.map((e) -> new LunchApp.VenueViewModel(e)))


    @loadVenues = =>
      @isLoading(true)
      this.showingWinner()
      LunchApp.Ajax.get '/venues.json', loadSuccess

    @loadOrdersCheck = =>
      @today = new Date()
      @dayOfWeek = @today.getDay()
      if @dayOfWeek == 5
        @currentHour = @today.getHours()
        if @currentHour == 11
           @currentMinute = @today.getMinutes()
           if @currentMinute >= 45
             loadOrders()
        else if @currentHour > 11
          loadOrders()


    loadOrders = () =>
      LunchApp.Ajax.get '/venues/order/orders.json', loadOrderListSuccess

    loadOrderListSuccess = (orderData) =>
      @orderArray(orderData)
      @submitFormIsShowing(false)
      @editFormIsShowing(false)
      @orderListIsShowing(true)

    @addVenue = =>
      @isLoading(true)

      error = (errorBlob, status) => @errors($.parseJSON(errorBlob.responseText).errors)
      data = { venue: { name: @newVenue().name(), description: @newVenue().description(), address: @newVenue().address(), menu_link:@newVenue().menu_link() } }

      LunchApp.Ajax.post '/venues', data, loadSuccess, error

    loadOrderSuccess = (orderData) =>
      if orderData != null
        @savedOrder(orderData.content)
        @submitFormIsShowing(false)
        @editFormIsShowing(true)

    @submitOrder = =>
      if @newOrder() != undefined
        $.ajax(
                {
                  type: 'PUT',
                  url: '/venues/order/place_order',
                  data: {content: @newOrder()},
                  dataType: "json",
                  success: () =>
                    LunchApp.Ajax.get '/venues/order/order', loadOrderSuccess
                  error: (errorBlob, status) =>
                    alert 'There was a problem saving your order.'
                })
      else
        alert "Order cannot be blank!"

    @editOrder = =>
      @submitFormIsShowing(true)
      @editFormIsShowing(false)
    @loadVenues()
    @loadOrdersCheck()
