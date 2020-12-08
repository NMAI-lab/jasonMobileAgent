// Demo program of Jason based navigation using A*

!navigate(a,d).

/*
+!navigate
	<-	InitRule = system.time;		// Get initial time stamp, for benchmarking performance
		
		// a_star(InitialState, Goal, Solution, Cost) 
		?a_star(a,d,Solution,Cost);
		
		// Print the results
		.print("solution A* =", Solution, " with cost ",Cost," in ", (system.time - InitRule), " ms.");
		.
*/

// Get the route plan
+!navigate(Start,Finish)
	//:	//position([X,Y]) & locationName(Current,[X,Y]) &
		//not haveSolution(Solution)
	<-	?a_star(Start,Finish,Solution,Cost);
		//+haveSolution(Solution);
		//move(right);
		//for (.member( op(O,S), Solution)) {
		//	.print("   ",S," <-< ",O);
		//}
		//.queue.remove(Solution,op(initial,_));
		!navigate(Start,Finish);
		.
/*
// Queue has content, remove initial
+!navigate(Start,Finish)
	:	haveSolution(Solution) &
		.length(Solution, Length) &
		Length > 0 &
		.member(Next,Solution) &
		Next = op(initial,_)
	<-	.print("Length of the solution is: ", Length);
		.queue.remove(Solution, Next);
		!navigate.
		
// Queue has content, no initial
+!navigate(Start,Finish)
	:	haveSolution(Solution) &
		.length(Solution, Length) &
		Length > 0 &
		.member(Solution, Next) &
		Next = op(Direction,_)
	<-	.print("Length of the solution is: ", Length);
		.queue.remove(Solution, Next);
		move(Direction);
		!navigate.	
		
+!navigate(Start,Finish) 
	<-	.print("default plan");
		!navigate(Start,Finish).
		
//+!navigate
//	:	start(Start) &
//		finish(Finish) &
//		haveSolution(Solution) &
//		.member(Next,Solution) & 
//		 Next = op(Direction,Cost) &
//		not (Direction = initial)
//	<-	.print("It is a direction: ", Direction);
//		for (.member( op(O,S), Solution)) {
//			.print("   ",S," <-< ",O);
//		}.
		
//+!navigate
//	:	start(Start) &
//		finish(Finish) &
//		haveSolution(Solution) &
//		.member(Next,Solution) & 
//		Next = op(Direction,Cost)
//	<-	.print("Here first");
//		move(Direction);
//		!navigate.
		

// Check that Direction is infact a direction
isDirection(Direction) :- (Direction = up) |
						  (Direction = down) |
						  (Direction = left) |
						  (Direction = right).
		
		
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
