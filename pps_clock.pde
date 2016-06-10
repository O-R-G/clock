// Public Private Secret Clock
// O-R-G 

IntDict circle;
int h, m, s, delta, gamma, fr, speed;
boolean accelerate;


void setup() 
{
    size(960, 960);
    pixelDensity(2);
    fr = 30;
    speed = 10;
    frameRate(fr);

    stroke(0);
    smooth();
    accelerate = false;
    
    if (accelerate)
    {
        h = 0;
        m = 0;
        s = 0;
        delta = - (int)(3600 / (fr * speed));
        gamma = 0;
    }
    
    circle = new IntDict();
    circle.set("x", width / 2);
    circle.set("y", height / 2);
    circle.set("w", (int)(width * .80));
    circle.set("h", (int)(width * .80));
}

void draw() 
{
    background(0);
    float ha, ma, sa;
    int hl, ml, sl;
    
    int x = circle.get("x");
    int y = circle.get("y");
    int cw = circle.get("w");
    int ch = circle.get("h");
        
    // circle
    noFill();
    stroke(255);
    strokeWeight(3);
    ellipse(x, y, cw, ch);
    
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
    
    sa = map(s, 0, 60, 0, TWO_PI) - HALF_PI;
    ma = map(m + ((float) s) / 60.0, 0, 60, 0, TWO_PI) - HALF_PI;
    ha = map(h % 12 + ((float) m) / 60.0, 0, 12, 0, TWO_PI) - HALF_PI;
    
    hl = (int)(cw / 2 * 0.50);
    ml = (int)(cw / 2 * 0.80);
    sl = (int)(cw / 2 * 0.90);

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
