# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
sleep = (ms) ->
  start = new Date().getTime()
  continue while new Date().getTime() - start < ms

move_spartacus = (delay, distance) -> setTimeout ( ->
    $('#spartacus').animate {
      left: '+=' + distance
    }, 1000
  ), delay

attack_spartacus = (delay) -> setTimeout ( ->
    attack_spartacus_front()
    setTimeout ( ->
      attack_spartacus_back()
    ), 500
  ), delay

attack_spartacus_front = -> $('#spartacus').animate {
  left: '+=50'
}, 500

attack_spartacus_back = -> $('#spartacus').animate {
  left: '-=50'
}, 500

heal_spartacus = (delay) -> setTimeout ( ->
  heal_spartacus_up()
  setTimeout ( ->
    heal_spartacus_down()
  ), 1000
  add_spartacus_health(2)
), delay

heal_spartacus_up = -> $('#spartacus').css('backgroundImage', "url('/assets/8_tiles_board_healing_spartacus.png')")

heal_spartacus_down = -> $('#spartacus').css('backgroundImage', "url('/assets/8_tiles_board_spartacus.png')")

remove_spartacus_health = (health) ->
  $('#health').text(parseInt($('#health').text(), 10) - health)
  $("#damage_to_spartacus").fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100);

add_spartacus_health = (health) ->
  $('#health').text(parseInt($('#health').text(), 10) + health)
  $("#heal").fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100);

combat_melee_monster = (delay, tile) -> setTimeout ( ->
  attack_spartacus(0)
  attack_melee_monster(1000, tile)
  attack_spartacus(2000)
  attack_melee_monster(3000, tile)
  attack_spartacus(4000)
  kill_melee_monster(5000, tile)
), delay

attack_melee_monster = (delay, tile) -> setTimeout ( ->
  attack_melee_monster_front(tile)
  setTimeout ( ->
    attack_melee_monster_back(tile)
  ), 500
  remove_spartacus_health(3)
), delay

attack_melee_monster_front = (tile) -> $(".melee_monster.tile_#{tile}").animate {
  left: '-=50'
}, 500

attack_melee_monster_back = (tile) -> $(".melee_monster.tile_#{tile}").animate {
  left: '+=50'
}, 500

kill_melee_monster = (delay, tile) ->setTimeout ( ->
    $(".melee_monster.tile_#{tile}").animate {
      opacity: '0'
    }, 1000
  ), delay

remove_line_breaks = (text) ->
  return text.replace(/(\r\n|\n|\r)/gm,"");

is_code_level_2_valid = (code) ->
  if(remove_line_breaks(code) == "if warrior.feel.empty?warrior.walk!elsewarrior.attack!end")
    return true
  else
    return false

is_code_level_3_valid = (code) ->
  if(remove_line_breaks(code) == "if warrior.health < 10 && warrior.feel.empty?warrior.rest!elsif warrior.feel.empty?warrior.walk!elsewarrior.attack!end")
    return true
  else
    return false

run_level_1 = ->
  move_spartacus(0,100) for [1..6]
  setTimeout ( ->
    $('#overlay').toggle()
    $('#success_window').toggle()
  ), 6000

run_level_2 = ->
  move_spartacus(0,100) for [1..3]
  combat_melee_monster(3000, 5)
  setTimeout ( ->
    move_spartacus(0,100) for [1..3]
  ), 9000
  setTimeout ( ->
    $('#overlay').toggle()
    $('#success_window').toggle()
  ), 12000

run_level_3 = ->
  move_spartacus(0,89)
  combat_melee_monster(1000, 3)
  setTimeout ( ->
    move_spartacus(0,89) for [1..2]
  ), 7000
  combat_melee_monster(9000, 5)
  heal_spartacus(15000)
  move_spartacus(16000,89)
  combat_melee_monster(17000, 6)
  heal_spartacus(23000)
  heal_spartacus(25000)
  heal_spartacus(27000)
  setTimeout ( ->
    move_spartacus(0,89) for [1..2]
  ), 29000
  combat_melee_monster(31000, 8)
  heal_spartacus(37000)
  heal_spartacus(39000)
  heal_spartacus(41000)
  move_spartacus(43000,89)
  setTimeout ( ->
    $('#overlay').toggle()
    $('#success_window').toggle()
  ), 44000

load_level_2 = -> $(".level_2").click()

call_server = -> $.ajax '/verify_move',
  type: 'GET'
  dataType: 'JSON'
  success: (data) ->
    if(data == true)
      move_spartacus();
  error: (data) ->
    alert(data)

#$(document).ready ->
#setInterval () ->
#call_server()
#, 1000

root = exports ? this

root.toggle_error_window = ->
  $('#overlay').toggle()
  $('#error_window').toggle()

root.toggle_abilities = ->
  $('#abilities_frame').toggle()

root.toggle_code = ->
  $('#code_frame').toggle()
  $('.run_button').toggle()

root.check_code_level_1 = ->
  toggle_code()
  if (document.getElementById("code_frame").value == "warrior.walk!")
    run_level_1()
  else
    toggle_error_window()

root.check_code_level_2 = ->
  toggle_code()
  if (is_code_level_2_valid(document.getElementById("code_frame").value))
    run_level_2()
  else
    toggle_error_window()

root.check_code_level_3 = ->
  toggle_code()
  if (is_code_level_3_valid(document.getElementById("code_frame").value))
    run_level_3()
  else
    toggle_error_window()