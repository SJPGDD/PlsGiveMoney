import greenfoot.*;

public class Background extends World
{
    public static final int WORLD_WIDTH = 480;
    public static final int WORLD_HEIGHT = 640;
    public static final int PLAYER_HEIGHT = WORLD_HEIGHT - 100;
    
    public static double delta = 0.0;
    public static double timeScale = 1.0;
    private static long lastCheck = 0;
    
    public Background()
    {
        super(WORLD_WIDTH, WORLD_HEIGHT, 1, true);
        Greenfoot.setSpeed(60);
        lastCheck = System.nanoTime();
        spawnShip();
    }
   
    public void act() {
        updateDelta();
    }
    
    private void updateDelta() {
        long now = System.nanoTime();
        long dt = now - lastCheck;
        lastCheck = now;
        delta = (dt / 1_000_000_000.0) * timeScale;
    }
    
    public void spawnShip() {
        addObject(new Ship(), WORLD_WIDTH / 2, PLAYER_HEIGHT);
    }
}
