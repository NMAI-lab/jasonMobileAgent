// Demo program of Jason based navigation using A*

!missionTo(d).

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

{ include("batteryManager.asl") }

+!missionTo(Destination)
	<-	+missionTo(Destination)
		!navigate(Destination);
		.stopMAS.

// Perception of a path provided by the environment based navigation support
+path(Path)
	:	startTime(Start)
	<-	.print((system.time - Start), " ms route(",Path,")");
		.broadcast(tell, path(elapsed(system.time - Start), route(Path)));
		-route(_);	// Get rid of any old routes.
		+route(Path).

// Case where we are already at the destination
+!navigate(Destination)
	:	position(X,Y) & locationName(Destination,[X,Y])
		& startTime(Start)
	<-	.broadcast(tell, navigate(elapsed(system.time - Start), arrived(Destination)));
		-destinaton(Destination).

// We have a route path, set the waypoints.
+!navigate(Destination)
	:	route(Path)
		& startTime(Start)
	<-	.broadcast(tell, navigate(elapsed(system.time - Start), route(Path)));
		for (.member(NextPosition, Path)) {
			!waypoint(NextPosition);
		}
		-route(Path);
		!navigate(Destination).
		
// We don't have a route plan, get one.
+!navigate(Destination)
	:	position(X,Y) & locationName(Current,[X,Y])
	<-	Start = system.time;
		+startTime(Start);				// Get initial time stamp, for benchmarking performance
		.broadcast(tell, navigate(elapsed(system.time - Start), getPath(Destination)));
		.broadcast(tell, navigate(elapsed(system.time - Start), current(Current)));
		+destination(Destination);
		getPath(Current,Destination);
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
		& not obstacle(Direction)
		& startTime(Start)
	<-	.broadcast(tell, waypoint(elapsed(system.time - Start), move(Destination,NextPosition)));
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
+!waypoint(Next)
	:	startTime(Start)
	<-	.broadcast(tell, waypoint(elapsed(system.time - Start), default)).

// Revisit map update later.

+!updateMap(NextName)
	:	position(X,Y) & locationName(PositionName, [X,Y]) 
		& missionTo(Destination)
		& startTime(Start)
	<-	.broadcast(tell, updateMap(elapsed(system.time - Start), obstacle(NextName)));
		-possible(PositionName,NextName);
		setObstacle(PositionName,NextName);
		.drop_all_intentions;
		!missionTo(Destination).
		
//+!updateMap(NextName)
//	:	startTime(Start)
//	<-	.broadcast(tell, updateMap(elapsed(system.time - Start), default)).
//		!updateMap(NextName).
	


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

