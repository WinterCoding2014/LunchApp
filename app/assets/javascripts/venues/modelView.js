var onReady = function() {
	//viewModel.js

    function venue(data) {
    this.venueName = ko.observable(data.venueName);
    this.venueDesptn = ko.observable(data.venueDesptn);
    this.venueAddress = ko.observable(data.venueAddress);
    }

	function VenueViewModel() {  
    //data
    var self = this;
    // Non-editable catalog data - would come from the server
    self.venues = ko.observableArray([    
        { venueName: 'Nandos' , venueDesptn: 'Flame-grilled PERi-PERi chicken ', venueAddress: '  811 Hay St'},
        { venueName: 'Subway' , venueDesptn: 'Eat Fresh', venueAddress: '16a/1490 Albany Hwy'},
        { venueName: 'Nao Japanese Restaurant' , venueDesptn: 'soup base, ramen noodles', venueAddress: '117 Murray St'}

    ]); 
   self.newVenue = ko.observable();
   self.newDesptn = ko.observable();
   self.newAddress = ko.observable();

   //operations
   self.addVenue = function() {
        self.venues.push(new venue({ venueName: this.newVenue(), venueDesptn: this.newDesptn(), venueAddress: this.newAddress()}));
        self.newVenue("");
        self.newDesptn("");
        self.newAddress("");
     };
    }
   
    ko.applyBindings(new VenueViewModel());
	
};

$(onReady);




