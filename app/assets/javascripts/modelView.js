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

            $.ajax(
                {
                    type: 'POST',
                    url: '/venues',
                    data: {name: this.newVenue(), description: this.newDesptn(), address: this.newAddress()},
                    dataType: "JSON",
                    success: function () {
                        alert("Callback function triggered")
                     },
                    error: function(request, status, error) {
                        alert("Things broke")
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
    ko.applyBindings(new AppViewModel());
};

$(onReady);




