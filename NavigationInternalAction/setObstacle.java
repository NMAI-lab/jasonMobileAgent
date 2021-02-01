// Internal action code for project search.mas2j

package navigationInternalAction;

import NavigationSupport.*;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class setObstacle extends DefaultInternalAction {

	public static final int currentIndex = 0;
	public static final int blockedIndex = 1;
	
	private static GridMap map;
	
    @Override

    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        ts.getAg().getLogger().info("executing internal action 'NavigationInternalAction.setObstacle'");
        
		// Maintain the map, don't want it to get garbage collected.
		map = MapSearchFunctions.getMapInstance();
		
		try {
			// Get the parameters
			Term currentPositionTerm = (Term) args[currentIndex];
			Term blockedPositionTerm = (Term) args[blockedIndex];
			
			String currentPositionString;
			String blockedPositionString;
			
			if (currentPositionTerm.isString()) {
				StringTerm currentPositionStringTerm = (StringTerm)currentPositionTerm;
				currentPositionString = currentPositionStringTerm.getString();
			} else if (currentPositionTerm.isAtom()) {
				Atom currentPositionAtom = (Atom)currentPositionTerm;
				currentPositionString = currentPositionAtom.getFunctor();
			} else {
				throw new JasonException("currentPosition parameter format not supported.");
			}
			
			if (blockedPositionTerm.isString()) {
				StringTerm blockedPositionStringTerm = (StringTerm)blockedPositionTerm;
				blockedPositionString = blockedPositionStringTerm.getString();
			} else if (blockedPositionTerm.isAtom()) {
				Atom blockedPositionAtom = (Atom)blockedPositionTerm;
				blockedPositionString = blockedPositionAtom.getFunctor();
			} else {
				throw new JasonException("blockedPosition parameter format not supported.");
			}
			
			// Set the obstacle
			map.setObstacle(currentPositionString, blockedPositionString);
			
        	// everything ok, so returns true
        	return true;
		}
		catch (Exception e) { // just to show how to throw another kind of exception
			ts.getAg().getLogger().severe("getPath Error: " + e.toString());
		}
		return false;	// If we made it here, something went wrong
    }
}
