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
    
    public double magnitude() {
        return Math.sqrt(x * x + y * y);
    }
    
    public Vector scaled(double scale) {
        return new Vector(x * scale, y * scale);
    }
    
    public Vector normalized() {
        double m = magnitude();
        return new Vector(x / m, y / m);
    }
}
