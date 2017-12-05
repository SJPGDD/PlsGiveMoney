import greenfoot.*;

public class Ship extends Actor
{
    private static final int MOVE_SPEED = 480;
    
    public void act() 
    {
        moveHorizontal();
    }
    
    public void moveHorizontal() {
        if(Greenfoot.isKeyDown("a")) {
            setLocation((int) Math.round((getX() - MOVE_SPEED * Background.delta)), getY());
        } else if (Greenfoot.isKeyDown("d")) {
            setLocation((int) Math.round((getX() + MOVE_SPEED * Background.delta)), getY());
        }
    }
}
