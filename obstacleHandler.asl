
+pedestrian(_)
	<-	.broadcast(tell, pedestrian(honk(horn)));
		honk(horn).

+obstacle(Direction)
	:	position(X,Y) 
		& locationName(Current, [X,Y]) 
		& possible(Current,Next)
		& direction(Current,Next,Direction)
		& missionTo(Destination)
	<-	-possible(Current,Next);
		//setObstacle(Current,Next);
		//.broadcast(tell, obstacle(Direction));
		.drop_all_intentions;
		-missionTo(Destination);
		!missionTo(Destination)[priority(3)].


