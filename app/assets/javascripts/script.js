function randomPlayer (){


var players = [ document.getElementById("player1").value, 
			  	document.getElementById("player2").value, 
			   	document.getElementById("player3").value,
			   	document.getElementById("player4").value
			   	//document.getElementById("player5").value,
			   	//document.getElementById("player6").value 
			  ]


			  //Takes random player from players array, then removes that player from the array

			  var randomPlayer1 = players[Math.floor(Math.random() * players.length)];
			  var index = players.indexOf(randomPlayer1);
			  players.splice(index,1);

			  var randomPlayer2 = players[Math.floor(Math.random() * players.length)];
			  var index2 = players.indexOf(randomPlayer2);
			  players.splice(index2,1);

			  var randomPlayer3 = players[Math.floor(Math.random() * players.length)];
			  var index3 = players.indexOf(randomPlayer3);
			  players.splice(index3,1);

			  var randomPlayer4 = players[Math.floor(Math.random() * players.length)];
			  var index4 = players.indexOf(randomPlayer4);
			  players.splice(index4,1);

			  
			  //No Offense or Defense Assign
			 
			 if(document.getElementById("assignTeam").checked === false){

			 	document.getElementById("redTeam").innerHTML  = randomPlayer1 + " & " + randomPlayer2;
			 	document.getElementById("blueTeam").innerHTML = randomPlayer3 + " & " + randomPlayer4;				
				

			}
			 //Offense and Defense are assigned
			
			else{

			 	document.getElementById("redTeam").innerHTML = "Offense: " + randomPlayer1 + " & " + "Defense: " + randomPlayer2;
			 	document.getElementById("blueTeam").innerHTML = "Offense: " + randomPlayer3 + " & " + "Defense: " + randomPlayer4;
	
			}

}