
@pedestrianAvoidance [atomic]
+pedestrian(_)
	<-	.broadcast(tell, pedestrian(honk(horn)));
		.wait(1000);
		honk(horn).

+obstacle(Direction)
	:	position(X,Y) 
		& locationName(Current, [X,Y]) 
		& possible(Current,Next)
		& direction(Current,Next,Direction)
		& mission(Goal,Parameters)
	<-	-possible(Current,Next);
		//setObstacle(Current,Next);
		//.broadcast(tell, obstacle(Direction));
		.drop_all_intentions;
		!mission(Goal,Parameters).
		//-missionTo(Destination);
		//!missionTo(Destination)[priority(3)].


