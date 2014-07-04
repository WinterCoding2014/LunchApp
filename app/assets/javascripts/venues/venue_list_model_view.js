

function VenueListViewModel() {
  var self = this;
  self.venueArray = ko.observableArray();
  self.newVenue = ko.observable();
  self.newDesptn = ko.observable();
  self.newAddress = ko.observable();
  self.isLoading = ko.observable(true);
  self.isLoaded = ko.observable(false);


  self.loadVenues = function () {
    self.isLoading(true);
    $.ajax(
        {
          type:'GET',
          url:'/venues.json',
          dataType:"json",
          success:function (venueData) {
            self.isLoading(false);
            self.isLoaded(true);
            self.venueArray(venueData);
          }
        });
  };

  self.addVenue = function () {
    $.ajax(
        {
          type:'POST',
          url:'/venues',
          data:{ venue:{name:this.newVenue(), description:this.newDesptn(), address:this.newAddress()}},
          dataType:"JSON",
          success:function (venueData) {
            self.venueArray(venueData);
          },
          error:function (request, status, error) {
            alert("Things broke");
          }

        });

    self.newVenue("");
    self.newDesptn("");
    self.newAddress("");

  };

  self.loadVenues();
}
