# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
randomPlayer = ->
  players = [document.getElementById("player1").value, document.getElementById("player2").value, document.getElementById("player3").value, document.getElementById("player4").value]
  
  #document.getElementById("player5").value,
  #document.getElementById("player6").value 
  
  #Takes random player from players array, then removes that player from the array
  randomPlayer1 = players[Math.floor(Math.random() * players.length)]
  index = players.indexOf(randomPlayer1)
  players.splice index, 1
  randomPlayer2 = players[Math.floor(Math.random() * players.length)]
  index2 = players.indexOf(randomPlayer2)
  players.splice index2, 1
  randomPlayer3 = players[Math.floor(Math.random() * players.length)]
  index3 = players.indexOf(randomPlayer3)
  players.splice index3, 1
  randomPlayer4 = players[Math.floor(Math.random() * players.length)]
  index4 = players.indexOf(randomPlayer4)
  players.splice index4, 1
  
  #No Offense or Defense Assign
  if document.getElementById("assignTeam").checked is false
    document.getElementById("redTeam").innerHTML = randomPlayer1 + " & " + randomPlayer2
    document.getElementById("blueTeam").innerHTML = randomPlayer3 + " & " + randomPlayer4
  
  #Offense and Defense are assigned
  else
    document.getElementById("redTeam").innerHTML = "Offense: " + randomPlayer1 + " & " + "Defense: " + randomPlayer2
    document.getElementById("blueTeam").innerHTML = "Offense: " + randomPlayer3 + " & " + "Defense: " + randomPlayer4

$ ->
	$('#new_game_button').on 'click', () ->
		$(".modal").show()
		$("#centered_form.new_game").show()

	$("body").on 'click', '.modal', () ->
		$('.modal').hide()
		$("#centered_form.new_player").hide()
		$("#centered_form.new_game").hide()
		$("#centered_form.random_game").hide()
		$("#centered_form.season").hide()
		$("#centered_form.statistics").hide()
		$("#centered_form.edit-player").hide()

	$('#new_player_button').on 'click', () ->
		$(".modal").show()
		$("#centered_form.new_player").show()

	$('#random_game_button').on 'click', () ->
		$(".modal").show()
		$("#centered_form.random_game").show()

	$('#new_season_button').on 'click', () ->
		$(".modal").show()
		$("#centered_form.season").show()

	$('td.name').on 'click', () ->
		divSelector = ".statistics[player_id=" + this.parentElement.id + "]"
		$(".modal").show()
		$(divSelector).show()

	$('.statistics .close').on 'click', () ->
		$(".modal").hide()
		$("#centered_form.statistics").hide()

	$('.edit-player-link').on 'click', () ->
		divSelector = ".edit-" + this.attributes['player_id'].value
		$(this).parent().hide()
		$(divSelector).show()

	foo = 1