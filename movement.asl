

// Move through the map, if possible.
+!waypoint(NextPosition)
	:	position(X,Y) & locationName(Current,[X,Y])
		& possible(Current,NextPosition)
		& direction(Current,NextPosition,Direction)
		& map(Direction)
		& not obstacle(Direction)
		& startTime(Start)
	<-	.broadcast(tell, waypoint(elapsed(system.time - Start), move(Destination,NextPosition)));
		move(Direction).

// Deal with case where Direction is not a valid way to go.
+!waypoint(Next)
	:	startTime(Start)
	<-	.broadcast(tell, waypoint(elapsed(system.time - Start), default)).

// Get the direction of the next movement
direction(Current,Next,up)
	:-	possible(Current,Next)
		& locationName(Current,[X,Y])
		& locationName(Next,[X,Y-1]).

// Get the direction of the next movement
direction(Current,Next,down)
	:-	possible(Current,Next)
		& locationName(Current,[X,Y])
		& locationName(Next,[X,Y+1]).
		
// Get the direction of the next movement
direction(Current,Next,left)
	:-	possible(Current,Next)
		& locationName(Current,[X,Y])
		& locationName(Next,[X-1,Y]).		
		
// Get the direction of the next movement
direction(Current,Next,right)
	:-	possible(Current,Next)
		& locationName(Current,[X,Y])
		& locationName(Next,[X+1,Y]).	
