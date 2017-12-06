import greenfoot.*;

public class Ship extends SmoothMover
{
    private static final int MOVE_SPEED = 480;
    
    public void act() 
    {
        readInput();
    }
    
    public void readInput() {
        if(Greenfoot.isKeyDown("a")) {
            move(-MOVE_SPEED * Background.delta, 0);
        } else if (Greenfoot.isKeyDown("d")) {
            move(MOVE_SPEED * Background.delta, 0);
        }
    }
}
