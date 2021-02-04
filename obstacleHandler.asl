
+temporaryObstacle(Direction)
	:	inPath(Direction)
	<-	honk(horn).
	
	
temporaryObstacle(Direction)
	:-	pedestrian(Direction).
	
inPath(Direction)
	:-	waypoint(Next)
		& position(X,Y)
		& possible(Current,Next)
		& locationName(Current, [X,Y])
		& direction(Current,Next,Direction).
		
{ include("directionRules.asl") }

