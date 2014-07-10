class LunchApp.Ajax
  @get = (url, success, fail) ->
    $.ajax({
             type: 'GET',
             url: url,
             dataType: "json",
             success: success,
             fail: fail
           })

  @post = (url, data, success, fail) ->
    $.ajax({
             type: 'POST',
             url: url,
             data: data,
             dataType: "json",
             success: success,
             error: fail
           })