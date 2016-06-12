// Public Private Secret master
// O-R-G 

import processing.sound.*;

SoundFile ding, dang, dong, ding_detune, dang_detune, dong_detune;

int x, y;
int h, m, s; 
int lasthour;
int lastmin;
int lastsec;
int delta, gamma;
int fr, speed;
int radius;

boolean accelerate;
boolean verbose = true;

void setup() 
{
    size(960, 960);
    fr = 30;
    speed = 10;
    frameRate(fr);

    stroke(0);
    smooth();
    accelerate = false;

	x = width / 2;
	y = width / 2;
    radius = int(width * .40);

    if (accelerate)
    {
        h = 0;
        m = 0;
        s = 0;
        delta = - (int)(3600 / (fr * speed));
        gamma = 0;
    }
    
    ding = new SoundFile(this, "ding-44k.aif");
    dang = new SoundFile(this, "ding-44k.aif");
    dong = new SoundFile(this, "ding-44k.aif");
    ding_detune = new SoundFile(this, "ding-44k.aif");
    dang_detune = new SoundFile(this, "ding-44k.aif");
    dong_detune = new SoundFile(this, "ding-44k.aif");
	dang.rate(.25);
	dong.rate(.125);
	ding_detune.rate(.99);
	dang_detune.rate(.24);
	dong_detune.rate(.115);
}

void draw() 
{
    background(0);
    noFill();
    stroke(255);
    strokeWeight(3);
    float ha, ma, sa;
    int hl, ml, sl;
    
    ellipse(x, y, radius*2, radius*2);
    
    // Angles for sin() and cos() start at 3 o'clock;
    // subtract HALF_PI to make them start at the top
    
    if (accelerate) {
        /*
		// playback hands
        s = (s + delta);
        if (s >= 60)
            m += s / 60;
        if (m >= 60)
            h += m / 60;
        h = h % 12;
        m = m % 60;
        s = s % 60;
        */
        s = (s + delta);
        if (s < 0)
        {
            m += (int) floor(((float) s ) / 60);
            s += 60;
        }
        if (m < 0)
        {
            h += (int) floor(((float) m ) / 60);
            m += 60;
        }
        if (h < 0)
        {
            h += 12;
        }
        delta += gamma;
    } else {
		// get current time

        h = hour();
        m = minute();
        s = second();    
		if (h == 0) h = 24; // avoid 0 %
		if (m == 0) m = 60;             
		if (s == 0) s = 60;

		lasthour = checkHour(h, lasthour);
		lastmin = checkMin(m, lastmin);
    	lastsec = checkSec(s, lastsec);
    }
  
    sa = map(s, 0, 60, 0, TWO_PI) - HALF_PI;
    ma = map(m + ((float) s) / 60.0, 0, 60, 0, TWO_PI) - HALF_PI;
    ha = map(h % 12 + ((float) m) / 60.0, 0, 12, 0, TWO_PI) - HALF_PI;    
    hl = (int)(radius * 0.50);
    ml = (int)(radius * 0.80);
    sl = (int)(radius * 0.90);

    // seconds
    if (!accelerate)
    {
        strokeWeight(3);
        line(x, x, cos(sa) * sl + x, sin(sa) * sl + y);
    }
    // minutes
    strokeWeight(5);
    line(x, x, cos(ma) * ml + x, sin(ma) * ml + y);
    
    // hours
    strokeWeight(5);
    line(x, x, cos(ha) * hl + x, sin(ha) * hl + y);
}



// timers

int checkHour(int thish, int thislasthour) {
	if (thish != thislasthour) {
		switch (thish) {            
			case 12:
			case 24:
                // something
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

int checkMin(int thism, int thislastmin) {
	if (thism != thislastmin) {
		switch (thism) {            
			case 5:
                // something
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

int checkSec(int thiss, int thislastsec) {
	if (thiss != thislastsec) {
		switch (thiss) {            
			case 10:
			case 40:
                // something
				ding.play();
                if (verbose) println("+ " + thiss);
                thislastsec = thiss;
                break;
			case 20:
			case 50:
                // something
				dang.play();
                if (verbose) println("+ " + thiss);
                thislastsec = thiss;
                break;
			case 30:
			case 60:
                // something
				dong.play();
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








void keyPressed()
{
    switch(key)
    {
        case 'd':
			ding.play();
            break;
        case 'D':
			ding_detune.play();
            break;
        case 's':
			dang.play();
            break;
        case 'S':
			dang_detune.play();
            break;
        case 'a':
			dong.play();
            break;
        case 'A':
			dong_detune.play();
            break;
        default:
            break;
	}
}

