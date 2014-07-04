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
  self.newVenue = ko.observable();
  self.newDesptn = ko.observable();
  self.newAddress = ko.observable();
  self.isLoading = ko.observable(true);
  self.isLoaded = ko.observable(false);
  self.isShowingJojosSpecialThing = ko.observable(false);

  self.toggleJojosThing = function () {
    self.isShowingJojosSpecialThing(!self.isShowingJojosSpecialThing());
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

  self.addVenue = function () {
    $.ajax(
        {
          type: 'POST',
          url: '/venues',
          data: { venue: {name: this.newVenue(), description: this.newDesptn(), address: this.newAddress()}},
          dataType: "JSON",
          success: function (venueData) {
            self.venueArray(venueData.map(function (e) {
              return new VenueViewModel(e);
            }));
          },
          error: function (request, status, error) {
            alert("Things broke");
          }

        });

    self.newVenue("");
    self.newDesptn("");
    self.newAddress("");

  };

  self.loadVenues();
}
