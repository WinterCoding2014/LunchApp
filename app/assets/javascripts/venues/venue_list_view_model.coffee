class LunchApp.VenueListViewModel
  constructor: ->
    @venueArray = ko.observableArray()
    @orderArray = ko.observableArray()

    @newVenue = ko.observable new LunchApp.VenueViewModel { name: '', address: '', description: '', menu_link: '' }
    @newOrder = ko.observable()
    @errors = ko.observable {}

    @winner = ko.observable()
    @savedOrder = ko.observable()
    @orderListIsShowing = ko.observable false
    @submitFormIsShowing = ko.observable true
    @editFormIsShowing = ko.observable false
    @winnerIsShowing = ko.observable false
    @inOrNotIsShowing = ko.observable false
    @inOrNotChoiceShowing = ko.observable true
    @unhappyNotice= ko.observable (" ")
    @attendStatusText = ko.observable ("Are you in for lunch?")
    @isLoading = ko.observable true
    @isLoaded = ko.observable false
    @isShowingAddVenue = ko.observable true
    @isShowingVenueList = ko.observable true
    @isWinningSubsectionShowing = ko.observable false

    @toggleAddVenue = (data, event) =>
      @isShowingAddVenue(!@isShowingAddVenue())
      $("html, body").animate({ scrollTop: $(event.currentTarget).offset().top }, 1000)


    @toggleInOrNotShow = (data, event) =>
      toggleInOrNotShow()

    toggleInOrNotShow = () =>
      @inOrNotChoiceShowing(!@inOrNotChoiceShowing())

    @orderFlowControl = () =>
      @today = new Date()
      @dayOfWeek = @today.getDay()
      if @dayOfWeek == 5
        @currentHour = @today.getHours()
        if @currentHour < 11
          showingInOrNot()
        else if @currentHour ==11
          showingWinner()
          @currentMinute = @today.getMinutes()
          if @currentMinute >= 45
            loadOrders()
          else
            showingSavedOrder()
        else if @currentHour > 11
          showingWinner()
          loadOrders()

    showingInOrNot = () =>
      LunchApp.Ajax.get '/venues/attendee_status/get', getStatusSuccess
      @inOrNotIsShowing(true)

    @setUserStatus = (attend_status) =>
      $.ajax(
              {
                type: 'PUT',
                url: '/venues/attendee_status/set',
                data: { attend_status: attend_status }
                dataType: "json",
                success: () =>
                  setStatusSuccess()
                error: (errorBlob, status) =>
                  alert("There was a problem saving your status. Please try again")
              })

    setStatusSuccess = () =>
      showingInOrNot()

    getStatusSuccess = (status) =>
      if  status == undefined
        @attendStatusText("Are you in for lunch?")
      else if status == true
        @attendStatusText("I'm in for lunch")
        toggleInOrNotShow()
      else if status == false
        @attendStatusText("I'm not in for lunch")
        toggleInOrNotShow()


    showingWinner = () =>
      LunchApp.Ajax.get '/venues/winner/get_winner', getWinnerSuccess

    getWinnerSuccess = (venue) =>
      if venue != null
        @winner(venue.name)
        @inOrNotIsShowing(false)
        @winnerIsShowing(true)
        @isWinningSubsectionShowing(true)
        LunchApp.Ajax.get '/venues/happy_status/status', getHappySuccess
      else
        @winnerIsShowing(false)


    @toggleWinningSubsection = () =>
      @isWinningSubsectionShowing(!@isWinningSubsectionShowing())

    getHappySuccess = (happyStatus) =>
      if happyStatus == false
        @unhappyNotice("Bad luck! But your votes will count twice next week!")



    showingSavedOrder = () =>
      LunchApp.Ajax.get '/venues/order/order', loadOrderSuccess

    loadOrderSuccess = (orderData) =>
      if orderData != null
        @savedOrder(orderData.content)
        @submitFormIsShowing(false)
        @editFormIsShowing(true)

    loadOrders = () =>
      LunchApp.Ajax.get '/venues/order/orders.json', loadOrderListSuccess

    loadOrderListSuccess = (orderData) =>
      @orderArray(orderData)
      @winnerIsShowing(true)
      @submitFormIsShowing(false)
      @editFormIsShowing(false)
      @orderListIsShowing(true)


    @toggleVenueList = => @isShowingVenueList(!@isShowingVenueList())

    loadSuccess = (venueData) =>
      @newVenue(new LunchApp.VenueViewModel { name: '', address: '', description: '', menu_link: '' })
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
      data = { venue: { name: @newVenue().name(), description: @newVenue().description(), address: @newVenue().address(), menu_link: @newVenue().menu_link() } }

      LunchApp.Ajax.post '/venues', data, loadSuccess, error


    @submitOrder = =>
      if @newOrder() != undefined
        $.ajax(
                {
                  type: 'PUT',
                  url: '/venues/order/place_order',
                  data: { content: @newOrder() },
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
    @orderFlowControl()
