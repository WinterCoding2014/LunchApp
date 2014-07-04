ko.bindingHandlers.slideVisible = {
  update: function (element, valueAccessor, allBindings) {
    var value = valueAccessor();
    var valueUnwrapped = ko.unwrap(value);
    console.log("Update: setting visibility to " + valueUnwrapped);
    var duration = allBindings.get('slideDuration') || 1000;

    if (valueUnwrapped == true) {
      $(element).slideDown(duration);
    }
    else {
      $(element).slideUp(duration);
    }
  }
};
