batteryMin(2).
batteryMax(20).

/**
 * When the battery perception is below the minimum, we need to pickup the goal
 * of !chargeBattery, if we haven't already.
 */
// Check if I'm on a mission, if so, I'll need to launch the mission again
// once the battery is charged.
// Also need to confirm that I'm not already charging the battery. 
+battery(State)
	:	charging(false)
		& lowBattery(State)
		& missionTo(Destination)
	<-	.drop_all_intentions;
		.broadcast(tell, battery(chargingNeeded));
		!chargeBattery;
		.broadcast(tell, battery(chargingFinished));
		!missionTo(Destination).

// No mailMission on the go, just need to charge the battery if I'm not already
// dealing with it.
+battery(State)
	:	charging(false)
		& lowBattery(State)
	<-	.drop_all_intentions;
		.broadcast(tell, battery(chargingNeeded));
		!chargeBattery;
		.broadcast(tell, battery(chargingFinished)).
	
/**
 * !chargeBattery
 * The plan for getting the battery to battery(full) if needed.
 */
 // I'm not docked. Go to the docking station and dock.
 // This is rerursiuve as we need to wait for the battery to charge.
 +!chargeBattery
	:	lowBattery(_)
		& charging(false)
		& chargerLocation(ChargeStation)
	<-	.broadcast(tell, chargeBattery(chargingNeeded));
		!navigate(ChargeStation);
		.broadcast(tell, chargeBattery(atDock));
		station(dock);
		.broadcast(tell, chargeBattery(docked));
		!chargeBattery.
		
// Battery is full, undock the robot
+!chargeBattery
	: 	fullBattery(_)
		& charging(true)
	<-	.broadcast(tell, chargeBattery(charged));
		station(undock);
		.broadcast(tell, chargeBattery(unDocked)).
		
+!chargeBattery 
	<- 	.broadcast(tell, chargeBattery(waiting));
		!chargeBattery.

lowBattery(State)
	:-	battery(State)
		& batteryMin(Min)
		& State <= Min.

fullBattery(State)
	:-	battery(State)
		& batteryMax(State).
		
atStation
	:- 	position(X,Y)
		& locationName(ChargeStation,[X,Y])
		& chargerLocation(ChargeStation).
	
		
