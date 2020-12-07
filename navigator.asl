// Demo program of Jason based navigation using A*

!navigate.
start(a).
finish(d).

+!navigate
	<-	InitRule = system.time;		// Get initial time stamp, for benchmarking performance
		
		// a_star(InitialState, Goal, Solution, Cost) 
		?a_star(a,d,Solution,Cost);
		
		// Print the results
		.print("solution A* =", Solution, " with cost ",Cost," in ", (system.time - InitRule), " ms.");
		.
/*

+!navigate
	:	start(Start) &
		finish(Finish)
	<-	?a_star(Start,Finish,Solution,Cost);
		move(right);
		for (.member( op(O,S), Solution)) {
			.print("   ",S," <-< ",O);
		}
		.
*/	

/* The following two rules are domain dependent and have to be redefined accordingly */

// sucessor definition: suc(CurrentState,NewState,Cost,Operation)
suc(Current,Next,1,up) :- ([X2,Y2] = [X1,Y1+1]) & possible(Current,Next) & nameMatch(Current,[X1,Y1],Next,[X2,Y2]).
suc(Current,Next,1,down) :- ([X2,Y2] = [X1,Y1-1]) & possible(Current,Next) & nameMatch(Current,[X1,Y1],Next,[X2,Y2]).
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
