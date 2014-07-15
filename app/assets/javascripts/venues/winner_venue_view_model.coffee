#class LunchApp.WinnerVenueViewModel
#  constructor: ->
#
#    alert "view model is constructed"
#    @winnerIsShowing = ko.observable false
#
#    @showingWinner = () =>
#      returnVal = false
#      @today = new Date()
#      @dayOfWeek = @today.getDay()
#      alert @dayOfWeek
#      if @dayOfWeek == 5
#        @currentHour = @today.getHours()
#        if @currentHour >= 11
#          returnVal = true
#          alert "GOT HERE"
#          @winnerIsShowing(true)
#      alert returnVal
#      return returnVal
#
#    this.showingWinner()
#    alert "after the call"
