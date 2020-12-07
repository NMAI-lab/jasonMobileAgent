import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.GridWorldModel;
import jason.environment.grid.GridWorldView;
import jason.environment.grid.Location;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.util.*;
import java.util.logging.Logger;


class NavMap extends GridWorldModel {

	public NavMap() {
		super(4, 4, 1); // 4 x 4 grid, 1 agent
		
		// Add the walls
		this.addObstacles();
		
		// Place the agent (ID is 0) on the map at location [0,0]
		setAgPos(0, 0, 3);
	}
	
		
   /* |-------------------------------|
	* |   m   |   n   |   o   |   p   |
	* |       |       |       |   X   |
	* | [0,0] | [1,0] | [2,0] | [3,0] |
	* |-------------------------------|
	* |   i   |   j   |   k   |   l   |
	* |       |   X   |       |       |
	* | [0,1] | [1,1] | [2,1] | [3,1] |
	* |-------------------------------|
	* |   e   |   f   |   g   |   h   |
	* |       |   X   |       |       |
	* | [0,2] | [1,2] | [2,2] | [3,2] |
	* |-------------------------------|
	* |   a   |   b   |   c   |   d   |
	* |       |       |   X   |       |
	* | [0,3] | [1,3] | [2,3] | [3,3] |
	* |-------------------------------|
	*/	
	private void addObstacles() {
		add(OBSTACLE, 2, 3);
		add(OBSTACLE, 1, 2);
		add(OBSTACLE, 1, 1);
		add(OBSTACLE, 3, 0);
	}
	
	// generatePerceptions
	List<String> perceive() {
		Location agentPosition = getAgPos(0);
	
		List<String> perception = new ArrayList<String>();
		perception.add("position(" + agentPosition.toString() + ")");

		// Add perception of obstacles
		perception.addAll(perceiveObstacles());
	
		// Add perception of the map
		perception.addAll(perceiveMap());
		
		return perception;
	}
	
	List<String> perceiveObstacles() {
		Location agentPosition = getAgPos(0);
		
		// Check accessible locations
		boolean obstacleUp = !isFreeOfObstacle(agentPosition.x, agentPosition.y - 1);
		boolean obstacleDown = !isFreeOfObstacle(agentPosition.x, agentPosition.y + 1);
		boolean obstacleLeft = !isFreeOfObstacle(agentPosition.x - 1, agentPosition.y);
		boolean obstacleRight = !isFreeOfObstacle(agentPosition.x + 1, agentPosition.y);
		
		List<String> obstaclePerception = new ArrayList<String>();
		if (obstacleUp) {
			obstaclePerception.add("obstacle(up)");
		}
		if (obstacleDown) {
			obstaclePerception.add("obstacle(down)");
		}
		if (obstacleLeft) {
			obstaclePerception.add("obstacle(left)");
		}
		if (obstacleRight) {
			obstaclePerception.add("obstacle(right)");
		}
		return obstaclePerception;
	}
	
	List<String> perceiveMap() {
		Location agentPosition = getAgPos(0);
		
		// Check accessible locations
		boolean mapUp = inGrid(agentPosition.x, agentPosition.y - 1);
		boolean mapDown = inGrid(agentPosition.x, agentPosition.y + 1);
		boolean mapLeft = inGrid(agentPosition.x - 1, agentPosition.y);
		boolean mapRight = inGrid(agentPosition.x + 1, agentPosition.y);
	
		List<String> mapPerception = new ArrayList<String>();
		if (mapUp) {
			mapPerception.add("map(up)");
		}
		if (mapDown) {
			mapPerception.add("map(down)");
		}
		if (mapLeft) {
			mapPerception.add("map(left)");
		}
		if (mapRight) {
			mapPerception.add("map(right)");
		}
		return mapPerception;
	}
		
		
	// perform actions
	boolean move(String direction) {
		Location agentPosition = getAgPos(0);
		Location newLocation;
	
		if (direction.equals("up")) {
			newLocation = new Location(agentPosition.x, agentPosition.y - 1);
		} else if (direction.equals("down")) {
			newLocation = new Location(agentPosition.x, agentPosition.y + 1);
		} else if (direction.equals("left")) {
			newLocation = new Location(agentPosition.x - 1, agentPosition.y);
		} else if (direction.equals("right")) {
			newLocation = new Location(agentPosition.x + 1, agentPosition.y);
		} else {
			return false;
		}
	
		if (isFree(newLocation)) {
			setAgPos(0, newLocation);
			return true;
		}
		
		// If we made it here, it didn't work
		return false;
	}		
}
