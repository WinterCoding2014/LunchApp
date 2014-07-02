var onReady = function () {
    //viewModel.js

    //This should load the database rows into the table on the venueList page automatically
    function VenueListViewModel() {
        var self = this;
        self.venueArray = ko.observableArray();
        self.newVenue = ko.observable();
        self.newDesptn = ko.observable();
        self.newAddress = ko.observable();
        self.isLoading = ko.observable(true);

        self.loadVenues = function () {
            self.isLoading(true);
            $.ajax(
                {
                    type: 'GET',
                    url: '/venues.json',
                    dataType: "json",
                    success: function (venueData) {
                        self.isLoading(false);
                        self.venueArray(venueData);
                    }
                });
        };

        self.addVenue = function () {
            /*self.venues.push(new venue({ venueName: this.newVenue(), venueDesptn: this.newDesptn(), venueAddress: this.newAddress()}));*/
            $.ajax(
                {
                    type: 'POST',
                    url: '/venues',
                    data: { venue: {name: this.newVenue(), description: this.newDesptn(), address: this.newAddress()}},
                    dataType: "JSON",
                    success: function (data) {
                        self.venueArray.push(data);
                     },
                    error: function(request, status, error) {
                        alert("Things broke");
                    }

                });

            self.newVenue("");
            self.newDesptn("");
            self.newAddress("");
        };

        self.loadVenues();

       /* function venue(venueData) {
            this.venueName = ko.observable(venueData.name);
            this.venueDesptn = ko.observable(venueData.description);
            this.venueAddress = ko.observable(venueData.address);
        }*/
    }
    ko.applyBindings(new VenueListViewModel());
};

$(onReady);




