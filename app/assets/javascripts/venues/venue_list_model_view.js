function VenueViewModel(entry) {
  var self = this;

  var fn = function (k) {
    self[k] = ko.observable(entry[k]);
  };

  Object.keys(entry).forEach(fn);

  self.initial = ko.computed(function () {
    return self.name()[0];
  });
}

function VenueListViewModel() {
  var self = this;
  self.venueArray = ko.observableArray();
  self.newVenue = ko.observable("");
  self.newDesptn = ko.observable("");
  self.newAddress = ko.observable("");
  self.isLoading = ko.observable(true);
  self.isLoaded = ko.observable(false);
  self.isShowingAddVenue = ko.observable(false);
  self.isShowingVenueList = ko.observable(true);

  self.errors = ko.observable({});


  self.toggleAddVenue = function (data, event) {
    self.isShowingAddVenue(!self.isShowingAddVenue());
//    $.scrollBottom();
    $("html, body").animate({ scrollTop: $(event.currentTarget).offset().top },1000);

  };

  self.toggleVenueList = function (data, event) {
    self.isShowingVenueList(!self.isShowingVenueList());
  };

  self.loadVenues = function () {
    self.isLoading(true);
    $.ajax(
        {
          type: 'GET',
          url: '/venues.json',
          dataType: "json",
          success: function (venueData) {
            self.isLoading(false);
            self.isLoaded(true);
            self.venueArray(venueData.map(function (e) {
              return new VenueViewModel(e);
            }));
          }
        });
  };

  self.createVenueObject = function () {
    venue = {name: self.newVenue(), description: self.newDesptn(), address: self.newAddress()};
  };

  self.addVenue = function () {


    self.createVenueObject();
    $.ajax(
        {
          type: 'POST',
          url: '/venues',
          data: { venue: {name: self.newVenue(), description: self.newDesptn(), address: self.newAddress()}},
          dataType: "JSON",
          success: function (venueData) {
            self.newVenue("");
            self.newDesptn("");
            self.newAddress("");
            self.errors({});
            self.venueArray(venueData.map(function (e) {
              return new VenueViewModel(e);
            }));
          },
          error: function (errorBlob, status) {
            var errors = $.parseJSON(errorBlob.responseText).errors;
            self.errors(errors);
          }

        });

  };

  self.loadVenues();
}
