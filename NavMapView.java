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

	private final int pedestrian = 16;
	private final int charger = 8;
	
    public NavMapView(NavMap model) {
        super(model, "Navigator Grid World", 600);
        defaultFont = new Font("Arial", Font.BOLD, 18); // change default font
        setVisible(true);
        repaint();
    }
	
	public void draw(Graphics g, int x, int y, int object) {
		if (object == pedestrian) {
			drawPedestrian(g, x, y);
		} else if (object == charger) {
			drawCharger(g, x, y);
		}
	}
	
	public void drawCharger(Graphics g, int x, int y) {
		super.drawObstacle(g, x, y);
		g.setColor(Color.green);
		drawString(g, x, y, defaultFont, "CHARGER");
	}
	
	public void drawPedestrian(Graphics g, int x, int y) {
		super.drawObstacle(g, x, y);
		g.setColor(Color.red);
		drawString(g, x, y, defaultFont, "PEDESTRIAN");
	}
}
