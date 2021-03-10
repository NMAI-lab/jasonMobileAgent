// Demo program of Jason based navigation using A*

!missionTo(d)[priority(3)].
//!start[priority(3)].

/*
+!navigate
	<-	InitRule = system.time;		// Get initial time stamp, for benchmarking performance
		
		// a_star(InitialState, Goal, Solution, Cost) 
		?a_star(a,d,Solution,Cost);
		
		// Print the results
		.print("solution A* =", Solution, " with cost ",Cost," in ", (system.time - InitRule), " ms.");
		.
*/

{ include("obstacleHandler.asl")}
{ include("batteryManager.asl") }

+!start
	<-	.wait(10000);
		!missionTo(d)[priority(3)].


+!missionTo(Destination)
	<-	+missionTo(Destination)
		!navigate(Destination)[priority(3)].


// Case where we are already at the destination
+!navigate(Destination)
	:	position(X,Y) 
		& locationName(Destination,[X,Y])
		& startTime(Start)
	<-	.broadcast(tell, navigate(elapsed(system.time - Start), arrived(Destination)));
		-destinaton(Destination).
		//-startTime(_);
		//.stopMAS.

// We don't have a route plan, get one and set the waypoints.
+!navigate(Destination)
	:	position(X,Y) & locationName(Current,[X,Y])
	<-	Start = system.time;
		+startTime(Start);				// Get initial time stamp, for benchmarking performance
		.broadcast(tell, navigate(elapsed(system.time - Start), gettingRoute(Destination)));
		.broadcast(tell, navigate(elapsed(system.time - Start), current(Current)));
		+destination(Destination);
		?a_star(Current,Destination,Solution,Cost);
		.broadcast(tell, navigate(elapsed(system.time - Start), route(Solution)));
		for (.member( op(Direction,NextPosition), Solution)) {
			!waypoint(Direction,NextPosition)[priority(3)];
		}
		!navigate(Destination)[priority(3)].

// Show that a default plan (no context) is lowest priority
+!waypoint(_,_)
	<-	.broadcast(tell, waypoint(never,never,never)).
		
// Move through the map, if possible.
+!waypoint(Direction,_)
	:	isDirection(Direction)
		& map(Direction)
		& not obstacle(Direction)
		& startTime(Start)
	<-	move(Direction);
		.broadcast(tell, waypoint(elapsed(system.time - Start), move(Direction))).
	
// Move through the map, if possible.
+!waypoint(Direction, Next)
	:	isDirection(Direction)
		& map(Direction)
		& obstacle(Direction)
		& startTime(Start)
	<-	.broadcast(tell, waypoint(elapsed(system.time - Start), updateMap(Direction,Next)));
		!updateMap(Direction, Next)[priority(4)].

// Deal with case where Direction is not a valid way to go.
+!waypoint(_,_)
	:	startTime(Start)
	<-	.broadcast(tell, waypoint(elapsed(system.time - Start), waypoint(default))).

+!updateMap(Direction, NextName)
	:	position(X,Y)
		& locationName(PositionName, [X,Y])
		& possible(PositionName,NextName)
		& missionTo(Destination)
		& startTime(Start)
	<-	-possible(PositionName,NextName)
		.broadcast(tell, updateMap(elapsed(system.time - Start), Direction, NextName));
		.drop_all_intentions;
		!missionTo(Destination)[priority(3)].
	
+!updateMap(Direction,NextName)
	:	startTime(Start)
	<-	.broadcast(tell, updateMap(elapsed(system.time - Start), default, Direction,NextName));
		!updateMap(Direction,NextName)[priority(4)].
		

// Check that Direction is infact a direction
isDirection(Direction) :- (Direction = up) |
						  (Direction = down) |
						  (Direction = left) |
						  (Direction = right).
		
		
/* The following two rules are domain dependent and have to be redefined accordingly */

// sucessor definition: suc(CurrentState,NewState,Cost,Operation)
suc(Current,Next,1,up) :- ([X2,Y2] = [X1,Y1-1]) & possible(Current,Next) & nameMatch(Current,[X1,Y1],Next,[X2,Y2]).
suc(Current,Next,1,down) :- ([X2,Y2] = [X1,Y1+1]) & possible(Current,Next) & nameMatch(Current,[X1,Y1],Next,[X2,Y2]).
suc(Current,Next,1,left) :- ([X2,Y2] = [X1-1,Y1]) & possible(Current,Next) & nameMatch(Current,[X1,Y1],Next,[X2,Y2]).
suc(Current,Next,1,right) :- ([X2,Y2] = [X1+1,Y1]) & possible(Current,Next) & nameMatch(Current,[X1,Y1],Next,[X2,Y2]).

nameMatch(Current,CurrentPosition,Next,NextPosition) :- locationName(Current,CurrentPosition) &
														  locationName(Next,NextPosition).

// Map of locations that the agent can visit.
{ include("map.asl") }

// heutistic definition: h(CurrentState,Goal,H)
h(Current,Goal,H) :- H = math.sqrt( ((X2-X1) * (X2-X1)) + ((Y2-Y1) * (Y2-Y1)) ) &
						 nameMatch(Current,[X1,Y1],Goal,[X2,Y2]).

{ include("a_star.asl") }

