// Internal action code for project search.mas2j

package NavigationInternalAction;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class getPath extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        ts.getAg().getLogger().info("executing internal action 'NavigationInternalAction.getPath'");
        if (true) { // just to show how to throw another kind of exception
            throw new JasonException("not implemented!");
        }

        // everything ok, so returns true
        return true;
    }
}

