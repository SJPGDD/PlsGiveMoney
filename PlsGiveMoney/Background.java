import greenfoot.*;

public class Background extends World
{
    public static final int WORLD_WIDTH = 480;
    public static final int WORLD_HEIGHT = 640;
    public static final int PLAYER_HEIGHT = WORLD_HEIGHT - 100;
    
    public static final int GREENFOOT_SPEED = 50;
    
    public static double delta;
    public static double timeScale;
    private static long lastCheck;
    
    public Background()
    {
        super(WORLD_WIDTH, WORLD_HEIGHT, 1, true);
        Greenfoot.setSpeed(GREENFOOT_SPEED);
        lastCheck = System.nanoTime();
        timeScale = 1.0;
        spawnShip();
    }
   
    public void act() {
        updateDelta();
        
        if(Greenfoot.isKeyDown("space")) timeScale = 0.25;
        else timeScale = 1.00;
    }
    
    private void updateDelta() {
        long now = System.nanoTime();
        long dt = now - lastCheck;
        lastCheck = now;
        delta = (dt / 1_000_000_000.0) * timeScale;
        System.out.println(delta);
    }
    
    private void spawnShip() {
        addObject(new Ship(), WORLD_WIDTH / 2, PLAYER_HEIGHT);
    }
}
