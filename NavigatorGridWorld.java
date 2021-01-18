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
	
	static Logger logger;
	private String path;
	
	@Override
    public void init(String[] args) {
		logger = Logger.getLogger("NavigatorGridWorld");
        model = new NavMap();
        view  = new NavMapView(model);
        model.setView(view);
		path = null;
        updatePercepts();
    }

    @Override
    public boolean executeAction(String ag, Structure action) {
		logger.info(ag+" doing: "+ action);
        try {
            if (action.equals(moveUp)) {
                model.move("up");
            } else if (action.equals(moveDown)) {
                model.move("down");
			} else if (action.equals(moveLeft)) {
                model.move("left");
			} else if (action.equals(moveRight)) {
                model.move("right");
            } else {
				String actionString = action.toString();
				if (actionString.contains("getPath")) {
					path = MapSearchFunctions.getNavigationPath(actionString);
				} else {
					return false;
				}
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        updatePercepts();

        //try {
        //    Thread.sleep(200);
        //} catch (Exception e) {}
        informAgsEnvironmentChanged();
        return true;
    }

    /** creates the agents perception based on the model */
    void updatePercepts() {
        clearPercepts();
		
		List<String> perceptionStrings = model.perceive();
		//System.out.println("!!!!!! PERCEIVE !!!!!");
		//System.out.println(perceptionStrings.toString());
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
