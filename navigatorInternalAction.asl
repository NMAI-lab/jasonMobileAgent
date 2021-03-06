// Demo program of Jason based navigation using A*

//!missionTo(d).
!start.

/*
// Benchmark version
+path(Path)
	:	startTime(StartTime)
	<-	// Print the results
		.print("solution A* =", Path, " in ", (system.time - StartTime), " ms.");
		+done.

+!navigate(Destination)
	: 	(not done)
	<-	+startTime(system.time);		// Get initial time stamp, for benchmarking performance
		getPath(a,Destination);
		!navigate(Destination).

+!navigate(_) <- .print("Done").
*/

{ include("obstacleHandler.asl")}
{ include("batteryManager.asl") }

+!start
	<-	.wait(10000);
		!missionTo(d).

+!missionTo(Destination)
	<-	+missionTo(Destination)
		!navigate(Destination).

// Case where we are already at the destination
+!navigate(Destination)
	:	position(X,Y) & locationName(Destination,[X,Y])
		& startTime(Start)
	<-	.broadcast(tell, navigate(elapsed(system.time - Start), arrived(Destination)));
		-destinaton(Destination);
		-route(Path);.
		//.stopMAS.

// We are not at the destination, set the waypoints.
+!navigate(Destination)
	:	position(X,Y) 
		& locationName(Current,[X,Y])
	<-	Start = system.time;
		+startTime(Start);				// Get initial time stamp, for benchmarking performance
		+destination(Destination);
		.broadcast(tell, navigate(elapsed(system.time - Start), gettingRoute(Destination)));
		.broadcast(tell, navigate(elapsed(system.time - Start), current(Current)));
		navigationInternalAction.getPath(Current,Destination,Path);
		.print((system.time - Start), " ms navigate(route(",Path,"))");
		.broadcast(tell, navigate(elapsed(system.time - Start), route(Path)));
		for (.member(NextPosition, Path)) {
			!waypoint(NextPosition);
		}
		!navigate(Destination).	

+!navigate(Destination)
	:	startTime(Start)
	<-	.broadcast(tell, navigate(elapsed(system.time - Start), default));
		!navigate(Destination).

// Move through the map, if possible.
+!waypoint(NextPosition)
	:	position(X,Y) & locationName(Current,[X,Y])
		& possible(Current,NextPosition)
		& direction(Current,NextPosition,Direction)
		& map(Direction)
		& (not obstacle(Direction))
		& startTime(Start)
	<-	.broadcast(tell, waypoint(elapsed(system.time - Start), move(Direction,NextPosition)));
		move(Direction).
	
// Move through the map, if possible.
+!waypoint(NextPosition)
	:	position(X,Y) & locationName(Current,[X,Y])
		//& possible(Current,NextPosition)
		& direction(Current,NextPosition,Direction)
		& map(Direction)
		& obstacle(Direction)
		& startTime(Start)
	<-	.broadcast(tell, waypoint(elapsed(system.time - Start), obstacle(NextPosition)));
		!updateMap(NextPosition).
		
// Deal with case where Direction is not a valid way to go.
+!waypoint(_) 
	:	startTime(Start)
	<-	.broadcast(tell, waypoint(elapsed(system.time - Start), default)).


+!updateMap(NextName)
	:	position(X,Y) & locationName(PositionName, [X,Y]) 
		& missionTo(Destination)
		& startTime(Start)
	<-	.broadcast(tell, updateMap(elapsed(system.time - Start), obstacle(NextName)));
		-possible(PositionName,NextName);
		navigationInternalAction.setObstacle(PositionName,NextName);
		.drop_all_intentions;
		!missionTo(Destination).


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

// Map of locations that the agent can visit.
{ include("map.asl") }

