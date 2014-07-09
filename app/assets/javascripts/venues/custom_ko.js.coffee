ko.bindingHandlers.slideVisible = {
  update: (element, valueAccessor, allBindings) ->
    duration = allBindings.get('slideDuration') || 200
    if ko.unwrap(valueAccessor())
      $(element).slideDown(duration)
    else
      $(element).slideUp(duration)
}