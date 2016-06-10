// Public Private Secret Clock
// O-R-G 

import processing.sound.*;

SoundFile ding, dang, dong;

int h, m, s, delta, gamma, fr, speed;
int radius;
int x,y;

int dinginterval, dinglastsec;

boolean accelerate;

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

	dinginterval = 5; // in seconds

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
	dang.rate(.25);
	dong.rate(.125);
}

void draw() 
{
    background(0);
    float ha, ma, sa;
    int hl, ml, sl;
    
    noFill();
    stroke(255);
    strokeWeight(3);
    ellipse(x, y, radius*2, radius*2);
    
    // noStroke();
    // Angles for sin() and cos() start at 3 o'clock;
    // subtract HALF_PI to make them start at the top
    
    if (accelerate)
    {
        /*
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
    }
    else
    {
        h = hour();
        m = minute();
        s = second();
    }
   
	// ding? 
	if (s % dinginterval == 0 && dinglastsec != s) 
	{
		ding.play();
		dinglastsec = s;
	} 

/*
    if (m % compswitchinterval == 0 && compswitchlastmin != m)
    {
        // choose random pixelcomp
        comptype = int(random(0, numcomps));
        compswitchlastmin = m;
    }
*/	



    sa = map(s, 0, 60, 0, TWO_PI) - HALF_PI;
    ma = map(m + ((float) s) / 60.0, 0, 60, 0, TWO_PI) - HALF_PI;
    ha = map(h % 12 + ((float) m) / 60.0, 0, 12, 0, TWO_PI) - HALF_PI;
    
    hl = (int)(radius * 0.50);
    ml = (int)(radius * 0.80);
    sl = (int)(radius * 0.90);

    stroke(255);
    
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

void keyPressed()
{
    switch(key)
    {
        case 'd':
			ding.play();
			dinglastsec = s;
            break;
        case 's':
			dang.play();
			dinglastsec = s;
            break;
        case 'a':
			dong.play();
			dinglastsec = s;
            break;
        default:
            break;
	}
}


