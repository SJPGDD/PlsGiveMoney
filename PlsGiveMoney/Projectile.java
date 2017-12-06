import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)

/**
 * Write a description of class Projectile here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Projectile extends SmoothMover
{
    private final Vector velocity;
    
    public Projectile(Vector velocity) {
        this.velocity = velocity;
    }
    
    public void act() 
    {
        moveDelta(velocity.scaled(getSpeed()));
        if(isAtEdge()) {
            getWorld().removeObject(this);
        }
    }
    
    protected double getSpeed() {
        return 500.0;
    }
}
