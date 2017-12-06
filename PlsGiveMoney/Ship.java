import greenfoot.*;

public class Ship extends SmoothMover
{
    private static final int MOVE_SPEED = 480;
    private static final double FIRING_RATE = 20.0;
    
    private Class<? extends Projectile> projectile = Projectile.class;
    
    private double cooldown;
    
    public void act() 
    {
        readInput();
        processCooldown();
    }
    
    private void readInput() {
        if(Greenfoot.isKeyDown("a")) {
            moveDelta(-MOVE_SPEED, 0);
        } else if (Greenfoot.isKeyDown("d")) {
            moveDelta(MOVE_SPEED, 0);
        }
        
        if(Background.getMouseButton() == 1) {
            if(cooldown <= 0) {
                fireCurrentProjectile();
                cooldown = 1 / FIRING_RATE;
            }
        }
    }
    
    private void processCooldown() {
        cooldown -= Background.delta;
    }
    
    public void fireCurrentProjectile() {
        try {
            Projectile p = (Projectile) projectile.getConstructor(Vector.class).newInstance(getFiringVector());
            getWorld().addObject(p, getX(), getY());
        } catch(Exception e) {}
    }
    
    public Vector getFiringVector() {
        Vector m = Background.getMousePosition();
        Vector toMouseFromShip = new Vector(m.x - getX(), m.y - getY());
        return toMouseFromShip.normalized();
    }
}
