// Demo program of Jason based navigation using A*

!navigate(d).

/*
+!navigate
	<-	InitRule = system.time;		// Get initial time stamp, for benchmarking performance
		
		// a_star(InitialState, Goal, Solution, Cost) 
		?a_star(a,d,Solution,Cost);
		
		// Print the results
		.print("solution A* =", Solution, " with cost ",Cost," in ", (system.time - InitRule), " ms.");
		.
*/

// Case where we are already at the destination
+!navigate(Destination)
	:	position(X,Y) & locationName(Destination,[X,Y])
	<-	.print("Made it to the destination!").

// We don't have a route plan, get one and set the waypoints.
+!navigate(Destination)
	:	position(X,Y) & locationName(Current,[X,Y])
	<-	?a_star(Current,Destination,Solution,Cost);
//		.print(Solution);
		for (.member( op(Direction,NextPosition), Solution)) {
			!waypoint(Direction);
		}
		!navigate(Destination).

	
// Move through the map, if possible.
+!waypoint(Direction)
	:	isDirection(Direction)
	<-	move(Direction).

// Deal with case where Direction is not a valid way to go.
+!waypoint(Direction).
		

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
