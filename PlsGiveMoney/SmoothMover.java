import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)

/**
 * Write a description of class SmoothMover here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public abstract class SmoothMover extends Actor
{
    private Vector position = new Vector(0);
    
    protected void addedToWorld(World world) {
        position.x = getX();
        position.y = getY();
    }
    
    public void move(Vector displacement) {
        move(displacement.x, displacement.y);
    }
    
    public void move(double x, double y) {
        position.x += x;
        position.y += y;
        setLocation(position.rX(), position.rY());
    }
}
