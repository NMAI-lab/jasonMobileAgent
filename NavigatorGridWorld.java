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
import NavigationSupport.*;

public class NavigatorGridWorld extends Environment {

	private NavMap model;
    private NavMapView view;
	
	public static final Term moveUp = Literal.parseLiteral("move(up)");
	public static final Term moveDown = Literal.parseLiteral("move(down)");
	public static final Term moveLeft = Literal.parseLiteral("move(left)");
	public static final Term moveRight = Literal.parseLiteral("move(right)");
	public static final Term dock = Literal.parseLiteral("station(dock)");
	public static final Term undock = Literal.parseLiteral("station(undock)");
	
	static Logger logger;
	private String path;
	
	private GridMap agentsMap;
	
	@Override
    public void init(String[] args) {
		logger = Logger.getLogger("NavigatorGridWorld");
        model = new NavMap();
        view  = new NavMapView(model);
        model.setView(view);
		path = null;
		agentsMap = MapSearchFunctions.getMapInstance();
        updatePercepts();
    }

    @Override
    public boolean executeAction(String ag, Structure action) {
		logger.info(ag+" doing: "+ action);
		boolean acted = false;
        try {
            if (action.equals(moveUp)) {
				model.move("up");
				acted = true;
			} else if (action.equals(moveDown)) {
				model.move("down");
				acted = true;
			} else if (action.equals(moveLeft)) {
				model.move("left");
				acted = true;
			} else if (action.equals(moveRight)) {
				model.move("right");
				acted = true;
			} else if (action.equals(dock)) {
				model.connectCharger();
				acted = true;
			} else if (action.equals(undock)) {
				model.disconnectCharger();
				acted = true;
			} 

			String actionString = action.toString();
			if (actionString.contains("getPath")) {
				path = MapSearchFunctions.getNavigationPath(actionString);
				acted = true;
			} else if (actionString.contains("setObstacle")) {
				MapSearchFunctions.setObstacle(actionString);
				acted = true;
			}
        } catch (Exception e) {
            e.printStackTrace();
        }

        updatePercepts();

        try {
            Thread.sleep(200);
        } catch (Exception e) {}
        informAgsEnvironmentChanged();
        return acted;
    }

    /** creates the agents perception based on the model */
    void updatePercepts() {
        clearPercepts();
		List<String> perceptionStrings = model.perceive();
		System.out.println("\n\n\n!!!!!! PERCEIVE !!!!!\n");
		System.out.println(perceptionStrings.toString());
		System.out.println("\n\n\n");
		Iterator<String> perceptionIterator = perceptionStrings.iterator();
        while (perceptionIterator.hasNext()) {
			Literal perceptLiteral = Literal.parseLiteral(perceptionIterator.next());
			addPercept(perceptLiteral);
        } 
		if (path != null) {
			Literal pathLiteral = Literal.parseLiteral(path);
			addPercept(pathLiteral);
			path = null;
		}
    }
}
