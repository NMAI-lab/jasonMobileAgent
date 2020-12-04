// Demo program of Jason based navigation using A*

!navigate.
start(a).
finish(d).

/*
+!navigate
	<-	InitRule = system.time;		// Get initial time stamp, for benchmarking performance
		
		// a_star(InitialState, Goal, Solution, Cost) 
		?a_star([0,0],[3,0],Solution,Cost);
		
		// Print the results
		.print("solution A* =", Solution, " with cost ",Cost," in ", (system.time - InitRule), " ms.");
		.
*/		

+!navigate
	:	start(Start) &
		finish(Finish) &
		locationName(Start,StartPosition) &
		locationName(Finish,FinishPosition)
	<-	?a_star(StartPosition,FinishPosition,Solution,Cost);
		for (.member( op(O,S), Solution)) {
			.print("   ",S," <-< ",O);
		}
		.
		

/* The following two rules are domain dependent and have to be redefined accordingly */

// sucessor definition: suc(CurrentState,NewState,Cost,Operation)
suc([X1,Y1],[X2,Y2],1,up) :- ([X2,Y2] = [X1,Y1+1]) & possible([X1,Y1],[X2,Y2]).
suc([X1,Y1],[X2,Y2],1,down) :- ([X2,Y2] = [X1,Y1-1]) & possible([X1,Y1],[X2,Y2]).
suc([X1,Y1],[X2,Y2],1,left) :- ([X2,Y2] = [X1-1,Y1]) & possible([X1,Y1],[X2,Y2]).
suc([X1,Y1],[X2,Y2],1,right) :- ([X2,Y2] = [X1+1,Y1]) & possible([X1,Y1],[X2,Y2]).

// Map of locations that the agent can visit.
{ include("map.asl") }

// heutistic definition: h(CurrentState,Goal,H)
h([StateX,StateY],[GoalX,GoalY],H) :- H = math.sqrt( ((GoalX-StateX) * (GoalX-StateX)) + ((GoalY-StateY) * (GoalY-StateY)) ).

{ include("a_star.asl") }
