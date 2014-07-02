var onReady = function () {
    //viewModel.js

    //This should load the database rows into the table on the venueList page automatically
    function AppViewModel() {
        var self = this;
        self.venueArray = ko.observableArray();
        self.loadVenues = function () {
            $.ajax(
                {
                    type: 'GET',
                    url: '/venues.json',
                    dataType: "json",
                    success: function (venueData) {
                        self.venueArray(venueData);
                    }
                });
        };

        self.newVenue = ko.observable();
        self.newDesptn = ko.observable();
        self.newAddress = ko.observable();

        self.addVenue = function () {
            /*self.venues.push(new venue({ venueName: this.newVenue(), venueDesptn: this.newDesptn(), venueAddress: this.newAddress()}));*/
            //Add AJAX POST here
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
    ko.applyBindings(new AppViewModel());
};

$(onReady);




