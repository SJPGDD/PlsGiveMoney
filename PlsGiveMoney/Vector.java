public class Vector  
{
    public double x;
    public double y;
    
    public Vector(double x, double y) {
        this.x = x;
        this.y = y;
    }
    
    public Vector(double n)
    {
        this(n, n);
    }
    
    public int rX() {
        return (int) Math.round(x);
    }
    
    public int rY() {
        return (int) Math.round(y);
    }
}
