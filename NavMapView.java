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

class NavMapView extends GridWorldView {

    public NavMapView(NavMap model) {
        super(model, "Navigator Grid World", 600);
        defaultFont = new Font("Arial", Font.BOLD, 18); // change default font
        setVisible(true);
        repaint();
    }

        /** draw application objects
        @Override
        public void draw(Graphics g, int x, int y, int object) {
            switch (object) {
            case MarsEnv.GARB:
                drawGarb(g, x, y);
                break;
            }
        }

        @Override
        public void drawAgent(Graphics g, int x, int y, Color c, int id) {
            String label = "R"+(id+1);
            c = Color.blue;
            if (id == 0) {
                c = Color.yellow;
                if (((MarsModel)model).r1HasGarb) {
                    label += " - G";
                    c = Color.orange;
                }
            }
            super.drawAgent(g, x, y, c, -1);
            if (id == 0) {
                g.setColor(Color.black);
            } else {
                g.setColor(Color.white);
            }
            super.drawString(g, x, y, defaultFont, label);
            repaint();
        }

        public void drawGarb(Graphics g, int x, int y) {
            super.drawObstacle(g, x, y);
            g.setColor(Color.white);
            drawString(g, x, y, defaultFont, "G");
        }
*/
}
