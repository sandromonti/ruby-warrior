# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
move_spartacus = -> $('#spartacus').animate {
  left: '+=100'
}, 1000

call_server = -> $.ajax '/verify_move',
                  type: 'GET'
                  dataType: 'JSON'
                  success: (data) ->
                    if(data == true)
                      move_spartacus();
                  error: (data) ->
                    alert(data)

$(document).ready ->
  setInterval () ->
    call_server()
  , 1000