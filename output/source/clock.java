import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class clock extends PApplet {

// "clock"
// O-R-G 



/*
// transparent window in process
import processing.awt.PSurfaceAWT;
import javax.swing.JFrame;
JFrame frame;
*/

SoundFile ding, dang, dong;

int x, y;
int h, m, s; 
int hl, ml, sl; 
int lasthour;
int lastmin;
int lastsec;
int delta, gamma;
int speed;
int radius;
int rewindcounter;
int rewindduration;

boolean rewinding;
boolean verbose = true;

PImage titlebaricon;

public void setup() {
    
    surface.setSize(100, 100); 
    surface.setTitle("clock");
    surface.setResizable(true);
    surface.setLocation(0,0);
    titlebaricon = loadImage("clock.png");
    surface.setIcon(titlebaricon);

    /*
    // set window opacity
    frame = getJFrame();
    frame.removeNotify();
    frame.setUndecorated(true);
    frame.setOpacity(0.5f);
    frame.addNotify();
    */

    // for more on surface, see 
    // https://discourse.processing.org/t/how-to-remove-title-bar/7537/7o
    // https://discourse.processing.org/t/is-setundecorated-possible/1097/5
    

    frameRate(60);
    // noCursor();

    stroke(0);
    
	
	x = width / 2;
	y = width / 2;
    radius = PApplet.parseInt(width * .40f);    

    hl = (int)(radius * 0.50f);
    ml = (int)(radius * 0.80f);
    sl = (int)(radius * 0.90f);
    h = 0;
    m = 0;
    s = 0;

    speed = 5;
    delta = -(int)(3600 / (frameRate * speed));
    gamma = 0;

    rewindduration = 60;
    
    ding = new SoundFile(this, "ding-44k.aif");
    dang = new SoundFile(this, "ding-44k.aif");
    dong = new SoundFile(this, "ding-44k.aif");
	dang.rate(.25f);
	dong.rate(.125f);
}

public void draw() {
    background(0,0);
    noFill();
    stroke(255);

    float ha, ma, sa;

    if (!rewinding) {
        h = hour();
        m = minute();
        s = second();
        lasthour = checkHour(h, lasthour);
        lastmin = checkMin(m, lastmin);
        lastsec = checkSec(s, lastsec);
	} else {
        rewind(h,m,s);  // could have this return values
    }

    ha = map(h % 12 + ((float) m) / 60.0f, 0, 12, 0, TWO_PI) - HALF_PI;
    ma = map(m + ((float) s) / 60.0f, 0, 60, 0, TWO_PI) - HALF_PI;
    sa = map(s, 0, 60, 0, TWO_PI) - HALF_PI;

    strokeWeight(1);
    ellipse(x, y, radius*2, radius*2);
    strokeWeight(1);
    line(x, x, cos(sa) * sl + x, sin(sa) * sl + y);
    strokeWeight(2);
    line(x, x, cos(ma) * ml + x, sin(ma) * ml + y);
    strokeWeight(2);
    line(x, x, cos(ha) * hl + x, sin(ha) * hl + y);
}


// animation

public void rewind(int thish, int thism, int thiss) {
    s = (s + delta);        
    if (s >= 60)
        m += s / 60;
    if (m >= 60)
        h += m / 60;
    h = h % 12;
    m = m % 60;
    s = s % 60;
    s = (s + delta);
    if (s < 0) {
        m += (int) floor(((float) s ) / 60);
        s += 60;
    }
    if (m < 0) {
        h += (int) floor(((float) m ) / 60);
        m += 60;
    }
    if (h < 0) {
        h += 12;
    }
    delta += gamma;

    rewindcounter++;    
    if (rewindcounter % rewindduration == 0)
        rewinding = false;

    if (verbose)    
        println(h + ":" + m + ":" + s);
}


// timers

public int checkHour(int thish, int thislasthour) {
    if (thish != thislasthour) {
        switch (thish) {
            case 0:
            case 12:
                if (!rewinding)
                    dong.play();
		        if (verbose) println("+ " + thish);
                thislasthour = thish;
                break;
            default:
                thislasthour = thish - 1;
                break;
		}
	}
	return thislasthour;
}

public int checkMin(int thism, int thislastmin) {
	if (thism != thislastmin) {
		switch (thism) {            
            case 0:
                rewinding =! rewinding;
                ding.play();
                if (verbose) println("+ " + thism);
                thislastmin = thism;
                break;
            default:
                thislastmin = thism - 1;
                break;
		}
	}
	return thislastmin;
}

public int checkSec(int thiss, int thislastsec) {
	if (thiss != thislastsec) {
        switch (thiss) {            
            case 0:
                if (verbose) println("+ " + thiss);
                thislastsec = thiss;
                break;
            default:
                thislastsec = thiss - 1;
                break;
		}
	}
    return thislastsec;
}


// utility

public void keyPressed() {
    switch(key) {
        case 'd':
			ding.play();
            break;
        case 's':
			dang.play();
            break;
        case 'a':
			dong.play();
            break;
        case ' ':
            rewinding =! rewinding;
            dong.play();
            break;
        default:
            break;
	}
}

/*
JFrame getJFrame() {
  PSurfaceAWT surf = (PSurfaceAWT) getSurface();
  PSurfaceAWT.SmoothCanvas canvas = (PSurfaceAWT.SmoothCanvas) surf.getNative();
  return (JFrame) canvas.getFrame();
}
*/
  public void settings() {  fullScreen();  smooth();  pixelDensity(displayDensity()); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#000000", "--hide-stop", "clock" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
